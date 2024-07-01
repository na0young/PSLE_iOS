import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              const Text(
                '아동영님',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color.fromARGB(255, 255, 111, 111)),
                onPressed: () {
                  // 로직 추가
                },
                child: const Text(
                  '로그아웃',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80), // AppBar와 Box 사이 간격
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15), // 정서 반복 기록 Text위 여백
                  Text(
                    '정서 반복 기록',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10), // 정서 반복 기록 과 최근 기록 시간 사이 여백
                  Text(
                    '최근 기록 시간 : 2024-01-17 13:31',
                    style: TextStyle(
                      color: Color.fromARGB(255, 61, 61, 61),
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15), // 최근 기록 시간 Text 밑 여백
                ],
              ),
            ),
            const SizedBox(height: 100), // Box와 기록하러가기 버튼 사이 여백
            Container(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 111, 111),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                onPressed: () {
                  // 웹뷰 이동 로직
                },
                child: const Text(
                  '기록하러 가기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8), // 기록하러 가기 버튼과 동기화 버튼 사이 여백
            Container(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 111, 111),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  // 동기화 로직
                },
                child: const Text(
                  '알람 시간 동기화',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
