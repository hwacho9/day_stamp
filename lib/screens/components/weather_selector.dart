// File: weather_selector.dart
import 'package:flutter/material.dart';

class WeatherSelector extends StatefulWidget {
  final void Function(String) onWeatherSelected;

  const WeatherSelector({super.key, required this.onWeatherSelected});

  @override
  State<WeatherSelector> createState() => _WeatherSelectorState();
}

class _WeatherSelectorState extends State<WeatherSelector> {
  String _selectedWeather = '';

  String getWeatherWord(String emoji) {
    Map<String, String> emojiToWord = {
      '☀️': 'sunny',
      '🌧': 'rainy',
      '⛅️': 'cloudy',
      '❄️': 'snowy',
    };
    return emojiToWord[emoji] ?? 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100.0,
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
            children: <String>['☀️', '🌧', '⛅️', '❄️'].map((String weather) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedWeather = getWeatherWord(weather);
                  });
                  widget.onWeatherSelected(getWeatherWord(weather));
                },
                child: CircleAvatar(
                  child: Text(weather),
                  backgroundColor: _selectedWeather == getWeatherWord(weather)
                      ? Colors.blue
                      : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
