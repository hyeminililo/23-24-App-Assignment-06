import 'package:dio/dio.dart';

class LoginToken {
  final Dio _dio;
  final ip = '127.0.0.1:3000';

  //dio클래스의 인스턴스로 초기화
  LoginToken() : _dio = Dio();
  //async 사용해서 id와 pw가 맞는지 서버에게 보내서 일치 여부 확인
  Future<Response> login(String id, String pw) async {
    try {
      final response = await _dio.post(
        'http://$ip/auth/login',
        data: {
          'id': id,
          'pw': pw,
        },
      );
      print("성공했나?");
      return response;
    } //try-catch문을 통해 예외처리함
    catch (e) {
      throw Exception('로그인 요청을 실패했습니다. 에러: $e');
    }
  }
}
