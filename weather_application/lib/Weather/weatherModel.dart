class WeatherModel {
  final String cityName;
  final double temp;
  final String condition;
  final String weather;

  WeatherModel({
    required this.cityName,
    required this.temp,
    required this.condition,
    required this.weather,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temp: json['main']['temp'],
      condition: json['weather'][0]['main'],
      weather: json['weather'][0]['description'],
    );
  }
}
