import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
// jsonDecode를 사용하기 위해 import 추가
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'weatherModel.dart';

class WeatherLocation {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  double lat = 0.0;
  double long = 0.0;
  String url = '';
  // API키 발급
  final String API_KEY = '8f56a6e1df81c819811b13ada11ef9d3';
  String location = '';
  Function? onUpdate;
  WeatherModel? weather;
// 새로 만듦
  Future<String> getMyCurrentLocation1() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placemarks[0].locality;
    print(city);
    return city ?? "";
  }

  // 현재 위치를 얻어옴
  void getMyCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      // Geolocator를 통해 받은 위도,경도값 저장
      lat = position.latitude;
      long = position.longitude;
      // 변수 url에 날씨를 받아올 url 저장 //https로 지정
      url =
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$API_KEY&units=metric';

      _getCity(position.latitude, position.longitude);
    } catch (e) {
      return;
    }
  }

  // 현재 도시에 대한 정보를 얻어옴
  void _getCity(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    Placemark place = placemarks[0];
    String address =
        '${place.administrativeArea} ${place.locality} ${place.subLocality}';
    location = address;
  }

  Future<void> fetchData() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 || response.statusCode == 201) {
      String jsonData = response.body;
      dynamic myjson = jsonDecode(jsonData);
      weather = WeatherModel.fromJson(myjson);
    } else {
      return;
    }
  }

  //접근 권한을 설정하는 것
  Future<bool> departminePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }*/
}
