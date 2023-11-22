import 'package:flutter/material.dart'; //이게원본

class WeatherScreen extends StatefulWidget {
  const WeatherScreen(
      {super.key, this.parseWeatherData}); //네임드 argument를 통해서 입력받을 데이터를 전달받는곳
  final parseWeatherData;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String? cityName;
  int? temp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateData(widget.parseWeatherData);
  }

  void updateData(dynamic weatherData) {
    double temp2 = weatherData['main']['temp'];
    temp = temp2.toInt();

    cityName = weatherData['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$cityName',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              '$temp',
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
      )),
    );
  }
}
