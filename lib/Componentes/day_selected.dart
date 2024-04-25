import 'package:flutter/material.dart';

class DaySelected extends StatelessWidget {
  const DaySelected({super.key, required this.color, required this.day}); 

  final Color color;
  final String day;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
      width: 33,
      height: 33,
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(3, 0, 3, 0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center( 
            child: Text(
              day,
              textAlign: TextAlign.center,
                style: const TextStyle(
                fontSize: 10,
              ), 
            ),
          ),
        ),
      ),
    );
  }
}