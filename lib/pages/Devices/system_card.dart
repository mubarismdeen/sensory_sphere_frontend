import 'package:flutter/material.dart';

import '../../constants/style.dart';
import 'system_inlay.dart';

class SystemCard extends StatefulWidget {
  final String label;
  final Function onLocationButtonPressed;
  final double suctionPressure;
  final double dischargePressure;
  final double oxygenAPressure;
  final double oxygenBPressure;
  final double ambientTemperature;
  final double totalCurrent;
  final bool isRunning;

  SystemCard({
    required this.label,
    required this.onLocationButtonPressed,
    required this.suctionPressure,
    required this.dischargePressure,
    required this.oxygenAPressure,
    required this.oxygenBPressure,
    required this.ambientTemperature,
    required this.totalCurrent,
    required this.isRunning,
  });

  @override
  _SystemCardState createState() => _SystemCardState();
}

class _SystemCardState extends State<SystemCard> {

  late bool _isRunning;

  @override
  void initState() {
    super.initState();
    _isRunning = widget.isRunning;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1000,
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
                        onPressed: () {
                          // Handle second feature button press
                        },
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          color: _isRunning ? green : shadowColor,
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(2),
                        onPressed: () {
                          // Handle first feature button press
                        },
                        icon: const Icon(
                          Icons.alarm_sharp,
                          color: shadowColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle third feature button press
                        },
                        icon: const Icon(
                          Icons.error_outline_sharp,
                          color: shadowColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SystemInlay(
                  suctionPressure: widget.suctionPressure,
                  dischargePressure: widget.dischargePressure,
                  oxygenAPressure: widget.oxygenAPressure,
                  oxygenBPressure: widget.oxygenBPressure,
                  ambientTemperature: widget.ambientTemperature,
                  totalCurrent: widget.totalCurrent),
              const SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     !_isRunning
              //         ? ElevatedButton.icon(
              //       onPressed: () {
              //         setState(() {
              //           _isRunning = true;
              //         });
              //       },
              //       icon: const Icon(Icons.play_arrow),
              //       label: const Text('Start'),
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor:
              //         Colors.green[500]?.withOpacity(0.85),
              //         foregroundColor: light,
              //       ),
              //     )
              //         : ElevatedButton.icon(
              //       onPressed: () {
              //         setState(() {
              //           _isRunning = false;
              //         });
              //       },
              //       icon: const Icon(Icons.stop),
              //       label: const Text('Stop'),
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.red[400]?.withOpacity(0.85),
              //         foregroundColor: light,
              //       ),
              //     ),
              //     ElevatedButton.icon(
              //       onPressed: () {
              //         // Handle reset button press
              //       },
              //       icon: const Icon(Icons.refresh),
              //       label: const Text('Reset'),
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.blue[400]?.withOpacity(0.85),
              //         foregroundColor: light,
              //       ),
              //     ),
              //   ],
              // ),
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
