import 'package:flutter/material.dart';
import 'dashboard_card.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  initPageData() async {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: initPageData(),
      builder: (context, AsyncSnapshot<dynamic> _data) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                direction: Axis.horizontal, // Ensure horizontal wrapping
                spacing: 20, // Add spacing between cards
                runSpacing: 20, // Add spacing between rows of cards
                children: [
                  DashboardCard(
                    label: "Al Qudra Lake",
                    onLocationButtonPressed: () {},
                    suctionPressure: 10,
                    dischargePressure: 15,
                    oxygenAPressure: 12,
                    oxygenBPressure: 13,
                    ambientTemperature: 25,
                    totalCurrent: 10,
                    isRunning: true,
                  ),
                  DashboardCard(
                    label: "Union Property 1",
                    onLocationButtonPressed: () {},
                    suctionPressure: 12,
                    dischargePressure: 18,
                    oxygenAPressure: 10,
                    oxygenBPressure: 11,
                    ambientTemperature: 35,
                    totalCurrent: 13,
                    isRunning: false,
                  ),
                  DashboardCard(
                    label: "Union Property 2",
                    onLocationButtonPressed: () {},
                    suctionPressure: 0,
                    dischargePressure: 5,
                    oxygenAPressure: 15,
                    oxygenBPressure: 13,
                    ambientTemperature: 45,
                    totalCurrent: 2,
                    isRunning: false,
                  ),
                  DashboardCard(
                    label: "Union Property 3",
                    onLocationButtonPressed: () {},
                    suctionPressure: 15,
                    dischargePressure: 20,
                    oxygenAPressure: 8,
                    oxygenBPressure: 8,
                    ambientTemperature: 42,
                    totalCurrent: 16,
                    isRunning: true,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
