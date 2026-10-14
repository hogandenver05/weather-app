import 'package:flutter/material.dart';

import 'weather_page.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void checkWeather(dynamic context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WeatherPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Weather App'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wb_sunny_rounded, size: 120, color: Colors.yellow),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => checkWeather(context),
              child: Text("Check Weather", style: TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}
