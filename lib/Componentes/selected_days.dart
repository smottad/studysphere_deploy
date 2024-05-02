import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/day_selected.dart';

class SelectedDays extends StatefulWidget{
  const SelectedDays(
    {
      super.key,
      required this.selected
    }
  );

  final List<bool> selected;

  @override
  State<SelectedDays> createState() => _SelectedDays();
}

class _SelectedDays extends State<SelectedDays>{
  List<String> days = ["L", "M", "W", "J", "V", "S", "D"];

  Color changeColorDay (int index) {
    Color colorDay = const Color.fromARGB(255, 255, 255, 255);
    
    if (widget.selected[index]) {
      colorDay = Theme.of(context).colorScheme.secondary;
    }

    return colorDay;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < days.length; i++) 
          DaySelected(color: changeColorDay(i), day: days[i]),
      ],
    );
  }
}