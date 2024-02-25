import 'package:flutter/material.dart';

import '../../constants/style.dart';
import 'inlay_widget.dart';

class DashboardCard extends StatefulWidget {
  final String label;
  final Function onLocationButtonPressed;
  final double suctionPressure;
  final double dischargePressure;
  final double oxygenAPressure;
  final double oxygenBPressure;
  final double ambientTemperature;
  final double totalCurrent;

  DashboardCard({
    required this.label,
    required this.onLocationButtonPressed,
    required this.suctionPressure,
    required this.dischargePressure,
    required this.oxygenAPressure,
    required this.oxygenBPressure,
    required this.ambientTemperature,
    required this.totalCurrent,
  });

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      // height: 450,
      child: Card(
        color: cardColor,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        shadowColor: highlightedColor,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        color: lightGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  // SizedBox(width: 30,),
                  Row(
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(2),
                        onPressed: () {
                          // Handle first feature button press
                        },
                        icon: const Icon(Icons.alarm_sharp, color: shadowColor),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle second feature button press
                        },
                        icon:
                            const Icon(Icons.play_arrow_rounded, color: shadowColor),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle third feature button press
                        },
                        icon:
                            const Icon(Icons.error_outline_sharp, color: shadowColor),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.location_on),
                label: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Location'),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: themeColor,
                  backgroundColor: locationButtonColor,
                ),
              ),
              const SizedBox(height: 10),
              InlayWidget(
                  suctionPressure: widget.suctionPressure,
                  dischargePressure: widget.dischargePressure,
                  oxygenAPressure: widget.oxygenAPressure,
                  oxygenBPressure: widget.oxygenBPressure,
                  ambientTemperature: widget.ambientTemperature,
                  totalCurrent: widget.totalCurrent),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle start button press
                    },
                    icon: Icon(Icons.play_arrow),
                    label: Text('Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[500]?.withOpacity(0.85),
                      foregroundColor: light,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle reset button press
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400]?.withOpacity(0.85),
                      foregroundColor: light,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle stop button press
                    },
                    icon: Icon(Icons.stop),
                    label: Text('Stop'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400]?.withOpacity(0.85),
                      foregroundColor: light,
                    ),
                  ),
                ],
              ),
              // Center(
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //         backgroundColor: MaterialStateProperty.all<Color>(
              //             highlightedColor.withOpacity(0.5))),
              //     onPressed: () {
              //       // Handle view details button press
              //     },
              //     child:
              //         const Text('View Details', style: TextStyle(color: lightGrey)),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
