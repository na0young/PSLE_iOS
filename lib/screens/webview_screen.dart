import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:psle/models/user.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({super.key});

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  WebViewController? controller;
  String? userId;
  String? userPw;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('loginId');
      userPw = prefs.getString('password');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null || userPw == null) {
      return Scaffold(
        body: const Center(
          child: Text('오류: 사용자 정보가 누락되었습니다.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '정서 반복 기록',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: WebView(
        onWebViewCreated: (WebViewController controller) {
          this.controller = controller;
        },
        initialUrl:
            'http://210.125.94.114:8080/PSLE/doLogin?userid=$userId&userpw=$userPw',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
