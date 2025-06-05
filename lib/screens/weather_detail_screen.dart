import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as lol;

class WeatherDetailScreen extends StatelessWidget {
  final DateTime date;
  final double temp;
  final String weather;
  final IconData icon;
  final double floodRisk;
  final Map<String, dynamic> weatherData; // Added to pass full weather data

  const WeatherDetailScreen({
    super.key,
    required this.date,
    required this.temp,
    required this.weather,
    required this.icon,
    required this.floodRisk,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = context.locale.languageCode == 'ar';
    final floodColor = _getFloodColor(floodRisk, isDark);

    // Extract additional weather details
    final humidity = weatherData['main']?['humidity']?.toString() ?? 'N/A';
    final windSpeed = weatherData['wind']?['speed']?.toStringAsFixed(1) ?? 'N/A';
    final pressure = weatherData['main']?['pressure']?.toString() ?? 'N/A';
    final visibility = weatherData['visibility'] != null
        ? (weatherData['visibility'] / 1000).toStringAsFixed(1)
        : 'N/A';
    final feelsLike = weatherData['main']?['feels_like']?.toStringAsFixed(1) ?? 'N/A';
    final sunrise = weatherData['sys']?['sunrise'] != null
        ? DateFormat('h:mm a', context.locale.languageCode).format(
            DateTime.fromMillisecondsSinceEpoch(weatherData['sys']['sunrise'] * 1000))
        : 'N/A';
    final sunset = weatherData['sys']?['sunset'] != null
        ? DateFormat('h:mm a', context.locale.languageCode).format(
            DateTime.fromMillisecondsSinceEpoch(weatherData['sys']['sunset'] * 1000))
        : 'N/A';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          DateFormat('EEEE, MMM d', context.locale.languageCode).format(date),
          style: TextStyle(
            color: isDark
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onPrimaryContainer,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.black, theme.colorScheme.primaryContainer]
                    : [
                        theme.colorScheme.surface,
                        theme.colorScheme.primaryContainer
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  Icon(
                    icon,
                    size: 120,
                    color: _getWeatherIconColor(weather, isDark),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '${temp.toStringAsFixed(1)}°C',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Directionality(
                    textDirection: isArabic
                        ? lol.TextDirection.rtl
                        : lol.TextDirection.ltr,
                    child: Text(
                      context.tr(_mapWeatherCondition(weather)),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildDetailCard(
                    context,
                    title: 'flood_risk'.tr(),
                    value: '${(floodRisk * 100).toStringAsFixed(1)}%',
                    icon: Icons.water_drop,
                    color: floodColor,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    context,
                    title: 'feels_like'.tr(),
                    value: '$feelsLike°C',
                    icon: Icons.thermostat,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    context,
                    title: 'humidity'.tr(),
                    value: '$humidity%',
                    icon: Icons.opacity,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    context,
                    title: 'wind_speed'.tr(),
                    value: '$windSpeed m/s',
                    icon: Icons.air,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    context,
                    title: 'pressure'.tr(),
                    value: '$pressure hPa',
                    icon: Icons.compress,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    context,
                    title: 'visibility'.tr(),
                    value: '$visibility km',
                    icon: Icons.visibility,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    context,
                    title: 'sunrise'.tr(),
                    value: sunrise,
                    icon: Icons.wb_sunny,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    context,
                    title: 'sunset'.tr(),
                    value: sunset,
                    icon: Icons.nights_stay,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    context,
                    title: 'date'.tr(),
                    value: DateFormat('MMMM d, y', context.locale.languageCode)
                        .format(date),
                    icon: Icons.calendar_today,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDark
          ? theme.colorScheme.surface.withOpacity(0.6)
          : theme.colorScheme.surface.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getFloodColor(double risk, bool isDark) {
    if (risk < 0.3) {
      return isDark ? Colors.green.shade300 : Colors.green.shade700;
    } else if (risk < 0.6) {
      return isDark ? Colors.orange.shade300 : Colors.orange.shade700;
    } else {
      return isDark ? Colors.red.shade300 : Colors.red.shade700;
    }
  }

  String _mapWeatherCondition(String apiCondition) {
    switch (apiCondition.toLowerCase()) {
      case 'clear sky':
        return 'clear';
      case 'few clouds':
      case 'scattered clouds':
      case 'broken clouds':
      case 'overcast clouds':
        return 'clouds';
      case 'shower rain':
      case 'light rain':
      case 'moderate rain':
        return 'rain';
      case 'snow':
      case 'light snow':
      case 'heavy snow':
        return 'snow';
      case 'thunderstorm':
      case 'thunderstorm with rain':
        return 'thunderstorm';
      case 'mist':
      case 'fog':
      case 'haze':
        return 'mist';
      default:
        return apiCondition.toLowerCase();
    }
  }

  Color _getWeatherIconColor(String condition, bool isDark) {
    switch (_mapWeatherCondition(condition)) {
      case 'clouds':
        return isDark ? Colors.grey.shade400 : Colors.grey.shade600;
      case 'rain':
        return isDark ? Colors.blue.shade300 : Colors.blue.shade700;
      case 'snow':
        return isDark ? Colors.cyan.shade200 : Colors.cyan.shade600;
      case 'thunderstorm':
        return isDark ? Colors.purple.shade300 : Colors.purple.shade700;
      case 'clear':
        return isDark ? Colors.yellow.shade300 : Colors.orange.shade700;
      default:
        return isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    }
  }
}