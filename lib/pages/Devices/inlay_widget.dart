import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';

class InlayWidget extends StatelessWidget {
  final double currentAmperes;
  final double pressurePsi;
  final double temperatureCelsius;

  InlayWidget({
    required this.currentAmperes,
    required this.pressurePsi,
    required this.temperatureCelsius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildParameterRow(
            icon: Icons.flash_on,
            label: 'Current  ',
            value: '$currentAmperes A',
            iconColor: Colors.blue,
          ),
          SizedBox(height: 10),
          _buildParameterRow(
            icon: Icons.speed,
            label: 'Pressure  ',
            value: '$pressurePsi PSI',
            iconColor: Colors.yellow,
          ),
          SizedBox(height: 10),
          _buildParameterRow(
            icon: Icons.thermostat_outlined,
            label: 'Temperature  ',
            value: '$temperatureCelsius °C',
            iconColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildParameterRow({required IconData icon, required String label, required String value, required Color iconColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureRow(double temperature) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.thermostat_outlined,
          color: Colors.red,
        ),
        SizedBox(width: 8),
        Text(
          'Temperature  ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          '$temperature °C',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
