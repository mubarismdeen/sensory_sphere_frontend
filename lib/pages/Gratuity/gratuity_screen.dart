import 'package:admin/api.dart';
import 'package:admin/models/empMaster.dart';
import 'package:admin/widget/custom_text.dart';
import 'package:admin/widget/gratuity_calculat.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../constants/controllers.dart';
import '../../helpers/responsiveness.dart';
import '../../widget/gratuity_details.dart';

class GratuityScreen extends StatefulWidget {
  const GratuityScreen({Key? key}) : super(key: key);

  @override
  State<GratuityScreen> createState() => _GratuityScreenState();
}

class _GratuityScreenState extends State<GratuityScreen> {
  List<Map<String, dynamic>> _gratuityDetails = <Map<String, dynamic>>[];
  List<EmpMaster> _empDetails = List<EmpMaster>.empty();
  List<Map<String, dynamic>> _gratuityType = <Map<String, dynamic>>[];

  getTableData() async {
    _empDetails = await getGratuityEmp();
    _gratuityType = await getGratuityType();
    _gratuityDetails = await getGratuityDetails();
  }

  closeDialog() {
    setState(() {
      getTableData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getTableData(),
        builder: (context, AsyncSnapshot<dynamic> _data) {
          if (_empDetails.isEmpty) {
            return const Center(
              child: Text(
                "No employees have resigned currently.",
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            );
          }
          if (_data.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SizedBox(
                    width: 25, height: 25, child: CircularProgressIndicator()));
          } else if (_data.hasError) {
            return Text('Error: ${_data.error}');
          } else {
            return SingleChildScrollView(
              child: Column(children: [
                Obx(() => Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: ResponsiveWidget.isSmallScreen(context)
                                  ? 56
                                  : 26,
                              left: 23),
                          child: CustomText(
                            text: menuController.activeItem.value,
                            size: 24,
                            weight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      ],
                    )),
                GratuityCalculateWidget(
                    _empDetails, _gratuityType, closeDialog),
                GratuityDetailsWidget(_gratuityDetails, closeDialog),
              ]),
            );
          }
        });
  }
}
