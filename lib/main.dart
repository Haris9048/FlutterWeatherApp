import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyText2:
              TextStyle(color: Colors.white), // Change text color to white
        ),
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String apiKey =
      '8edb5071f68e4aa739d9fbbd2c0c9a02'; // Replace with your OpenWeatherMap API key
  late String city;
  late String _temperature = '';
  late String _description = '';
  late String _weatherIcon = '';

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    city = ''; // Initially, the city is empty
  }

  Future<void> _fetchWeather(String cityName) async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _temperature = data['main']['temp'].toString();
        _description = data['weather'][0]['description'];
        _weatherIcon = data['weather'][0]['icon'];
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  BoxDecoration _buildBackground() {
    String backgroundUrl;
    double opacity = 0.6; // Adjust the opacity of the background image

    if (_weatherIcon.contains('01')) {
      // Clear sky
      backgroundUrl =
          'https://i0.wp.com/www.3wallpapers.fr/wp-content/uploads/2014/09/Solefield-iPhone-6-sunsetclouds2plus.jpg?ssl=1';
    } else if (_weatherIcon.contains('02') || _weatherIcon.contains('03')) {
      // Few clouds or scattered clouds
      backgroundUrl =
          'https://e0.pxfuel.com/wallpapers/863/917/desktop-wallpaper-cloudy-sky-iphone-x-backgrounds-iphone-blue-clouds-iphone.jpg';
    } else if (_weatherIcon.contains('04') ||
        _weatherIcon.contains('09') ||
        _weatherIcon.contains('10')) {
      // Cloudy or light rain or moderate rain
      backgroundUrl =
          'https://i.pinimg.com/564x/46/a3/7c/46a37c6400fa48bd51139e77822a85cd.jpg';
    } else {
      // Default background for other weather conditions
      backgroundUrl =
          'https://img.freepik.com/free-vector/blur-pink-blue-abstract-gradient-background-vector_53876-174836.jpg';
    }

    return BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(backgroundUrl),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black
              .withOpacity(opacity), // Apply opacity to the background image
          BlendMode.dstATop,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: _buildBackground(),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Enter City Name',
                          labelStyle: TextStyle(
                              color:
                                  Colors.white), // Change label color to white
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .white), // Change border color to white
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            city = value;
                          });
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _fetchWeather(
                            city); // Call _fetchWeather when button is pressed
                      },
                      child: Text('Get Weather'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Temperature: $_temperature°C',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Description: $_description',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
