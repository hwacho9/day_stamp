// File: weather_selector.dart
import 'package:flutter/material.dart';

class WeatherSelector extends StatefulWidget {
  final void Function(String, String) onWeatherSelected;

  const WeatherSelector({super.key, required this.onWeatherSelected});

  @override
  State<WeatherSelector> createState() => _WeatherSelectorState();
}

class _WeatherSelectorState extends State<WeatherSelector> {
  String _selectedWeather = '';
  String _selectedWeatherString = '';

  String getWeatherWord(String weather) {
    Map<String, String> weatherToWord = {
      'assets/images/weather/sunny.png': 'sunny',
      'assets/images/weather/rain.png': 'rainy',
      'assets/images/weather/cloud.png': 'cloudy',
      'assets/images/weather/snow.png': 'snowy',
    };
    return weatherToWord[weather] ?? 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.0,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          const Text('今日の天気',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <String>[
              'assets/images/weather/sunny.png',
              'assets/images/weather/rain.png',
              'assets/images/weather/cloud.png',
              'assets/images/weather/snow.png',
            ].map((String weather) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedWeather = weather;
                    _selectedWeatherString = getWeatherWord(weather);
                  });
                  widget.onWeatherSelected(
                      _selectedWeather, _selectedWeatherString);
                  print(_selectedWeather);
                  print(getWeatherWord(_selectedWeather));
                },
                child: Image.asset(
                  weather,
                  width: 65,
                  height: 65,
                  color: _selectedWeather == weather ? null : Colors.grey,
                  // 이 부분에서 선택된 이미지는 원래 색상을 유지하고, 그렇지 않은 이미지는 회색으로 설정합니다.
                  colorBlendMode: BlendMode.modulate,
                  // color 속성을 사용할 때 colorBlendMode를 modulate로 설정하여 색상이 올바르게 적용되도록 합니다.
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
