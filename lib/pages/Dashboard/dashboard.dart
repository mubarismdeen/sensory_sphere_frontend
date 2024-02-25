import 'package:admin/pages/Dashboard/dashboard_card.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);

  initPageData() async {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: initPageData(),
      builder: (context, AsyncSnapshot<dynamic> _data) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  children: [
                    DashboardCard(
                        label: "Al Qudra Lake",
                        onLocationButtonPressed: () {},
                        suctionPressure: 10,
                        dischargePressure: 15,
                        oxygenAPressure: 12,
                        oxygenBPressure: 13,
                        ambientTemperature: 25,
                        totalCurrent: 10),
                    DashboardCard(
                        label: "Union Property 1",
                        onLocationButtonPressed: () {},
                        suctionPressure: 12,
                        dischargePressure: 18,
                        oxygenAPressure: 10,
                        oxygenBPressure: 11,
                        ambientTemperature: 35,
                        totalCurrent: 13),
                    DashboardCard(
                        label: "Union Property 2",
                        onLocationButtonPressed: () {},
                        suctionPressure: 0,
                        dischargePressure: 5,
                        oxygenAPressure: 15,
                        oxygenBPressure: 13,
                        ambientTemperature: 45,
                        totalCurrent: 2),
                    DashboardCard(
                        label: "Union Property 3",
                        onLocationButtonPressed: () {},
                        suctionPressure: 15,
                        dischargePressure: 20,
                        oxygenAPressure: 8,
                        oxygenBPressure: 8,
                        ambientTemperature: 42,
                        totalCurrent: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
