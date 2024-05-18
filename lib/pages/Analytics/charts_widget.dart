import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/chart_data.dart';

class ChartsWidget extends StatelessWidget {
  final List<ChartData> dataList;
  ChartsWidget({
    required this.dataList,
  });

  @override
  Widget build(BuildContext context) {
    return dataList.isEmpty
        ? const SizedBox(
            height: 450,
            child: Center(
              child: Text(
                "No Data Present",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          )
        : Column(
            children: [
              motorPressureChart(),
              oxygenPressureChart(),
              currentChart(),
              temperatureChart(),
            ],
          );
  }

  Widget motorPressureChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: SfCartesianChart(
        crosshairBehavior: CrosshairBehavior(
            enable: true,
            lineColor: lightGrey,
            activationMode: ActivationMode.singleTap),
        primaryXAxis: CategoryAxis(),
        title: chartTitle("Motor Pressure"),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          overflowMode: LegendItemOverflowMode.wrap,
          orientation: LegendItemOrientation.horizontal,
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries>[
          LineSeries<ChartData, String>(
            name: 'Discharge Pressure',
            dataSource: dataList,
            xValueMapper: (ChartData data, _) => data.xCoordinate,
            yValueMapper: (ChartData data, _) => data.dischargePressure,
            color: Colors.yellow,
          ),
          LineSeries<ChartData, String>(
              name: 'Suction Pressure',
              dataSource: dataList,
              xValueMapper: (ChartData data, _) => data.xCoordinate,
              yValueMapper: (ChartData data, _) => data.suctionPressure,
              color: Colors.lightBlue),
        ],
      ),
    );
  }

  Widget oxygenPressureChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: chartTitle('Oxygen Pressure'),
        crosshairBehavior: CrosshairBehavior(
            enable: true,
            lineColor: lightGrey,
            activationMode: ActivationMode.singleTap),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          overflowMode: LegendItemOverflowMode.wrap,
          orientation: LegendItemOrientation.horizontal,
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries>[
          LineSeries<ChartData, String>(
            name: 'Pressure A',
            dataSource: dataList,
            xValueMapper: (ChartData data, _) => data.xCoordinate,
            yValueMapper: (ChartData data, _) => data.oxygenAPressure,
            color: Colors.green.shade200,
          ),
          LineSeries<ChartData, String>(
            name: 'Pressure B',
            dataSource: dataList,
            xValueMapper: (ChartData data, _) => data.xCoordinate,
            yValueMapper: (ChartData data, _) => data.oxygenBPressure,
            color: Colors.green.shade800,
          ),
        ],
      ),
    );
  }

  Widget currentChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: chartTitle('Total Current'),
        crosshairBehavior: CrosshairBehavior(
            enable: true,
            lineColor: lightGrey,
            activationMode: ActivationMode.singleTap),
        legend: Legend(isVisible: false),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries>[
          LineSeries<ChartData, String>(
            name: 'Total Current',
            dataSource: dataList,
            xValueMapper: (ChartData data, _) => data.xCoordinate,
            yValueMapper: (ChartData data, _) => data.totalCurrent,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget temperatureChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: chartTitle('Ambient Temperature'),
        crosshairBehavior: CrosshairBehavior(
            enable: true,
            lineColor: lightGrey,
            activationMode: ActivationMode.singleTap),
        legend: Legend(isVisible: false),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries>[
          LineSeries<ChartData, String>(
              name: 'Ambient Temperature',
              dataSource: dataList,
              xValueMapper: (ChartData data, _) => data.xCoordinate,
              yValueMapper: (ChartData data, _) => data.ambientTemperature,
              color: Colors.red),
        ],
      ),
    );
  }

  ChartTitle chartTitle(String title) {
    return ChartTitle(
      text: title,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, color: lightGrey),
    );
  }
}
