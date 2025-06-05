import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FloodStatusTab extends StatelessWidget {
  const FloodStatusTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: isDark ? Colors.black54 : Colors.white.withOpacity(0.9),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'flood_status'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('today_flood_status')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text(
                          'Error loading flood data: ${snapshot.error}',
                          style: TextStyle(
                            color: isDark ? Colors.redAccent : Colors.red,
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text(
                          'no_flood_data'.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: docs.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          final date = data['date']?.toString() ?? 'N/A';
                          final floodVotes = data['floodVotes']?.toString() ?? 'N/A';
                          final totalVotes = data['totalVotes']?.toString() ?? 'N/A';
                          final predictionData =
                              data['predictionData'] as Map<String, dynamic>? ?? {};
                          final weatherData =
                              data['weatherData'] as Map<String, dynamic>? ?? {};
                          final createdAt =
                              (data['createdAt'] as Timestamp?)?.toDate().toString() ??
                                  'N/A';
                          final lastUpdated =
                              (data['lastUpdated'] as Timestamp?)?.toDate().toString() ??
                                  'N/A';
                          final location =
                              data['location'] as Map<String, dynamic>? ?? {};
                          final city = location['city']?.toString() ?? 'Alexandria';
                          final country = location['country']?.toString() ?? 'Egypt';

                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: isDark
                                ? Colors.black26
                                : Colors.white.withOpacity(0.8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date: $date',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Created At: $createdAt',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Last Updated: $lastUpdated',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Flood Votes: $floodVotes / $totalVotes',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Location',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'City: $city',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Country: $country',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Prediction Data',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'Altitude: ${predictionData['ALT']?.toString() ?? 'N/A'} m',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Bright Sunshine: ${predictionData['Bright_Sunshine']?.toString() ?? 'N/A'} hours',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Cloud Coverage: ${predictionData['Cloud_Coverage']?.toString() ?? 'N/A'}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Max Temp: ${predictionData['Max_Temp']?.toString() ?? 'N/A'}°C',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Min Temp: ${predictionData['Min_Temp']?.toString() ?? 'N/A'}°C',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Rainfall: ${predictionData['Rainfall']?.toString() ?? 'N/A'} mm',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Relative Humidity: ${predictionData['Relative_Humidity']?.toString() ?? 'N/A'}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Wind Speed: ${predictionData['Wind_Speed']?.toString() ?? 'N/A'} m/s',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Weather Data',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'Current Temp: ${weatherData['current_temp']?.toString() ?? 'N/A'}°C',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Pressure: ${weatherData['pressure']?.toString() ?? 'N/A'} hPa',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Visibility: ${(weatherData['visibility'] != null ? weatherData['visibility'] / 1000 : 'N/A')} km',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Weather Condition: ${weatherData['weather_condition']?.toString() ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Weather Description: ${weatherData['weather_description']?.toString() ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Wind Direction: ${weatherData['wind_direction']?.toString() ?? 'N/A'}°',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}