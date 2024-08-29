import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:studysphere/Controladores/controlador_estudiar_examen.dart';
import 'package:studysphere/Controladores/controlador_ver_asignatura.dart';

class CountdownTimerWidget extends StatefulWidget {
  CountdownTimerWidget({
    super.key,
    required this.getAns,
    required this.getCorrectAns,
    required this.time,
    required this.dificultad,
    required this.temas,
    required this.idAsignatura,
    required this.nombreAsignatura,
  });

  Function getAns;
  Function getCorrectAns;
  int time;
  String dificultad;
  List<String> temas;
  String idAsignatura;
  String nombreAsignatura;

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  // Define the duration of the countdown timer
  Duration _duration = const Duration(minutes: 10);
  // Define a Timer object
  Timer? _timer;
  // Define a variable to store the current countdown value
  int _countdownValue = 0;

  @override
  void initState() {
    super.initState();
    // Start the countdown timer
    _duration = Duration(minutes: widget.time);
    startTimer();
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _timer?.cancel();
    super.dispose();
  }

  // Method to start the countdown timer
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds < 0) {
        // Countdown is finished
        _timer?.cancel();
        List<dynamic> ans = widget.getCorrectAns();
        List<String> correctAns = widget.getAns();
        print(ans);
        print(correctAns);
        int correctAnsNum = 0;
        for(int i = 0; i < correctAns.length; i++) {
          if (ans[i] == correctAns[i]) {
            correctAnsNum += 1;
          }
        }

        if (correctAnsNum <= 7 && correctAnsNum >= 5) {
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.warning,
            width: 700,
            dismissOnTouchOutside: false,
            btnCancelText: 'Volver',
            btnOkText: 'Repetir otro examen',
            title:
                'Regular: ${correctAnsNum/10*100}%',
            desc:
                'Tienes que estudiar un poco más',
            btnOkOnPress: () {
              irPrepararExamen(context, ExamenArgs(nombreMateria: widget.nombreAsignatura, idMateria: widget.idAsignatura));
            },
            btnCancelOnPress: () {
              irVerAsignaturasActuales(context);
            })
          .show();
          correctAnsNum = 0;
        } else if (correctAnsNum <= 10 && correctAnsNum >= 8) {
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.success,
            width: 700,
            dismissOnTouchOutside: false,
            btnCancelText: 'Volver',
            btnOkText: 'Repetir otro examen',
            title:
                'Muy bien: ${correctAnsNum/10*100}%',
            desc:
                'Tienes los conceptos interiorizados',
            btnOkOnPress: () {},
            btnCancelOnPress: () {})
          .show();
          correctAnsNum = 0;
        } else if (correctAnsNum <= 4) {
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.error,
            width: 700,
            dismissOnTouchOutside: false,
            btnCancelText: 'Volver',
            btnOkText: 'Repetir otro examen',
            title:
                'Muy mal: ${correctAnsNum/10*100}%',
            desc:
                'Tienes que estudiar mucho más',
            btnOkOnPress: () {},
            btnCancelOnPress: () {})
          .show();
          correctAnsNum = 0;
        }
        // Perform any desired action when the countdown is completed
      } else {
        // Update the countdown value and decrement by 1 second
        setState(() {
          _countdownValue = _duration.inSeconds;
          _duration = _duration - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Tiempo restante: $_countdownValue',
      style: const TextStyle(
        fontSize: 20
      ),
    );
  }
}