import 'package:flutter/material.dart';
import '../core/storage/session_manager.dart';
import '../repositories/user_repository.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final RegExp _phoneRegex = RegExp(r'^0\d{9,10}$');

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
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1B8E5A)),
      suffixIcon: suffix,
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
                            Icons.sports_tennis,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Chào mừng trở lại!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF153C2B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Đăng nhập để đặt sân cầu lông nhanh hơn.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Color(0xFF5B6E64)),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration(
                          label: 'Số điện thoại',
                          icon: Icons.phone_android,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration(
                          label: 'Mật khẩu',
                          icon: Icons.lock_outline,
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
                                  final phone = _normalizePhone(phoneController.text);
                                  final password = passwordController.text.trim();

                                  if (phone.isEmpty || password.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Vui lòng nhập đầy đủ thông tin'),
                                      ),
                                    );
                                    return;
                                  }

                                  if (!_phoneRegex.hasMatch(phone)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Số điện thoại không hợp lệ'),
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() => _isLoading = true);

                                  try {
                                    final repo = UserRepository();
                                    final user = await repo.login(phone, password);
                                    await SessionManager.saveUser(user);

                                    if (!mounted) return;
                                    setState(() => _isLoading = false);

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(user: user),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!mounted) return;
                                    setState(() => _isLoading = false);
                                    var msg = e.toString().replaceFirst('Exception: ', '');
                                    if (msg.contains('ClientException') || msg.contains('SocketException')) {
                                      msg = 'Khong ket noi duoc server. Vui long kiem tra backend.';
                                    } else if (msg.contains('TimeoutException')) {
                                      msg = 'Ket noi den server bi timeout. Vui long kiem tra IP LAN va backend.';
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(msg),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.login),
                                label: const Text(
                                  'Đăng nhập',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text('Chưa có tài khoản? Đăng ký ngay'),
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