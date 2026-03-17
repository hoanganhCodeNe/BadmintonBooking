import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user.dart';
import '../models/court.dart';
import '../models/sub_court.dart';
import '../core/api/api_service.dart';

class OwnerCourtScreen extends StatefulWidget {
  final User user;

  const OwnerCourtScreen({super.key, required this.user});

  @override
  State<OwnerCourtScreen> createState() => _OwnerCourtScreenState();
}

class _OwnerCourtScreenState extends State<OwnerCourtScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _searchController = TextEditingController();
  List<Court> _courts = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCourts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Court> get _visibleCourts {
    final keyword = _searchQuery.trim().toLowerCase();
    if (keyword.isEmpty) return _courts;
    return _courts.where((c) {
      return c.name.toLowerCase().contains(keyword) ||
          c.address.toLowerCase().contains(keyword);
    }).toList();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Tìm theo tên sân, địa chỉ…',
          hintStyle: const TextStyle(fontSize: 13),
          prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF0F5F2),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _loadCourts() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getCourtsByOwner(widget.user.id!);
      if (!mounted) return;
      setState(() {
        _courts = data.map((e) => Court.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openMapByAddress(String address) async {
    final encoded = Uri.encodeComponent(address);
    final mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');

    final launched = await launchUrl(
      mapsUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể mở Google Maps")),
      );
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showCourtDialog({Court? court}) async {
    final isEdit = court != null;
    final nameCtrl = TextEditingController(text: court?.name ?? '');
    final addressCtrl = TextEditingController(text: court?.address ?? '');
    final morningCtrl = TextEditingController(text: (court?.morningPrice ?? 20000).toStringAsFixed(0));
    final afternoonCtrl = TextEditingController(text: (court?.afternoonPrice ?? 50000).toStringAsFixed(0));
    final eveningCtrl = TextEditingController(text: (court?.eveningPrice ?? 80000).toStringAsFixed(0));
    final serverImages = List<String>.from(court?.gallery ?? const <String>[]);
    final localImages = <XFile>[];
    var isSubmitting = false;
    var nameError = '';
    var addressError = '';
    var morningError = '';
    var afternoonError = '';
    var eveningError = '';
    var isFormattingPrice = false;

    String formatVnd(String input) {
      final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.isEmpty) return '';

      final normalized = digits.replaceFirst(RegExp(r'^0+(?=\d)'), '');
      final buffer = StringBuffer();
      for (var i = 0; i < normalized.length; i++) {
        final reversedIndex = normalized.length - i;
        buffer.write(normalized[i]);
        if (reversedIndex > 1 && reversedIndex % 3 == 1) {
          buffer.write('.');
        }
      }
      return buffer.toString();
    }

    double? parseVnd(String input) {
      final cleaned = input.replaceAll('.', '').replaceAll(RegExp(r'[^0-9\-]'), '');
      if (cleaned.isEmpty) return null;
      return double.tryParse(cleaned);
    }

    void normalizePriceField(TextEditingController controller, StateSetter setModalState, {String field = ''}) {
      if (isFormattingPrice) return;
      isFormattingPrice = true;

      final formatted = formatVnd(controller.text);
      if (controller.text != formatted) {
        controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }

      if (field == 'morning' && morningError.isNotEmpty) {
        setModalState(() => morningError = '');
      } else if (field == 'afternoon' && afternoonError.isNotEmpty) {
        setModalState(() => afternoonError = '');
      } else if (field == 'evening' && eveningError.isNotEmpty) {
        setModalState(() => eveningError = '');
      }

      isFormattingPrice = false;
    }

    morningCtrl.text = formatVnd(morningCtrl.text);
    afternoonCtrl.text = formatVnd(afternoonCtrl.text);
    eveningCtrl.text = formatVnd(eveningCtrl.text);

    Future<void> pickImages(StateSetter setModalState) async {
      final pickedImages = await _imagePicker.pickMultiImage(imageQuality: 85);
      if (pickedImages.isEmpty) return;

      final remainingSlots = 5 - serverImages.length - localImages.length;
      if (remainingSlots <= 0) {
        _showMessage('Tối đa chỉ được chọn 5 ảnh');
        return;
      }

      setModalState(() {
        localImages.addAll(pickedImages.take(remainingSlots));
      });

      if (pickedImages.length > remainingSlots) {
        _showMessage('Chỉ giữ 5 ảnh đầu tiên');
      }
    }

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setModalState) {
          final totalImages = serverImages.length + localImages.length;

          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5EE),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              isEdit ? Icons.edit_outlined : Icons.add_business_outlined,
                              color: const Color(0xFF1B8E5A),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isEdit ? 'Chỉnh sửa sân' : 'Tạo sân mới',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  'Ảnh cập nhật ngay trong form, tối đa 5 ảnh.',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: nameCtrl,
                        onChanged: (_) {
                          if (nameError.isEmpty) return;
                          setModalState(() => nameError = '');
                        },
                        decoration: InputDecoration(
                          labelText: 'Tên sân',
                          prefixIcon: const Icon(Icons.sports_tennis),
                          errorText: nameError.isEmpty ? null : nameError,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: addressCtrl,
                        maxLines: 2,
                        onChanged: (_) {
                          if (addressError.isEmpty) return;
                          setModalState(() => addressError = '');
                        },
                        decoration: InputDecoration(
                          labelText: 'Địa chỉ',
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          errorText: addressError.isEmpty ? null : addressError,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ảnh sân',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '$totalImages/5 ảnh',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 104,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: totalImages >= 5 || isSubmitting
                                  ? null
                                  : () => pickImages(setModalState),
                              child: Container(
                                width: 92,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F8F6),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFDCE9E1)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: totalImages >= 5 ? Colors.grey : const Color(0xFF1B8E5A),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Thêm ảnh',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: totalImages >= 5 ? Colors.grey : const Color(0xFF1B8E5A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ...serverImages.asMap().entries.map(
                              (entry) => _buildServerImagePreview(
                                imageUrl: entry.value,
                                onRemove: isSubmitting
                                    ? null
                                    : () => setModalState(() => serverImages.removeAt(entry.key)),
                              ),
                            ),
                            ...localImages.asMap().entries.map(
                              (entry) => _buildLocalImagePreview(
                                imagePath: entry.value.path,
                                onRemove: isSubmitting
                                    ? null
                                    : () => setModalState(() => localImages.removeAt(entry.key)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4FAF6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFD7E8DE)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE4F3EA),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.payments_outlined, size: 17, color: Color(0xFF1B8E5A)),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Bảng giá theo giờ',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: morningCtrl,
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => normalizePriceField(
                                      morningCtrl,
                                      setModalState,
                                      field: 'morning',
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Sáng 6-11h',
                                      suffixText: 'VND',
                                      errorText: morningError.isEmpty ? null : morningError,
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: afternoonCtrl,
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => normalizePriceField(
                                      afternoonCtrl,
                                      setModalState,
                                      field: 'afternoon',
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Chiều 11-17h',
                                      suffixText: 'VND',
                                      errorText: afternoonError.isEmpty ? null : afternoonError,
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: eveningCtrl,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => normalizePriceField(
                                eveningCtrl,
                                setModalState,
                                field: 'evening',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Tối sau 17h',
                                suffixText: 'VND',
                                errorText: eveningError.isEmpty ? null : eveningError,
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isSubmitting ? null : () => Navigator.pop(dialogContext),
                            child: const Text('Hủy'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () async {
                                    final name = nameCtrl.text.trim();
                                    final address = addressCtrl.text.trim();
                                    nameError = '';
                                    addressError = '';

                                    if (name.isEmpty) {
                                      nameError = 'Vui lòng nhập tên sân';
                                    }

                                    if (address.isEmpty) {
                                      addressError = 'Vui lòng nhập địa chỉ';
                                    }

                                    if (nameError.isNotEmpty || addressError.isNotEmpty) {
                                      setModalState(() {});
                                      return;
                                    }

                                    final morning = parseVnd(morningCtrl.text.trim());
                                    final afternoon = parseVnd(afternoonCtrl.text.trim());
                                    final evening = parseVnd(eveningCtrl.text.trim());

                                    var hasPriceError = false;
                                    if (morning == null) {
                                      morningError = 'Giá không hợp lệ';
                                      hasPriceError = true;
                                    } else if (morning < 0) {
                                      morningError = 'Không được âm';
                                      hasPriceError = true;
                                    }

                                    if (afternoon == null) {
                                      afternoonError = 'Giá không hợp lệ';
                                      hasPriceError = true;
                                    } else if (afternoon < 0) {
                                      afternoonError = 'Không được âm';
                                      hasPriceError = true;
                                    }

                                    if (evening == null) {
                                      eveningError = 'Giá không hợp lệ';
                                      hasPriceError = true;
                                    } else if (evening < 0) {
                                      eveningError = 'Không được âm';
                                      hasPriceError = true;
                                    }

                                    if (hasPriceError) {
                                      setModalState(() {});
                                      _showMessage('Vui lòng kiểm tra lại các mức giá');
                                      return;
                                    }

                                    final morningValue = morning!;
                                    final afternoonValue = afternoon!;
                                    final eveningValue = evening!;

                                    setModalState(() => isSubmitting = true);

                                    try {
                                      var finalImageUrls = List<String>.from(serverImages);
                                      final localPaths = localImages.map((image) => image.path).toList();

                                      if (isEdit) {
                                        if (localPaths.isNotEmpty) {
                                          final uploaded = await ApiService.uploadCourtImages(court.id!, localPaths);
                                          finalImageUrls = [...finalImageUrls, ...uploaded].take(5).toList();
                                        }

                                        final success = await ApiService.updateCourt(
                                          court.id!,
                                          name,
                                          address,
                                          imageUrl: finalImageUrls.isEmpty ? null : finalImageUrls.first,
                                          imageUrls: finalImageUrls,
                                          morningPrice: morningValue,
                                          afternoonPrice: afternoonValue,
                                          eveningPrice: eveningValue,
                                        );

                                        if (!mounted) return;
                                        if (success) {
                                          if (dialogContext.mounted) {
                                            Navigator.pop(dialogContext);
                                          }
                                          _showMessage('Đã cập nhật thông tin sân');
                                          _loadCourts();
                                        } else {
                                          setModalState(() => isSubmitting = false);
                                          _showMessage('Cập nhật sân thất bại');
                                        }
                                      } else {
                                        final createdCourt = await ApiService.createCourtDetail(
                                          name,
                                          address,
                                          widget.user.id!,
                                          morningPrice: morningValue,
                                          afternoonPrice: afternoonValue,
                                          eveningPrice: eveningValue,
                                        );

                                        if (createdCourt == null) {
                                          setModalState(() => isSubmitting = false);
                                          _showMessage('Tạo sân thất bại');
                                          return;
                                        }

                                        final courtId = createdCourt['id'] as int;
                                        if (localPaths.isNotEmpty) {
                                          final uploaded = await ApiService.uploadCourtImages(courtId, localPaths);
                                          finalImageUrls = uploaded.take(5).toList();

                                          await ApiService.updateCourt(
                                            courtId,
                                            name,
                                            address,
                                            imageUrl: finalImageUrls.isEmpty ? null : finalImageUrls.first,
                                            imageUrls: finalImageUrls,
                                            morningPrice: morningValue,
                                            afternoonPrice: afternoonValue,
                                            eveningPrice: eveningValue,
                                          );
                                        }

                                        if (!mounted) return;
                                        if (dialogContext.mounted) {
                                          Navigator.pop(dialogContext);
                                        }
                                        _showMessage('Đã thêm sân mới');
                                        _loadCourts();
                                      }
                                    } catch (e) {
                                      setModalState(() => isSubmitting = false);
                                      _showMessage('Lỗi: $e');
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B8E5A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            ),
                            child: isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : Text(isEdit ? 'Lưu thay đổi' : 'Tạo sân'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServerImagePreview({
    required String imageUrl,
    required VoidCallback? onRemove,
  }) {
    return Container(
      width: 92,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              width: 92,
              height: 104,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 92,
                height: 104,
                color: const Color(0xFFEFF4F1),
                child: const Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: _buildRemoveImageButton(onRemove),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalImagePreview({
    required String imagePath,
    required VoidCallback? onRemove,
  }) {
    return Container(
      width: 92,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              File(imagePath),
              width: 92,
              height: 104,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xCC1B8E5A),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Mới',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: _buildRemoveImageButton(onRemove),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveImageButton(VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.58),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, size: 14, color: Colors.white),
      ),
    );
  }

  Widget _buildPricePill(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text('${(value / 1000).round()}k/h', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildCourtCard(Court court) {
    final gallery = court.gallery;
    final coverImage = court.coverImage;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: coverImage == null
                ? Container(
                    height: 150,
                    color: const Color(0xFFEAF4EE),
                    child: const Center(
                      child: Icon(Icons.photo_library_outlined, size: 42, color: Color(0xFF89A897)),
                    ),
                  )
                : Image.network(
                    coverImage,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: const Color(0xFFEAF4EE),
                      child: const Center(
                        child: Icon(Icons.broken_image_outlined, size: 42, color: Color(0xFF89A897)),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        court.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF163C2C)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5EE),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${gallery.length} ảnh',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF1B8E5A)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _openMapByAddress(court.address),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF6C8377)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          court.address,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF61786C), height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPricePill('Sáng', court.morningPrice, Colors.blue.shade700),
                    _buildPricePill('Chiều', court.afternoonPrice, Colors.orange.shade700),
                    _buildPricePill('Tối', court.eveningPrice, Colors.deepPurple.shade700),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _openSubCourtManager(court),
                        icon: const Icon(Icons.tune, size: 18),
                        label: const Text('Sân con'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showCourtDialog(court: court),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B8E5A),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Chỉnh sửa'),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Xóa sân',
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteCourt(court),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openSubCourtManager(Court court) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _OwnerSubCourtScreen(court: court)),
    );
    _loadCourts();
  }

  Future<void> _deleteCourt(Court court) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xóa sân"),
        content: Text("Bạn có chắc muốn xóa ${court.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Không"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await ApiService.deleteCourt(court.id!);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã xóa sân")),
      );
      _loadCourts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể xóa sân này")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF7),
      body: RefreshIndicator(
        onRefresh: () async => _loadCourts(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sân của bạn',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF163C2C)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Quản lý ảnh, giá theo ca và sân con trong một nơi gọn gàng.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _buildInfoChip(Icons.storefront_outlined, '${_courts.length} sân'),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.photo_library_outlined, 'Tối đa 5 ảnh/sân'),
                    ],
                  ),
                  _buildSearchBar(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_visibleCourts.isEmpty && _searchQuery.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      'Không tìm thấy sân nào cho\n"$_searchQuery"',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            else if (_courts.isEmpty)
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.cottage_outlined, size: 48, color: Color(0xFF91A89B)),
                    SizedBox(height: 12),
                    Text('Bạn chưa có sân nào', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    SizedBox(height: 6),
                    Text(
                      'Bấm nút thêm ở dưới để tạo sân mới và tải ảnh trực tiếp từ thư viện máy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF698073), height: 1.45),
                    ),
                  ],
                ),
              )
            else
              ..._visibleCourts.map(_buildCourtCard),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCourtDialog(),
        backgroundColor: const Color(0xFF1B8E5A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_business_outlined),
        label: const Text('Thêm sân'),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4EE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF1B8E5A)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1B8E5A))),
        ],
      ),
    );
  }
}

class _OwnerSubCourtScreen extends StatefulWidget {
  final Court court;

  const _OwnerSubCourtScreen({required this.court});

  @override
  State<_OwnerSubCourtScreen> createState() => _OwnerSubCourtScreenState();
}

class _OwnerSubCourtScreenState extends State<_OwnerSubCourtScreen> {
  List<SubCourt> _subCourts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubCourts();
  }

  Future<void> _loadSubCourts() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getSubCourts(widget.court.id!);
      if (!mounted) return;
      setState(() {
        _subCourts = data.map((e) => SubCourt.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showSubCourtDialog({SubCourt? subCourt}) async {
    final nameCtrl = TextEditingController(text: subCourt?.name ?? "");
    final isEdit = subCourt != null;
    nameCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: nameCtrl.text.length),
    );

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? "Sửa sân con" : "Thêm sân con"),
        content: TextField(
          controller: nameCtrl,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          enableSuggestions: false,
          decoration: const InputDecoration(labelText: "Tên sân con (vd: Sân 1)"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;

              Navigator.pop(ctx);
              bool success;
              if (isEdit) {
                success = await ApiService.updateSubCourt(subCourt.id!, name, widget.court.id!);
              } else {
                success = await ApiService.createSubCourt(name, widget.court.id!);
              }

              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEdit ? "Đã cập nhật sân con" : "Đã thêm sân con"),
                  ),
                );
                _loadSubCourts();
              }
            },
            child: Text(isEdit ? "Lưu" : "Thêm"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSubCourt(SubCourt subCourt) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xóa sân con"),
        content: Text("Bạn có chắc muốn xóa ${subCourt.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Không"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await ApiService.deleteSubCourt(subCourt.id!);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã xóa sân con")),
      );
      _loadSubCourts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sân con - ${widget.court.name}")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _subCourts.isEmpty
              ? const Center(child: Text("Chưa có sân con nào"))
              : RefreshIndicator(
                  onRefresh: _loadSubCourts,
                  child: ListView.builder(
                    itemCount: _subCourts.length,
                    itemBuilder: (context, index) {
                      final subCourt = _subCourts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: const Icon(Icons.sports, color: Colors.blue),
                          ),
                          title: Text(
                            subCourt.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange.shade700),
                                onPressed: () => _showSubCourtDialog(subCourt: subCourt),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteSubCourt(subCourt),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSubCourtDialog(),
        icon: const Icon(Icons.add),
        label: const Text("Thêm sân con"),
      ),
    );
  }
}
