import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API 통신 테스트',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _message = '서버에서 데이터를 불러오는 중...';

  // API 호출 메서드
  Future<void> fetchMessage() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/message'));

      print('응답 상태 코드: ${response.statusCode}');
      print('응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _message = data['message'];
        });
      } else {
        setState(() {
          _message = '서버에서 오류가 발생했습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'API 호출 중 오류 발생: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessage(); // 앱 실행 시 자동으로 호출
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API 통신 테스트'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _message,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchMessage,
                child: Text('다시 호출'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
