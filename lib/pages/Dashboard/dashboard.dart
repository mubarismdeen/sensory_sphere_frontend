import 'package:admin/constants/style.dart';
import 'package:admin/widget/custom_text.dart';
import 'package:admin/pages/Dashboard/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../constants/controllers.dart';
import '../../helpers/responsiveness.dart';

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
              SizedBox(height: 60,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 500,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DashboardCard(
                            label: "Al Qudra Lake",
                            currentAmperes: 10,
                            pressurePsi: 15,
                            temperatureCelsius: 30,
                            onLocationButtonPressed: () {}),
                        DashboardCard(
                            label: "Union Property 1",
                            currentAmperes: 5,
                            pressurePsi: 8,
                            temperatureCelsius: 40,
                            onLocationButtonPressed: () {}),
                        DashboardCard(
                            label: "Union Property 2",
                            currentAmperes: 15,
                            pressurePsi: 18,
                            temperatureCelsius: 42,
                            onLocationButtonPressed: () {}),
                        DashboardCard(
                            label: "Union Property 3",
                            currentAmperes: 9,
                            pressurePsi: 20,
                            temperatureCelsius: 35,
                            onLocationButtonPressed: () {}),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
