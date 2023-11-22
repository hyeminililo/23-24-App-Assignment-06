import 'package:flutter/material.dart';
import 'package:weather_application/Login/loginToken.dart';
import 'package:weather_application/Weather/weatherScreen.dart';
import 'package:weather_application/Login/customTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  String? idErrorText = '';
  String? pwErrorText = '';

  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  LoginToken loginToken = LoginToken();

//GlobalKey<FormState>
  //로그인을 성공헀을 때 실행할 함수 onloginsuccess를 통해 weatherScreen으로 이동
  void _onLoginSuccess(BuildContext context) {
    print('성공');
    Navigator.of(context).pushReplacement(
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

  // formKey가 타당한지 확인하는 함수
  void validateForm() {
    if (_formKey.currentState!.validate()) {
      print("일단 여기는 실행됨 ");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("로그인 중입니다.")));
      _login();
    } else {
      print("vaildateForm 함수가 실패 ");
    }
  }

//loginToken에서 응답을 확인하는 함수
  void _login() async {
    final id = idController.text; //아이디와 패스워드 값 확인
    final pw = pwController.text;

    try {
      // 생성자를 통해 보내주기
      var response = await loginToken.logincheck(id, pw);
      print(
          '상태코드 : ${response.statusCode}'); // response가 일치하다고 응답을 주면 onLoginSucess() 함수 호출
      if (response.statusCode == 201 || response.statusCode == 200) {
        _onLoginSuccess(context);
      } else {
        _onLoginFailure(context);
      }
    } catch (e) {
      print('로그인 요청 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset 화면 그대로 두고 키보드만 올라오고 싶을 때 사용
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          //화면 자체를 스크롤할 수 있도록
          child: Padding(
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
                  key: _formKey,
                  child: Column(children: [
                    Column(
                      children: [
                        CustomTextField(
                          hintText: 'ID(이메일을 입력하세요) : ',
                          controller: idController,
                          onChanged: (value) {
                            setState(() {
                              idErrorText = null;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ID를 다시 입력해주세요.';
                            } else if (!value.contains('@')) {
                              return '@를 포함해주세요.';
                            }
                            return null;
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
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0)
                      ],
                    ),
                    ElevatedButton(
                      onPressed: validateForm,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 45, vertical: 20),
                      ),
                      child: const Text('로그인',
                          style: TextStyle(fontSize: 20, color: Colors.indigo)),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ));
  }
}
