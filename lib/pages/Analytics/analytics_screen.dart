import 'package:admin/api.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/pages/Analytics/charts_widget.dart';
import 'package:admin/widget/loading_wrapper.dart';
import 'package:flutter/material.dart';

import '../../models/chart_data.dart';
import '../../models/status_entity.dart';
import '../../utils/common_utils.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<StatusEntity> propertyDropdownOptions = <StatusEntity>[];
  List<StatusEntity> intervalDropdownOptions = <StatusEntity>[];

  String propertyDropdownValue = '';
  String intervalDropdownValue = '';
  bool _showPageLoading = true;
  bool _showDataLoading = true;

  List<ChartData> dataList = [];

  loadChartData() async {
    try {
      dataList =
          await getChartData(propertyDropdownValue, intervalDropdownValue);
      if (dataList.isEmpty) {
        showSaveFailedMessage(context, "No data available for this property");
      }
    } catch (error) {
      showSaveFailedMessage(context, "Unable to fetch data");
    }
    setState(() {
      _showDataLoading = false;
    });
  }

  getDropdownInputs() async {
    try {
      propertyDropdownOptions = await getProperties();
      propertyDropdownValue = propertyDropdownOptions.first.description;
      intervalDropdownOptions = await getTimeIntervals();
      intervalDropdownValue = intervalDropdownOptions.first.description;
      setState(() {
        _showPageLoading = false;
      });
    } catch (error) {
      showSaveFailedMessage(context, "Unable to fetch dropdown values");
    }
    await loadChartData();
  }

  @override
  void initState() {
    super.initState();
    getDropdownInputs();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      height: 300,
      isLoading: _showPageLoading,
      color: highlightedColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlueAccent),
                  child: Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: themeColor),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          value: propertyDropdownValue,
                          style: const TextStyle(
                              color: lightGrey, fontWeight: FontWeight.bold),
                          items: propertyDropdownOptions
                              .map<DropdownMenuItem<String>>(
                                  (StatusEntity value) {
                            return DropdownMenuItem<String>(
                                value: (value.description),
                                child: Text(value.description));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              propertyDropdownValue = value!;
                              _showDataLoading = true;
                              loadChartData();
                            });
                          }),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightGreen),
                  child: Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: themeColor),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          value: intervalDropdownValue,
                          style: const TextStyle(
                              color: lightGrey, fontWeight: FontWeight.bold),
                          items: intervalDropdownOptions
                              .map<DropdownMenuItem<String>>(
                                  (StatusEntity value) {
                            return DropdownMenuItem<String>(
                                value: (value.description),
                                child: Text(value.description));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              intervalDropdownValue = value!;
                              _showDataLoading = true;
                              loadChartData();
                            });
                          }),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            LoadingWrapper(
              isLoading: _showDataLoading,
              height: 400,
              color: highlightedColor,
              child: ChartsWidget(dataList: dataList),
            ),
          ],
        ),
      ),
    );
  }
}
