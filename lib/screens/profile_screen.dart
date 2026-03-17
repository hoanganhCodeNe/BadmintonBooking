import 'package:flutter/material.dart';

import '../core/api/api_service.dart';
import '../core/storage/session_manager.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final ValueChanged<User> onUserUpdated;

  const ProfileScreen({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _updatingProfile = false;
  bool _changingPassword = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  String? _nameError;
  String? _phoneError;
  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearProfileErrors() {
    _nameError = null;
    _phoneError = null;
  }

  void _clearPasswordErrors() {
    _currentPasswordError = null;
    _newPasswordError = null;
    _confirmPasswordError = null;
  }

  bool _validateProfileInputs(String name, String phone) {
    _clearProfileErrors();
    var valid = true;

    if (name.isEmpty) {
      _nameError = 'Vui lòng nhập họ tên';
      valid = false;
    }

    if (phone.isEmpty) {
      _phoneError = 'Vui lòng nhập số điện thoại';
      valid = false;
    }

    return valid;
  }

  bool _validatePasswordInputs(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) {
    _clearPasswordErrors();
    var valid = true;

    if (currentPassword.isEmpty) {
      _currentPasswordError = 'Vui lòng nhập mật khẩu hiện tại';
      valid = false;
    }

    if (newPassword.isEmpty) {
      _newPasswordError = 'Vui lòng nhập mật khẩu mới';
      valid = false;
    }

    if (confirmPassword.isEmpty) {
      _confirmPasswordError = 'Vui lòng nhập lại mật khẩu mới';
      valid = false;
    }

    if (newPassword.isNotEmpty && confirmPassword.isNotEmpty && newPassword != confirmPassword) {
      _confirmPasswordError = 'Xác nhận mật khẩu mới chưa khớp';
      valid = false;
    }

    return valid;
  }

  void _applyProfileServerError(String message) {
    if (message.toLowerCase().contains('số điện thoại')) {
      _phoneError = message;
      return;
    }

    if (message.toLowerCase().contains('thông tin')) {
      _nameError ??= message;
      return;
    }

    _showMessage(message);
  }

  void _applyPasswordServerError(String message) {
    if (message.toLowerCase().contains('hiện tại')) {
      _currentPasswordError = message;
      return;
    }

    if (message.toLowerCase().contains('mật khẩu mới')) {
      _newPasswordError = message;
      return;
    }

    _showMessage(message);
  }

  Future<void> _updateProfile() async {
    final userId = widget.user.id;
    if (userId == null) {
      _showMessage('Không xác định được tài khoản');
      return;
    }

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (!_validateProfileInputs(name, phone)) {
      setState(() {});
      return;
    }

    setState(() => _updatingProfile = true);
    try {
      final updatedJson = await ApiService.updateProfile(userId, name, phone);
      if (!mounted) return;

      final updatedUser = User.fromJson(updatedJson);
      await SessionManager.saveUser(updatedUser);
      widget.onUserUpdated(updatedUser);

      if (!mounted) return;
      setState(_clearProfileErrors);
      _showMessage('Cập nhật thông tin thành công');
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (!mounted) return;
      setState(() => _applyProfileServerError(message));
    } finally {
      if (mounted) {
        setState(() => _updatingProfile = false);
      }
    }
  }

  Future<void> _changePassword() async {
    final userId = widget.user.id;
    if (userId == null) {
      _showMessage('Không xác định được tài khoản');
      return;
    }

    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (!_validatePasswordInputs(currentPassword, newPassword, confirmPassword)) {
      setState(() {});
      return;
    }

    setState(() => _changingPassword = true);
    try {
      await ApiService.changePassword(userId, currentPassword, newPassword);
      if (!mounted) return;

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      if (!mounted) return;
      setState(_clearPasswordErrors);
      _showMessage('Đổi mật khẩu thành công');
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (!mounted) return;
      setState(() => _applyPasswordServerError(message));
    } finally {
      if (mounted) {
        setState(() => _changingPassword = false);
      }
    }
  }

  InputDecoration _decoration(
    String label,
    IconData icon, {
    String? errorText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      errorText: errorText,
      prefixIcon: Icon(icon, color: const Color(0xFF1B8E5A)),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF5FAF7),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1B8E5A), width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD84343), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD84343), width: 1.2),
      ),
    );
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'owner':
        return 'Chủ sân';
      case 'player':
        return 'Người chơi';
      case 'admin':
        return 'Quản trị';
      default:
        return role;
    }
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 22,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Color(0xFF18392C)),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _nameController.text.trim().isEmpty ? widget.user.name : _nameController.text.trim();
    final avatarText = (name.isNotEmpty ? name.characters.first : 'U').toUpperCase();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF0F7D4E), Color(0xFF29A06A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2B1B8E5A),
                  blurRadius: 26,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                  ),
                  child: Text(
                    avatarText,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trang cá nhân',
                        style: TextStyle(fontSize: 14, color: Color(0xCFFFFFFF)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _roleLabel(widget.user.role),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Thông tin cá nhân',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  onChanged: (_) {
                    if (_nameError == null) return;
                    setState(() => _nameError = null);
                  },
                  decoration: _decoration(
                    'Họ và tên',
                    Icons.person_outline,
                    errorText: _nameError,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: (_) {
                    if (_phoneError == null) return;
                    setState(() => _phoneError = null);
                  },
                  decoration: _decoration(
                    'Số điện thoại',
                    Icons.phone_outlined,
                    errorText: _phoneError,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _updatingProfile ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B8E5A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: _updatingProfile
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(_updatingProfile ? 'Đang lưu...' : 'Lưu thông tin'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _sectionCard(
            title: 'Đổi mật khẩu',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: !_showCurrentPassword,
                    onChanged: (_) {
                      if (_currentPasswordError == null) return;
                      setState(() => _currentPasswordError = null);
                    },
                    decoration: _decoration(
                      'Mật khẩu hiện tại',
                      Icons.lock_outline,
                      errorText: _currentPasswordError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showCurrentPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() => _showCurrentPassword = !_showCurrentPassword);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: !_showNewPassword,
                    onChanged: (_) {
                      if (_newPasswordError == null) return;
                      setState(() => _newPasswordError = null);
                    },
                    decoration: _decoration(
                      'Mật khẩu mới',
                      Icons.lock_reset_outlined,
                      errorText: _newPasswordError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showNewPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() => _showNewPassword = !_showNewPassword);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    onChanged: (_) {
                      if (_confirmPasswordError == null) return;
                      setState(() => _confirmPasswordError = null);
                    },
                    decoration: _decoration(
                      'Nhập lại mật khẩu mới',
                      Icons.verified_user_outlined,
                      errorText: _confirmPasswordError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() => _showConfirmPassword = !_showConfirmPassword);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F7F3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, size: 14, color: Color(0xFF4A6B5B)),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Mật khẩu phải có ít nhất 6 ký tự, gồm chữ hoa, chữ thường và số.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF4A6B5B)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _changingPassword ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF163C2C),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: _changingPassword
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.password_outlined),
                      label: Text(_changingPassword ? 'Đang đổi...' : 'Đổi mật khẩu'),
                    ),
                  ),
                ],
            ),
          ),
        ],
      ),
    );
  }
}
