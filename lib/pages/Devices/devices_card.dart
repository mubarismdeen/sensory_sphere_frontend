import 'package:flutter/material.dart';

import '../../constants/style.dart';

class DevicesCard extends StatefulWidget {
  final String label;
  final Function onLocationButtonPressed;
  final double currentAmperes;
  final double pressurePsi;
  final double temperatureCelsius;

  DevicesCard({
    required this.label,
    required this.onLocationButtonPressed,
    required this.currentAmperes,
    required this.pressurePsi,
    required this.temperatureCelsius,
  });

  @override
  _DevicesCardState createState() => _DevicesCardState();
}

class _DevicesCardState extends State<DevicesCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 450,
      child: Card(
        color: cardColor,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        shadowColor: highlightedColor,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
                      style: TextStyle(
                        color: lightGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.all(2),
                        onPressed: () {
                          // Handle first feature button press
                        },
                        icon: Icon(Icons.electric_bolt, color: shadowColor),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle second feature button press
                        },
                        icon: Icon(Icons.play_arrow_rounded, color: shadowColor),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle third feature button press
                        },
                        icon: Icon(Icons.error_outline_sharp, color: shadowColor),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.location_on),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Location'),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: themeColor,
                  backgroundColor: locationButtonColor,
                ),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle start button press
                    },
                    icon: Icon(Icons.play_arrow),
                    label: Text('Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[500],
                      foregroundColor: light,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle reset button press
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400],
                      foregroundColor: light,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle stop button press
                    },
                    icon: Icon(Icons.stop),
                    label: Text('Stop'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: light,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      highlightedColor.withOpacity(0.5),
                    ),
                  ),
                  onPressed: () {
                    // Handle view details button press
                  },
                  child: Text('View Details', style: TextStyle(color: lightGrey)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
