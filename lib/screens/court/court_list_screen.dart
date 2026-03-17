import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/court.dart';
import '../../models/user.dart';
import '../../repositories/court_repository.dart';
import 'court_detail_screen.dart';

enum CourtSortOption { nameAsc, nameDesc, subCourtCountAsc, subCourtCountDesc }

class CourtListScreen extends StatefulWidget {
  final User user;

  const CourtListScreen({super.key, required this.user});

  @override
  State<CourtListScreen> createState() => _CourtListScreenState();
}

class _CourtListScreenState extends State<CourtListScreen> {
  final CourtRepository repository = CourtRepository();
  final TextEditingController _searchController = TextEditingController();

  List<Court> _courts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  CourtSortOption _sortOption = CourtSortOption.nameAsc;

  @override
  void initState() {
    super.initState();
    loadCourts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void loadCourts() async {
    try {
      final data = await repository.getAllCourts();
      if (!mounted) return;
      setState(() {
        _courts = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi tải danh sách sân: $e')));
    }
  }

  List<Court> get _visibleCourts {
    final filtered = _courts.where((court) {
      final keyword = _searchQuery.trim().toLowerCase();
      if (keyword.isEmpty) {
        return true;
      }
      return court.name.toLowerCase().contains(keyword);
    }).toList();

    filtered.sort((first, second) {
      switch (_sortOption) {
        case CourtSortOption.nameAsc:
          return first.name.toLowerCase().compareTo(second.name.toLowerCase());
        case CourtSortOption.nameDesc:
          return second.name.toLowerCase().compareTo(first.name.toLowerCase());
        case CourtSortOption.subCourtCountAsc:
          final countCompare = first.subCourtCount.compareTo(
            second.subCourtCount,
          );
          if (countCompare != 0) {
            return countCompare;
          }
          return first.name.toLowerCase().compareTo(second.name.toLowerCase());
        case CourtSortOption.subCourtCountDesc:
          final countCompare = second.subCourtCount.compareTo(
            first.subCourtCount,
          );
          if (countCompare != 0) {
            return countCompare;
          }
          return first.name.toLowerCase().compareTo(second.name.toLowerCase());
      }
    });

    return filtered;
  }

  Future<void> _openMapByAddress(String address) async {
    final encoded = Uri.encodeComponent(address);
    final mapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encoded',
    );

    final launched = await launchUrl(
      mapsUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Không thể mở Google Maps')));
    }
  }

  void _openDetail(Court court) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourtDetailScreen(court: court, user: widget.user),
      ),
    );
  }

  String _sortLabel(CourtSortOption option) {
    switch (option) {
      case CourtSortOption.nameAsc:
        return 'A-Z';
      case CourtSortOption.nameDesc:
        return 'Z-A';
      case CourtSortOption.subCourtCountAsc:
        return 'Sân con tăng';
      case CourtSortOption.subCourtCountDesc:
        return 'Sân con giảm';
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleCourts = _visibleCourts;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async => loadCourts(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
                const Text(
                  'Danh sách sân',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF173E2D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${visibleCourts.length} sân phù hợp',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6A7C72),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm theo tên sân',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                    filled: true,
                    fillColor: const Color(0xFFF5F8F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sắp xếp',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF456454),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: CourtSortOption.values.map((option) {
                    final selected = option == _sortOption;
                    return ChoiceChip(
                      label: Text(_sortLabel(option)),
                      selected: selected,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: selected
                            ? Colors.white
                            : const Color(0xFF365545),
                        fontWeight: FontWeight.w600,
                      ),
                      selectedColor: const Color(0xFF1B8E5A),
                      backgroundColor: const Color(0xFFF2F6F3),
                      side: BorderSide.none,
                      onSelected: (_) {
                        setState(() {
                          _sortOption = option;
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_courts.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: Text('Chưa có sân nào')),
            )
          else if (visibleCourts.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 42,
                    color: Color(0xFF93A79A),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Không tìm thấy sân phù hợp',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Thử lại từ khóa hoặc tiêu chí sắp xếp.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF6A7C72)),
                  ),
                ],
              ),
            )
          else
            ...visibleCourts.map(
              (court) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _openDetail(court),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7F5EE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.sports_tennis,
                              color: Color(0xFF1B8E5A),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        court.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF153C2B),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5EE),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        '${court.subCourtCount} sân',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1B8E5A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 13,
                                      color: Color(0xFF93A79A),
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        court.address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6A7C72),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          _openMapByAddress(court.address),
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: Icon(
                                          Icons.map_outlined,
                                          size: 18,
                                          color: Color(0xFF1B8E5A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Color(0xFFB0C4BB),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
