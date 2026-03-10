import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Đăng nhập"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Số điện thoại",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mật khẩu",
              ),
            ),

            const SizedBox(height: 30),

            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(

              onPressed: () async {
                final phone = phoneController.text.trim();
                final password = passwordController.text.trim();

                if (phone.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
                  );
                  return;
                }

                setState(() => _isLoading = true);

                try {
                  final repo = UserRepository();
                  final user = await repo.login(phone, password);

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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${e.toString().replaceFirst('Exception: ', '')}")),
                  );
                }
              },

              child: const Text("Đăng nhập"),
            ),

            const SizedBox(height: 20),

            TextButton(

              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );

              },

              child: const Text("Chưa có tài khoản? Đăng ký"),
            )

          ],
        ),
      ),
    );
  }
}