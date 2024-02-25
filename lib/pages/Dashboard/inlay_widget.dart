import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';

class InlayWidget extends StatelessWidget {
  final double suctionPressure;
  final double dischargePressure;
  final double oxygenAPressure;
  final double oxygenBPressure;
  final double ambientTemperature;
  final double totalCurrent;

  InlayWidget({
    required this.suctionPressure,
    required this.dischargePressure,
    required this.oxygenAPressure,
    required this.oxygenBPressure,
    required this.ambientTemperature,
    required this.totalCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildParameterRow(
            icon: Icons.arrow_downward,
            label: 'Suction Pressure',
            value: '$suctionPressure PSI',
            iconColor: Colors.blue,
          ),
          _buildParameterRow(
            icon: Icons.arrow_upward,
            label: 'Discharge Pressure',
            value: '$dischargePressure PSI',
            iconColor: Colors.yellow,
          ),
          _buildParameterRow(
            icon: Icons.battery_full,
            label: 'Oxygen A Pressure',
            value: '$oxygenAPressure PSI',
            iconColor: Colors.green,
          ),
          _buildParameterRow(
            icon: Icons.battery_full,
            label: 'Oxygen B Pressure',
            value: '$oxygenBPressure PSI',
            iconColor: Colors.green,
          ),
          _buildParameterRow(
            icon: Icons.thermostat_outlined,
            label: 'Ambient Temperature',
            value: '$ambientTemperature °C',
            iconColor: Colors.red,
          ),
          _buildParameterRow(
            icon: Icons.flash_on,
            label: 'Total Current',
            value: '$totalCurrent A',
            iconColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildParameterRow({required IconData icon, required String label, required String value, required Color iconColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
              ),
              const SizedBox(width: 8),
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
      ),
    );
  }
}
