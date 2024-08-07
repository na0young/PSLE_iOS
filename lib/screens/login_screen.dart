import 'package:flutter/material.dart';
import 'package:psle/screens/home_screen.dart';
import 'package:psle/services/alarm_service.dart';
import 'package:psle/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  final AlarmService alarmService = AlarmService();

  Future<void> _login() async {
    try {
      final user = await apiService.postUser(
        idController.text,
        passwordController.text,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.id!);
      await prefs.setString('loginId', user.loginId!);
      await prefs.setString('password', user.password!);
      await prefs.setString('userName', user.name!);
      await prefs.setStringList('alarmTimes', user.alarmTimes ?? []);
      await prefs.setBool('isLoggedIn', true);

      if (!mounted) return;
      await alarmService.syncAlarmTimes(); // 알람시간 동기화
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PSLE',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '정서 반복 기록 알림',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                labelText: 'ID',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                labelText: 'Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 111, 111),
                ),
                onPressed: _login,
                child: const Text(
                  '로그인',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}
