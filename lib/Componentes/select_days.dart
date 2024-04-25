import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:studysphere/Componentes/time_picker.dart';
import 'package:studysphere/Controladores/controlador_crear_asignatura.dart';

ControllerTime tmInit = ControllerTime(time: TimeOfDay.now());
ControllerTime tmFinal = ControllerTime(time: TimeOfDay.now());

class SelectDays extends StatefulWidget{
  const SelectDays({super.key,
  this.confirmDays = const ["false", "false", "false", "false", "false", "false", "false"]});

  final List<String> confirmDays;

  @override
  State<SelectDays> createState() => _SelectDays();
}

class _SelectDays extends State<SelectDays> {
  TimePicker initTime = TimePicker(textInit: "Hora de inicio", timeInit: TimeOfDay.now(), controllerTime: tmInit,);
  TimePicker finalTime = TimePicker(textInit: "Hora final", timeInit: tmInit.time!, controllerTime: tmFinal,);

  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Center(
        child: // Row(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          // children: [
          //   SizedBox(
          //     height: 50,
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dayButton(context, 'L', Theme.of(context).colorScheme.onSecondary, cambioColor(0), 0), 
                  dayButton(context, 'M', Theme.of(context).colorScheme.onSecondary, cambioColor(1), 1),
                  dayButton(context, 'W', Theme.of(context).colorScheme.onSecondary, cambioColor(2), 2),
                  dayButton(context, 'J', Theme.of(context).colorScheme.onSecondary, cambioColor(3), 3),
                  dayButton(context, 'V', Theme.of(context).colorScheme.onSecondary, cambioColor(4), 4),
                  dayButton(context, 'S', Theme.of(context).colorScheme.onSecondary, cambioColor(5), 5),
                  dayButton(context, 'D', Theme.of(context).colorScheme.onSecondary, cambioColor(6), 6),
                  const SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      initTime,
                      const SizedBox(height: 15,),
                      finalTime,
                    ],
                  ),
                ]
              ),
            )
          );
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             TextButton(
    //               onPressed: () {
                    
    //               },
    //               child: const Text('Hora inicio'),
    //             ),
    //             TextButton(
    //               onPressed: () {
                    
    //               },
    //               child: const Text('Hora final'),
    //             ),
                
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Color cambioColor(int index) {
    if (widget.confirmDays[index] == "false") {
      return Theme.of(context).colorScheme.onTertiary;
    } 

    return Theme.of(context).colorScheme.primary;
  }

  dayButton (BuildContext context, String day, Color colorText, Color backgroundColor, int index) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: 55,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: backgroundColor,
        ),
        onPressed: () {
          setState(() {
            if (widget.confirmDays[index] == "false") {
              widget.confirmDays[index] = "true";
            } else {
              widget.confirmDays[index] = "false";
            }
          });
        },
        child: Center( 
          child: Text(
            day,
            style: TextStyle(
              color: colorText,
            ),
          ),
        ),
      )    
    );
  }
}