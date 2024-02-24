import 'package:flutter/material.dart';

import '../../constants/style.dart';
import 'inlay_widget.dart';

class DashboardCard extends StatefulWidget {
  final String label;
  final Function onLocationButtonPressed;
  final double currentAmperes;
  final double pressurePsi;
  final double temperatureCelsius;

  DashboardCard({
    required this.label,
    required this.onLocationButtonPressed,
    required this.currentAmperes,
    required this.pressurePsi,
    required this.temperatureCelsius,
  });

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
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
                  // SizedBox(width: 30,),
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
              InlayWidget(
                currentAmperes: widget.currentAmperes,
                pressurePsi: widget.pressurePsi,
                temperatureCelsius: widget.temperatureCelsius,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
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
