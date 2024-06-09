import 'package:flutter/material.dart';
import 'package:studysphere/Controladores/controlador_crear_asignatura.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({
    super.key,
    required this.textInit,
    required this.timeInit,
    required this.controllerTime,
  });

  final String textInit;
  final TimeOfDay timeInit;
  final ControllerTime controllerTime;

  @override
  State<TimePicker> createState() => _TimePicker();
}

class _TimePicker extends State<TimePicker> {
  TimeOfDay? selectedTime;

  Widget txtInit(time) {
    if (time != null) {
      return Text(
        time!.format(context),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      );
    } else {
      return Text(
        widget.textInit,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      onPressed: () async {
        final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: widget.timeInit,
        );
        setState(() {
          selectedTime = time;
          widget.controllerTime.time = time;
        });
      },
      child: txtInit(selectedTime),
    );
  }
}