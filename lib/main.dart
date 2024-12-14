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
      title: 'Futsal Teams',
      home: TeamListScreen(),
    );
  }
}

class TeamListScreen extends StatefulWidget {
  @override
  _TeamListScreenState createState() => _TeamListScreenState();
}

class _TeamListScreenState extends State<TeamListScreen> {
  late Future<List<dynamic>> teams;

  Future<List<dynamic>> fetchTeams() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8081/team/get-teams')); // 에뮬레이터에서 localhost 대신 10.0.2.2 사용

    if (response.statusCode == 200) {
      // JSON 응답을 파싱하고 'result' 배열을 반환
      var data = json.decode(response.body);
      return data['result']; // 'result' 안에 있는 팀 리스트만 추출
    } else {
      throw Exception('Failed to load teams');
    }
  }

  @override
  void initState() {
    super.initState();
    teams = fetchTeams(); // API 호출
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Futsal Teams')),
      body: FutureBuilder<List<dynamic>>(
        future: teams,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // 로딩 중 표시
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // 오류 메시지 표시
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No teams found')); // 팀이 없을 때 메시지
          } else {
            // 받은 팀 목록을 ListView로 표시
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var team = snapshot.data![index];
                return ListTile(
                  title: Text(team['name']), // 팀 이름 표시
                  subtitle:
                      Text('Leader ID: ${team['leaderId']}'), // 팀 리더 ID 표시
                );
              },
            );
          }
        },
      ),
    );
  }
}
