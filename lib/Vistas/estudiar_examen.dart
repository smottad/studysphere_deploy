import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/card_pregunta.dart';
import 'package:studysphere/Componentes/temporizador.dart';
import 'package:studysphere/Controladores/controlador_estudiar_examen.dart';
import 'package:studysphere/Controladores/controlador_ver_asignatura.dart';
import 'dart:html' as html;
import 'package:studysphere/Vistas/crear_mazo.dart';

class EstudiarExamen extends StatefulWidget {
  const EstudiarExamen({
    super.key,
    required this.dificultad,
    required this.temas,
    required this.tiempo,
    required this.asignatura,
    required this.idAsignatura,
  });

  final String dificultad;
  final List<String> temas;
  final int tiempo;
  final String asignatura;
  final String idAsignatura;

  static const routeName = '/inicio/asignaturas/estudiar_examen';

  @override
  State<EstudiarExamen> createState() => _EstudiarExamenState();
}

class _EstudiarExamenState extends State<EstudiarExamen> {
  final ScrollController _scrollController = ScrollController();
  List<String> answers = ['-1', '-1', '-1', '-1', '-1', '-1', '-1', '-1', '-1', '-1',];
  List<dynamic> correctAnswersArr = [];
  bool areAllAnswers = true;
  int correctAnswers = 0;
  String strTemas = "";

  void makeString() {
    print('Temas examen ${widget.asignatura}');
    if (widget.temas.isNotEmpty) {
      for (int i = 0; i < widget.temas.length; i++) {
        if(widget.temas.length > 1) {
          if (i == widget.temas.length - 1) {
            strTemas += 'y ';
            strTemas += '${widget.temas[i]}';
          } else if (i == widget.temas.length - 2) {
            strTemas += '${widget.temas[i]} ';
          } else {
            strTemas += '${widget.temas[i]}, ';
          }
        } else {
          strTemas += '${widget.temas[i]}';
        }
      } 
    } else {
      strTemas = widget.asignatura;
      print('Asignaturas examen: ${widget.asignatura}');
    }
    print('Temas string ${widget.temas.isEmpty} ${strTemas}');
  }

  void changeAns(int index, String value) {
    answers[index] = value;
  }

  List<String> getAns() {
    return answers;
  }

  List<dynamic> getCorrectAns() {
    return correctAnswersArr;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

    makeString();

    print('StrString: $strTemas');

    return Scaffold(
      appBar: appBar(context, "Examén"),
      body: FutureBuilder<Map>(
        future: generacionExamen(strTemas, widget.dificultad), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: const CircularProgressIndicator(),
              ) 
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Column(
              children: [
                const Text('No se generó el exámen,'),
                const SizedBox(height: 25,),
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                ),
                onPressed: () {
                  irPrepararExamen(context, ExamenArgs(nombreMateria: widget.asignatura, idMateria: widget.idAsignatura));
                },
                child: Text(
                  "Empezar examen",
                  style: TextStyle(
                    color: colorScheme.scrim,
                  ),
                )),  
              ],
            )
            );
          } else {
            final examen = snapshot.data!;
            correctAnswersArr = examen['respuestas'];
            return Center(
              child: Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: size.width * 0.5,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10, 
                            right: 30,
                            child: CountdownTimerWidget(
                              getAns: getAns,
                              getCorrectAns: getCorrectAns,
                              time: widget.tiempo,
                              dificultad: widget.dificultad,
                              idAsignatura: widget.idAsignatura,
                              nombreAsignatura: widget.asignatura,
                              temas: widget.temas,
                            ),
                          ),
                          Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Title(
                              color: colorScheme.shadow, 
                              child: Text(
                                examen['titulo'],
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Instrucciones: ",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  examen['instrucciones'],
                                  style: const TextStyle(
                                    fontSize: 20
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            for(int i = 0; i < 10; i++) 
                              CardPregunta(
                                pregunta: examen['pregunta${i+1}']!,
                                respuestas: examen['respuestas${i+1}']!,
                                id: i,
                                itemCallback: changeAns,
                              ),  
                            ElevatedButton(
                              onPressed: () {
                                print(answers);
                                for(int i = 0; i < answers.length; i++) {
                                  if (answers[i] == '-1') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Tienes que responder todas las respuestas',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Color.fromARGB(211, 209, 72, 72),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                    areAllAnswers = false;
                                    correctAnswers = 0;
                                    break;
                                  } else if (answers[i] == examen['respuestas'][i]) {
                                    correctAnswers += 1;
                                    areAllAnswers = true;
                                  }
                                }

                                if (areAllAnswers) {
                                  if (correctAnswers <= 7 && correctAnswers >= 5) {
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.scale,
                                      dialogType: DialogType.warning,
                                      width: 700,
                                      dismissOnTouchOutside: false,
                                      btnCancelText: 'Volver',
                                      btnOkText: 'Repetir otro examen',
                                      title:
                                          'Regular: ${correctAnswers/10*100}%',
                                      desc:
                                          'Tienes que estudiar un poco más',
                                      btnOkOnPress: () {
                                        irPrepararExamen(context, ExamenArgs(nombreMateria: widget.asignatura, idMateria: widget.idAsignatura));
                                      },
                                      btnCancelOnPress: () {
                                        irVerAsignaturasActuales(context);
                                      })
                                    .show();
                                    correctAnswers = 0;
                                  } else if (correctAnswers <= 10 && correctAnswers >= 8) {
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.scale,
                                      dialogType: DialogType.success,
                                      width: 700,
                                      dismissOnTouchOutside: false,
                                      btnCancelText: 'Volver',
                                      btnOkText: 'Repetir otro examen',
                                      title:
                                          'Muy bien: ${correctAnswers/10*100}%',
                                      desc:
                                          'Tienes los conceptos interiorizados',
                                      btnOkOnPress: () {
                                        irPrepararExamen(context, ExamenArgs(nombreMateria: widget.asignatura, idMateria: widget.idAsignatura));
                                      },
                                      btnCancelOnPress: () {
                                        irVerAsignaturasActuales(context);
                                      })
                                    .show();
                                    correctAnswers = 0;
                                  } else if (correctAnswers <= 4) {
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.scale,
                                      dialogType: DialogType.error,
                                      width: 700,
                                      dismissOnTouchOutside: false,
                                      btnCancelText: 'Volver',
                                      btnOkText: 'Repetir otro examen',
                                      title:
                                          'Muy mal: ${correctAnswers/10*100}%',
                                      desc:
                                          'Tienes que estudiar mucho más',
                                      btnOkOnPress: () {
                                        irPrepararExamen(context, ExamenArgs(nombreMateria: widget.asignatura, idMateria: widget.idAsignatura));
                                      },
                                      btnCancelOnPress: () {
                                        irVerAsignaturasActuales(context);
                                      })
                                    .show();
                                    correctAnswers = 0;
                                  }
                                }
                              }, 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.secondary,
                              ),
                              child: Text(
                                "Terminar",
                                style: TextStyle(
                                  color: colorScheme.onPrimary
                                ),
                              ),
                            ),  
                            const SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                        ],
                      ),
                    );
                  },
                ),
              ), 
            );
          }
        },
      ),
    );
  }
}
