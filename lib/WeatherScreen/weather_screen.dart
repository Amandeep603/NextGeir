import 'dart:convert';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/ui/posts/posts.screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/utils.dart';
import 'dart:math';
import 'additional_item.dart';
import 'weather_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/ui/auth/login_screen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final ref = FirebaseDatabase.instance.ref().child('Data').child('Soil Data');
  final real = FirebaseDatabase.instance.ref().child('Data').child('Realtime Soil Data');
  final auth = FirebaseAuth.instance;

  String temperature = 'N/A';
  String moisture = 'N/A';
  String humidity = 'N/A';

  String temp1 = 'N/A';
  String moisture1 = 'N/A';
  String humidity1= 'N/A';

  Future<Map<String, dynamic>> getWeatherUpdate() async {
    try {
      String cityName = 'Jhanjeri';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,in&APPID=cd5f72ad2a5fd941519430c77875fbeb',
        ),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }
      return data;
      // temp = data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();

    ref.child('temperature').onValue.listen((event) {
      setState(() {
        temperature = event.snapshot.value?.toString() ?? 'N/A';
      });
    });

    ref.child('moisture').onValue.listen((event) {
      setState(() {
        moisture = event.snapshot.value?.toString() ?? 'N/A';
      });
    });

    ref.child('humidity').onValue.listen((event) {
      setState(() {
        humidity = event.snapshot.value?.toString() ?? 'N/A';
      });
    });

    real.child('temperature').onValue.listen((event) {
      setState(() {
        temp1 = event.snapshot.value?.toString() ?? 'N/A';
      });
    });

    real.child('moisture').onValue.listen((event) {
      setState(() {
        moisture1 = event.snapshot.value?.toString() ?? 'N/A';
      });
    });

    real.child('humidity').onValue.listen((event) {
      setState(() {
        humidity1 = event.snapshot.value?.toString() ?? 'N/A';
      });
    });


    getWeatherUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        title: const Text(
          'NextGeir',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  getWeatherUpdate();
                });
              },
              icon: const Icon(Icons.refresh))

        ],
        leading: IconButton(
          onPressed: () {

             auth.signOut().then((value) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
            });
          },
          icon: const Icon(Icons.logout),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.grey.shade500],
          ),
        ),
        child: FutureBuilder(
          future: getWeatherUpdate(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return Text(
                snapshot.hasError.toString(),
              );
            }
            final data = snapshot.data!;
            final currentWeatherData = data['list'][0];

            final currentTemp = currentWeatherData['main']['temp'];
            final currentSky = currentWeatherData['weather'][0]['main'];
            final currentPressure = currentWeatherData['main']['pressure'];
            final currentWindSpeed = currentWeatherData['wind']['speed'];
            final currentHumidity = currentWeatherData['main']['humidity'];
            final currentIconCode = currentWeatherData['weather'][0]['icon'];
            int tempCelsius =  (currentTemp - 273.15).round();
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                      color: Colors.deepPurple.shade200,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text(

                                    '$tempCelsius °C' ,
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  WeatherIcon(
                                    iconCode: currentIconCode,
                                    iconSize: 64,

                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    currentSky,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Realtime Soil Data',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalItem(
                          icon: Icons.thermostat_rounded,
                          label: 'Temperature',
                          value: temp1,
                        ),
                        AdditionalItem(
                          icon: Icons.water_drop_rounded,
                          label: 'Moisture',
                          value: moisture1,
                        ),
                        AdditionalItem(
                          icon: Icons.cloud_rounded,
                          label: 'Humidity',
                          value: humidity1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    //additional info
                    const Text(
                      'Additional Info',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalItem(
                          icon: Icons.water_drop_outlined,
                          label: 'Humidity',
                          value: currentHumidity.toString(),
                        ),
                        AdditionalItem(
                          icon: Icons.air_outlined,
                          label: 'Wind Speed',
                          value: currentWindSpeed.toString(),
                        ),
                        AdditionalItem(
                          icon: Icons.beach_access_outlined,
                          label: 'Pressure',
                          value: currentPressure.toString(),
                        ),
                      ],
                    ),
                    const SizedBox(height:12),
                    const Text(
                      'User Soil Data',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalItem(
                          icon: Icons.thermostat_outlined,
                          label: 'Temperature',
                          value: temperature,
                        ),
                        AdditionalItem(
                          icon: Icons.water_drop_outlined,
                          label: 'Moisture',
                          value: moisture,
                        ),
                        AdditionalItem(
                          icon: Icons.cloud_outlined,
                          label: 'Humidity',
                          value: humidity,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                  ],
                ),
              ),
            );
          },
        ),
      ),

    );
  }
}