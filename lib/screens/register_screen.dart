import 'package:flutter/material.dart';
import '../repositories/user_repository.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final RegExp _phoneRegex = RegExp(r'^0\d{9,10}$');
  String? _nameError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  String _normalizePhone(String input) {
    var phone = input.trim().replaceAll(' ', '').replaceAll('.', '').replaceAll('-', '');
    if (phone.startsWith('+84')) {
      phone = '0${phone.substring(3)}';
    } else if (phone.startsWith('84')) {
      phone = '0${phone.substring(2)}';
    }
    return phone;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1B8E5A)),
      suffixIcon: suffix,
      errorText: errorText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD5E9DD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD5E9DD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1B8E5A), width: 1.5),
      ),
    );
  }

  String? _validatePassword(String password) {
    final missing = <String>[];

    if (password.length < 6) {
      missing.add('Ít nhất có 6 ký tự');
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      missing.add('Chữ hoa');
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      missing.add('Chữ thường');
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      missing.add('Số');
    }

    if (missing.isEmpty) return null;
    return 'Mật khẩu thiếu: ${missing.join(', ')}';
  }

  bool _validateInputs() {
    final name = nameController.text.trim();
    final phone = _normalizePhone(phoneController.text);
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    String? nameError;
    String? phoneError;
    String? passwordError;
    String? confirmPasswordError;

    if (name.isEmpty) {
      nameError = 'Vui lòng nhập tên người chơi';
    } else if (name.length < 2) {
      nameError = 'Tên người chơi phải có ít nhất 2 ký tự';
    }

    if (phone.isEmpty) {
      phoneError = 'Vui lòng nhập số điện thoại';
    } else if (!_phoneRegex.hasMatch(phone)) {
      phoneError = 'Số điện thoại không hợp lệ';
    }

    if (password.isEmpty) {
      passwordError = 'Vui lòng nhập mật khẩu';
    } else {
      passwordError = _validatePassword(password);
    }

    if (confirmPassword.isEmpty) {
      confirmPasswordError = 'Vui lòng xác nhận mật khẩu';
    } else if (confirmPassword != password) {
      confirmPasswordError = 'Mật khẩu xác nhận không khớp';
    }

    setState(() {
      _nameError = nameError;
      _phoneError = phoneError;
      _passwordError = passwordError;
      _confirmPasswordError = confirmPasswordError;
    });

    return nameError == null &&
        phoneError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE9F7EF), Color(0xFFF5FBF7)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x17000000),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF1B8E5A),
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Tạo tài khoản mới',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF153C2B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Sẵn sàng cho những trận cầu đỉnh cao.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Color(0xFF5B6E64)),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: nameController,
                        decoration: _inputDecoration(
                          label: 'Tên người chơi',
                          icon: Icons.person_outline,
                          errorText: _nameError,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration(
                          label: 'Số điện thoại',
                          icon: Icons.phone_android,
                          errorText: _phoneError,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration(
                          label: 'Mật khẩu',
                          icon: Icons.lock_outline,
                          errorText: _passwordError,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF4D6F5E),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: _inputDecoration(
                          label: 'Xác nhận mật khẩu',
                          icon: Icons.verified_user_outlined,
                          errorText: _confirmPasswordError,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF4D6F5E),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Mật khẩu tối thiểu 6 ký tự, gồm chữ hoa, chữ thường và số.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF667C70)),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        height: 50,
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1B8E5A),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () async {
                                  final name = nameController.text.trim();
                                  final phone = _normalizePhone(phoneController.text);
                                  final password = passwordController.text.trim();

                                  if (!_validateInputs()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Vui lòng sửa các trường bị lỗi')),
                                    );
                                    return;
                                  }

                                  setState(() => _isLoading = true);

                                  try {
                                    final repo = UserRepository();
                                    await repo.register(name, phone, password);

                                    if (!mounted) return;
                                    setState(() => _isLoading = false);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Đăng ký thành công!')),
                                    );

                                    await Future.delayed(const Duration(seconds: 1));
                                    if (!mounted) return;
                                    Navigator.pop(context);
                                  } catch (e) {
                                    if (!mounted) return;
                                    setState(() => _isLoading = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${e.toString().replaceFirst('Exception: ', '')}",
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.app_registration),
                                label: const Text(
                                  'Đăng ký',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text('Quay lại đăng nhập'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}