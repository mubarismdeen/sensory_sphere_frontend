import 'package:admin/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants/style.dart';

class DeviceLocation extends StatelessWidget {
  final String latitude;
  final String longitude;

  DeviceLocation({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _openGoogleMaps(latitude, longitude, context),
      icon: const Icon(Icons.location_on, color: Colors.red),
      label: const Text('View Location'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: green.withOpacity(0.6), // Text color
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _openGoogleMaps(
      String latitude, String longitude, BuildContext context) async {
    final String googleMapsAndroidUrl = 'geo:$latitude,$longitude';
    final String googleMapsWebUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrlString(googleMapsAndroidUrl)) {
      await launchUrlString(googleMapsAndroidUrl);
    } else if (await canLaunchUrlString(googleMapsWebUrl)) {
      await launchUrlString(googleMapsWebUrl);
    } else {
      showSaveFailedMessage(context, "Cannot open maps for this property");
    }
  }
}
