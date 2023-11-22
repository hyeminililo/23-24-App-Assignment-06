
  import 'package:flutter/material.dart';
  import 'package:geolocator/geolocator.dart';
  import 'package:http/http.dart' as http;
  import 'dart:convert';

  class Weather extends StatefulWidget{
    @override
    _WeatherState createState() => _WeatherState();
  }
  class _WeatherState extends State<Weather>{
    String weatherState = '';  //현재 온도의 상태를 저장하는 변수 
    String locationState = ''; //현재 위도의 상태를 저장하는 변수 
    String tempData = ''; //현재 날씨 상태를 저장하는 변수
    String API_KEY = '5a271a50327b9a021ef3cc5f04d3ca02'; //날씨 API키 저장
    IconData weatherIcon = Icons.cloud;

    //위치 정보를 가져오는 비동기 함수
    Future<void> getPosition() async {
      print('Getting position...');
      //위치 권한 요청
      LocationPermission permission = await Geolocator.requestPermission();
      //위치 권한에 따라 처리
      if (permission == LocationPermission.denied){
        //위치 권한이 거부된 경우
        print('Location permission denied');
      }
      else if (permission == LocationPermission.deniedForever){
        //위치 권한이 영구적으로 거부된 경우
        print('Location permission denied forever');
      }
      else {
        //위치 권한이 허용된경우
        print('Location permission granted');
      }
      // 사용자의 현재 위치를 얻은 다음 해당 위치의 날씨 정보를 가져옴
      var currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low); //getCurrentPosition 현재 위치를 얻는 Geolocator 패키지

      getWeather(lat: currentPosition.latitude.toString(), lon: currentPosition.longitude.toString()); //latitude 위도, longitude 경도,
    }
    Future<void> getWeather({required String lat, required String lon}) async {
      print('Getting weather...');
      var response = await http.get(
        Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$API_KEY&units=metric'),
        ); //get 방식

        //HTTP 응답의 상태 코드가 200인지 확인 200은 성공적으로 응답한 상태
        if(response.statusCode == 200){
          var data =  jsonDecode(response.body);
          setState(() {
            locationState = '${data['name']}'; //변수 업데이트 하여 날씨 데이터에서 도시 이름을 포함한 위치정보를 저장
            weatherState = '${data['main']['temp']}°C '; //변수를 업데이트하여 온도 데이터에서 얻은 날씨데이터에서 온도정보를 저장
            tempData = '${data['weather'][0]['description']}';// 변수 업데이트 하여 온도 데이터에서 얻은 날씨 데이터를 저장
            weatherIcon = getWeatherIcon(data['weather'][0]['id']); // 아이콘 변수를 업데이트하여 날씨 데이터에서 얻은 날씨 ID를 사용하여 해당 하는 아이콘을 가져오는 함수를 호출하여 저장
          });
        }
        //200이 아닌 경우 예외 처리
        else{
          throw Exception('Faild to load weather data');
        }
    }
    IconData getWeatherIcon(int condition) {
    if (condition < 300) {
      return Icons.bolt; // 천둥
    } else if (condition < 400) {
      return Icons.umbrella; // 이슬비
    } else if (condition < 600) {
      return Icons.beach_access; // 비
    } else if (condition < 700) {
      return Icons.snowing; // 눈
    } else if (condition < 800) {
      return Icons.foggy; // 대기
    } else if (condition == 800) {
      return Icons.wb_sunny; // 해
    } else if (condition <= 804) {
      return Icons.cloud; // 구름
    } else {
      return Icons.error_outline; 
    }
  }
  @override
  void initState(){
    super.initState();
    getPosition();
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.cloud, size:20, color: Colors.white,),
              const SizedBox(height: 3),
              Text(locationState, style: TextStyle(fontSize: 40), ),
              const SizedBox(height: 30),
              Icon(weatherIcon, size: 70, color: Colors.yellow,),
              const SizedBox(height: 30),
              Text(weatherState, style: TextStyle(fontSize: 35),),
              const SizedBox(height: 10),
              Text(tempData, style: TextStyle(fontSize: 20),),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              getPosition();
            });
        }),
      );
    }
  }