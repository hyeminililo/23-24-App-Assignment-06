import 'package:flutter/material.dart';
import 'package:weather_application/Login/loginToken.dart';
import 'package:weather_application/Weather/weatherScreen.dart';
import 'package:weather_application/Login/customTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? idErrorText;
  String? pwErrorText;

  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final LoginToken loginToken = LoginToken();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //로그인을 성공헀을 때 실행할 함수 onloginsuccess를 통해 weatherScreen으로 이동
  void _onLoginSuccess(BuildContext context) {
    print('성공');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const WeatherScreen()));
  }

  //로그인을 실패했을 때 보여지는 다이얼로그 창
  void _onLoginFailure(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그인 실패'),
          content: const Text('아이디 또는 비밀번호가 올바르지 않습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  //formKey가 타당한지 확인하는 함수
  void validateForm() {
    if (formKey.currentState!.validate()) {
      _login();
    } else {
      Exception();
    }
  }

//loginToken에서 응답을 확인하는 함수
  void _login() async {
    final id = idController.text;
    final pw = pwController.text;

    try {
      final response = await loginToken.login(id, pw);
      // response가 일치하다고 응답을 주면 onLoginSucess() 함수 호출
      if (response.statusCode == 200) {
        _onLoginSuccess(context);
      } else {
        _onLoginFailure(context);
      }
    } catch (error) {
      print('로그인 요청 에러: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: const Icon(
                Icons.lock,
                size: 100,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: 'ID(이메일을 입력하세요) : ',
                      controller: idController,
                      onChanged: (value) {
                        setState(() {
                          //idErrorText = null;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ID를 다시 입력해주세요.';
                        } else if (!value.contains('@')) {
                          return '@를 포함해주세요.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: pwController,
                      hintText: '비밀번호',
                      errorText: pwErrorText,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          pwErrorText = null;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 다시 입력해주세요';
                        } else if (value.length <= 6) {
                          return '비밀번호는 7자리 이상입니다';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16.0)
                  ],
                )),
            ElevatedButton(
              onPressed: validateForm,
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
              ),
              child: const Text('로그인',
                  style: TextStyle(fontSize: 20, color: Colors.indigo)),
            ),
          ],
        ),
      ),
    );
  }
}
