// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class WeatherScreen extends StatefulWidget {
//   @override
//   _WeatherScreenState createState() => _WeatherScreenState();
// }

// class _WeatherScreenState extends State<WeatherScreen> {
//   final String apiKey = '423e3538b9221108f42027e6edf96df4';
//   double? latitude;
//   double? longitude;
//   String? weatherCondition;
//   double? temperature;
//   bool _isRequestingLocation = false; // 위치 권한 요청 중 플래그

//   @override
//   void initState() {
//     super.initState();
//     getLocationAndWeather();
//   }

//   // 비동기 함수 반환 타입을 수정
//   Future<void> getLocationAndWeather() async {
//     await getLocation();
//     await getWeather();
//   }

//   // 위치 정보를 가져오는 메서드
//   Future<void> getLocation() async {
//     try {
//       if (_isRequestingLocation) {
//         return; // 이미 권한 요청 중이면 중복 요청 방지
//       }

//       _isRequestingLocation = true; // 권한 요청 중 플래그 설정
//       LocationPermission permission = await Geolocator.requestPermission();

//       if (permission == LocationPermission.denied) {
//         // 권한이 거부된 경우 처리
//         _showLocationPermissionDeniedDialog();
//       } else {
//         // 권한이 부여되면 위치 가져오기
//         await fetchLocation();
//       }
//     } catch (e) {
//       print('위치 정보를 가져오는 중 오류 발생: $e');
//     } finally {
//       _isRequestingLocation = false; // 권한 요청 완료 후 플래그 해제
//     }
//   }

//   // 위치 정보를 가져오는 메서드의 반환 타입을 수정
//   Future<Position> fetchLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.low,
//       );

//       setState(() {
//         latitude = position.latitude;
//         longitude = position.longitude;
//       });
//       return position;
//     } catch (e) {
//       print('위치 정보를 가져오는 중 오류 발생: $e');
//       _showLocationFetchErrorDialog();
//       rethrow; // 예외를 다시 던져서 상위 호출자에게 전달
//     }
//   }

//   // 날씨 정보를 가져오는 메서드
//   Future<void> getWeather() async {
//     if (latitude == null || longitude == null) {
//       // 위치 정보가 없을 경우 처리
//       return;
//     }

//     final String apiUrl =
//         'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

//     try {
//       http.Response response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         Map<String, dynamic> weatherData = json.decode(response.body);
//         setState(() {
//           temperature = weatherData['main']['temp'];
//           weatherCondition = weatherData['weather'][0]['main'];
//         });
//       } else {
//         print('날씨 데이터 로드 실패. 상태 코드: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('날씨 정보를 가져오는 중 오류 발생: $e');
//     }
//   }

//   // 위치 권한이 거부된 경우 사용자에게 알리는 다이얼로그
//   void _showLocationPermissionDeniedDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('위치 권한 거부'),
//           content: Text('위치 정보를 가져오기 위해서는 위치 권한이 필요합니다.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('확인'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // 위치 정보 가져오기 실패에 대한 다이얼로그
//   void _showLocationFetchErrorDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('위치 정보 가져오기 실패'),
//           content: Text('위치 정보를 가져오지 못했습니다.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('확인'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('날씨 앱'),
//       ),
//       body: FutureBuilder<void>(
//         future: getLocationAndWeather(), // 함수 호출
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('오류: ${snapshot.error}'));
//           } else {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Icon(
//                     _getWeatherIcon(),
//                     size: 100,
//                     color: Colors.blue,
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     '온도: ${temperature != null ? '$temperature°C' : '위치 정보를 동의해주세요!'}',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     '날씨: ${weatherCondition ?? '위치 정보를 동의해주세요!'}',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   // 날씨에 따라 아이콘 반환
//   IconData _getWeatherIcon() {
//     switch (weatherCondition) {
//       case 'Clear':
//         return Icons.wb_sunny;
//       case 'Clouds':
//         return Icons.cloud;
//       case 'Rain':
//         return Icons.beach_access;
//       default:
//         return Icons.wb_cloudy;
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String apiKey = '423e3538b9221108f42027e6edf96df4';
  double? latitude;
  double? longitude;
  String? weatherCondition;
  double? temperature;
  bool _isRequestingLocation = false; // 위치 권한 요청 중 플래그

  @override
  void initState() {
    super.initState();
    getLocationAndWeather();
    getWeather(); // 날씨 데이터 로드를 initState에서 호출
  }

  // 비동기 함수 반환 타입을 수정
  Future<void> getLocationAndWeather() async {
    await getLocation();
  }

  // 위치 정보를 가져오는 메서드
  Future<void> getLocation() async {
    try {
      if (_isRequestingLocation) {
        return; // 이미 권한 요청 중이면 중복 요청 방지
      }

      _isRequestingLocation = true; // 권한 요청 중 플래그 설정
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // 권한이 거부된 경우 처리
        _showLocationPermissionDeniedDialog();
      } else {
        // 권한이 부여되면 위치 가져오기
        await fetchLocation();
      }
    } catch (e) {
      print('위치 정보를 가져오는 중 오류 발생: $e');
    } finally {
      _isRequestingLocation = false; // 권한 요청 완료 후 플래그 해제
    }
  }

  // 위치 정보를 가져오는 메서드의 반환 타입을 수정
  Future<Position> fetchLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      return position;
    } catch (e) {
      print('위치 정보를 가져오는 중 오류 발생: $e');
      _showLocationFetchErrorDialog();
      rethrow; // 예외를 다시 던져서 상위 호출자에게 전달
    }
  }

  // 날씨 정보를 가져오는 메서드
  Future<void> getWeather() async {
    if (latitude == null || longitude == null) {
      // 위치 정보가 없을 경우 처리
      return;
    }

    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

    try {
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> weatherData = json.decode(response.body);
        setState(() {
          temperature = weatherData['main']['temp'];
          weatherCondition = weatherData['weather'][0]['main'];
        });
      } else {
        print('날씨 데이터 로드 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('날씨 정보를 가져오는 중 오류 발생: $e');
    }
  }

  // 위치 권한이 거부된 경우 사용자에게 알리는 다이얼로그
  void _showLocationPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('위치 권한 거부'),
          content: Text('위치 정보를 가져오기 위해서는 위치 권한이 필요합니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // 위치 정보 가져오기 실패에 대한 다이얼로그
  void _showLocationFetchErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('위치 정보 가져오기 실패'),
          content: Text('위치 정보를 가져오지 못했습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('날씨 앱'),
      ),
      body: FutureBuilder<void>(
        future: getLocationAndWeather(), // 함수 호출
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류: ${snapshot.error}'));
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    _getWeatherIcon(),
                    size: 100,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '온도: ${temperature != null ? '$temperature°C' : '위치 정보를 동의해주세요!'}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '날씨: ${weatherCondition ?? '위치 정보를 동의해주세요!'}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // 날씨에 따라 아이콘 반환
  IconData _getWeatherIcon() {
    switch (weatherCondition) {
      case 'Clear':
        return Icons.wb_sunny;
      case 'Clouds':
        return Icons.cloud;
      case 'Rain':
        return Icons.beach_access;
      default:
        return Icons.wb_cloudy;
    }
  }
}
