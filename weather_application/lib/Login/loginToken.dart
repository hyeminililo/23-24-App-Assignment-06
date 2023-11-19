import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

class LoginToken {
  final Dio _dio;

  final emulatorIp = '10.0.2.2:3000';
  final simulatorIp = '127.0.0.1:3000';
  String? accessToken;
  String? refreshToken;

  // Dio 클래스의 인스턴스로 초기화
  LoginToken() : _dio = Dio();

  // async를 사용하여 id와 pw가 맞는지 서버에게 보내서 일치 여부 확인
  Future<Response<dynamic>> login(String id, String pw) async {
    try {
      final ip = Platform.isIOS ? simulatorIp : emulatorIp;

      final token = base64Encode(utf8.encode('$id:$pw'));

      final response = await _dio.post(
        'http://$ip/auth/login',
        options: Options(
          headers: {
            'Authorization': 'Basic $token',
          },
        ),
      );

      final data = response.data;
      accessToken = data['accessToken'];
      refreshToken = data['refreshToken'];

      return response;
    } catch (e) {
      throw Exception('로그인 요청을 실패했습니다. 에러: $e');
    }
  }

  Future<Response<dynamic>> authRequest(String token) async {
    final ip = Platform.isIOS ? simulatorIp : emulatorIp;

    final options = Options(headers: {'Authorization': 'Bearer $accessToken'});

    try {
      final response = await _dio.get(
        'http://$ip/$token',
        options: options,
      );

      return response;
    } catch (e) {
      // 사라진 패키지 여서 final isStatus401 = err.response?.statusCode == 401; 으로 적어도 오류남 ,,
      if (e is DioError && e.response?.statusCode == 401) {
        await refreshAccessToken();
        options.headers = {'Authorization': 'Bearer $accessToken'};

        // 액세스 토큰을 갱신한 후 다시 요청을 보냄
        final refreshedResponse = await _dio.get(
          'http://$ip/$token',
          options: options,
        );

        return refreshedResponse;
      }

      throw Exception('인증된 요청을 실패했습니다. 에러: $e');
    }
  }

  Future<void> refreshAccessToken() async {
    final ip = Platform.isIOS ? simulatorIp : emulatorIp;

    final response = await _dio.post(
      'http://$ip/auth/refresh',
      data: {'refreshToken': refreshToken},
    );

    final data = response.data;
    accessToken = data['accessToken'];
  }
}
