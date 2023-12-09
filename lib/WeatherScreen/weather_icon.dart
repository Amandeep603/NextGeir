import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherIcon extends StatelessWidget {
  final String iconCode;
  final double iconSize;

  const WeatherIcon({
    super.key,
    required this.iconCode,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    IconData? weatherIcon = _getWeatherIcon(iconCode);
    if (weatherIcon != null) {
      return Icon(
        weatherIcon,
        size: iconSize, // Adjust the size as needed
        color: Colors.white, // Adjust the color as needed
      );
    } else {
      // Handle the case where the icon code is not recognized
      return const Text('Unknown Icon');
    }
  }

  IconData? _getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return WeatherIcons.day_sunny;
      case '01n':
        return WeatherIcons.night_clear;
      case '02d':
        return WeatherIcons.day_cloudy;
      case '02n':
        return WeatherIcons.night_alt_cloudy;
      case '03d':
        return WeatherIcons
            .day_cloudy_gusts; // Adjust with the appropriate icon
      case '03n':
        return WeatherIcons
            .night_alt_cloudy_gusts; // Adjust with the appropriate icon
      case '04d':
        return WeatherIcons.day_cloudy_high; // Adjust with the appropriate icon
      case '04n':
        return WeatherIcons
            .night_alt_cloudy_high; // Adjust with the appropriate icon
      case '09d':
        return WeatherIcons.day_showers; // Adjust with the appropriate icon
      case '09n':
        return WeatherIcons
            .night_alt_showers; // Adjust with the appropriate icon
      case '11d':
        return WeatherIcons
            .day_thunderstorm; // Adjust with the appropriate icon
      case '11n':
        return WeatherIcons.night_alt_thunderstorm;
      case '10d':
        return WeatherIcons.day_rain;
      case '10n':
        return WeatherIcons.night_rain;
    // Add more cases for other weather conditions as needed
      default:
        return null;
    }
  }
}