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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100.0,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          const Text('오늘의 날씨',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <String>['☀️', '🌧', '⛅️', '❄️'].map((String weather) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedWeather = weather;
                  });
                  widget.onWeatherSelected(weather);
                },
                child: CircleAvatar(
                  child: Text(weather),
                  backgroundColor:
                      _selectedWeather == weather ? Colors.blue : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
