import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

import 'dart:convert';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final openWeatherApiKey = "a02e8f8c7c64021ad94d354154f728af";

  bool isLoading = true;
  String cityName = "";
  double temperature = 0;
  String description = "";
  int humidity = 0;

  Future<void> loadWeather() async {
    var data = await getWeatherData();
    setState(() {
      cityName = data['name'];
      temperature = data['main']['temp'];
      description = data['weather'][0]['description'];
      humidity = data['main']['humidity'];
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<Map<String, double>> geolocation() async {
    LocationPermission _ = await Geolocator.requestPermission();

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    return {'latitude': position.latitude, 'longitude': position.longitude};
  }

  Future<String> getData(String lat, String lon) async {
    Response res = await get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$openWeatherApiKey&units=imperial',
      ),
    );

    return res.body;
  }

  Future<dynamic> getWeatherData() async {
    Map<String, double> coordinates = await geolocation();
    String data = await getData(
      coordinates['latitude'].toString(),
      coordinates['longitude'].toString(),
    );
    return jsonDecode(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Current Weather'))),
      body: isLoading
          ? SpinKitChasingDots(color: Colors.blue, size: 50.0)
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wb_cloudy, size: 80, color: Colors.lightBlue),
                  SizedBox(height: 20),
                  Text(cityName, style: TextStyle(fontSize: 24)),
                  SizedBox(height: 20),
                  Text(
                    '${temperature.toStringAsFixed(0)}°F',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    description.toUpperCase(),
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text('Humidity: $humidity%'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('back button pressed');
                      Navigator.pop(context);
                    },
                    child: Text('Back to Home'),
                  ),
                ],
              ),
            ),
    );
  }
}
