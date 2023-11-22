import 'package:flutter/material.dart';
import 'package:weather_application/Weather/weatherLocation.dart';
import 'package:weather_application/Weather/weatherModel.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherLocation weatherLocation = WeatherLocation();

  @override
  void initState() {
    super.initState();
    weatherLocation.getMyCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<void>(
              future: weatherLocation.fetchData(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  print('$snapshot.statusCode');
                  return const Text('데이터를 가져오는 중 오류가 발생했습니다.');
                } else {
                  WeatherModel weather = weatherLocation.weather!;
                  return Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        '도시: ${weather.cityName}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '날씨: ${weather.condition}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '온도: ${weather.temp}°C',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
