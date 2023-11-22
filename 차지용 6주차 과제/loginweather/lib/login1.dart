import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'login2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginFirst extends StatefulWidget {
  const LoginFirst({Key? key}) : super(key: key);

  @override
  _LoginFirstState createState() => _LoginFirstState();
}

class _LoginFirstState extends State<LoginFirst> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  String REFRESH_TOKEN_KEY = 'refreshToken';
  String ACCESS_TOKEN_KEY = 'accessToken';
  String ip = 'http://127.0.0.1:3000/auth/login';
  final dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "환영합니다!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text("이메일과 비밀번호를 입력해서 로그인 해주세요!"),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text("오늘도 성공적인 주문이 되길~"),
            ),
            Image.asset("assets/bm.jpeg"),

            Form( key: _formKey,
             child: Column(children: [
              TextFormField(
              controller: _emailController, // 사용자가 입력한 이메일 값을 가져오기 위해 컨트롤러를 할당합니다.
              decoration: const InputDecoration(hintText: '이메일을 입력하세요'),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return "이메일을 입력해주세요";
                }
                return null;
              },
            ),
              TextFormField(
              controller: _passwordController, // 사용자가 입력한 비밀번호 값을 가져오기 위해 컨트롤러를 할당합니다.
              obscureText: true,
              decoration: const InputDecoration(hintText: '비밀번호를 입력하세요'),
              validator: (value) {
                if (value == null || value.length <= 6) {
                  return "6자이상 입력해주세요";
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data'),),
                  );
                }
                try {
                  String user_id = _emailController.text;
                  String user_pw = _passwordController.text;

                  // ID, 비밀번호를 포함한 문자열 생성
                  final rawString = '$user_id:$user_pw';

                  Codec<String, String> stringTobase64 = utf8.fuse(base64);
                  String token = stringTobase64.encode(rawString);

                  // dio을 사용하여 서버에서 POST 요청
                  final response = await dio.post(
                    '$ip',
                    options: Options(
                      headers: {'authorization': 'Basic $token'},
                    ),
                  );
                  // 서버에서 refreshToken, accessToken 가져오기
                  final refreshToken = response.data['refreshToken'];
                  final accessToken = response.data['accessToken'];
                  await storage.write(
                    key: REFRESH_TOKEN_KEY,
                    value: refreshToken,
                  );
                  await storage.write(
                    key: ACCESS_TOKEN_KEY,
                    value: accessToken,
                  );

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => LoginSecond()),
                  );
                } catch (e) {
                  print(e);
                }
                
              },
              child: const Text('로그인'),
            ),
            TextButton(
              onPressed: () async {
                final refreshToken = await storage.read(
                  key: REFRESH_TOKEN_KEY,
                );
                final response = await dio.post(
                  'http://$ip/auth/token',
                  options: Options(
                    headers: {
                      'authorization ' : 'Bearer $refreshToken',
          
                    },
                  ),
                );
                print(response.data);
              },
              child: const Text('회원가입'),
            ),
             ],),
            ) 
          ],
        ),
      ),
    );
  }
}
