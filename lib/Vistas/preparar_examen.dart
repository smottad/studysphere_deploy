import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Controladores/controlador_estudiar_examen.dart';
import 'package:studysphere/Controladores/controlador_ver_asignatura.dart';
import 'package:studysphere/Servicios/servicio_mazo.dart';
import 'package:studysphere/Vistas/mazos.dart';

class PrepararExamen extends StatelessWidget {
  const PrepararExamen({
    super.key,
    required this.nombreAsignatura,
    required this.idAsignatura,
  });

  final String nombreAsignatura;
  final String idAsignatura;

  static const routeName = '/inicio/asignaturas/preparar_examen';

  @override   
  Widget build(BuildContext context) {
    List <String> selectedTemas = [];
    String selectedDificult = "";
    int selectedTime = 0;
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    Map<String, int> times = {'10 minutos': 10, '20 minutos': 20, '30 minutos': 30, '1 hora': 60, '2 horas': 120};

    return Scaffold(
      appBar: appBar(context, 'Preparación para el examen de $nombreAsignatura'),
      body: Center(
        child: FutureBuilder<List<Mazo>>(
          future: dbMazo.traerMazo(int.parse(idAsignatura)),
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
              return SizedBox(
                width: size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Seleccione los temas'),
                        MultiSelectDialogField(
                          title: const Text('Seleccione los temas'),
                          cancelText: const Text('Cancelar'),
                          dialogHeight: size.height * 0.3,
                          dialogWidth: size.width * 0.5,
                          searchHint: 'Seleccione los temas a evaluar',

                          items: List.empty(),
                          onConfirm: (results) {
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        DropdownButtonFormField(
                          alignment: Alignment.center,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 1,
                              ),
                            ),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          items: ['facil', 'medio', 'dificil'].map((dif) {
                            print("Entro Drop");
                            return DropdownMenuItem(
                              alignment: Alignment.center,
                              value: dif,
                              child: Text(dif),
                            );
                          }).toList(),
                          isExpanded: true,
                          hint: const Text("Seleccione la dificultad"),
                          onChanged: (value) {
                            selectedDificult = value!;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        DropdownButtonFormField(
                          alignment: Alignment.center,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 1,
                              ),
                            ),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          items: times.keys.map((key) {
                            print("Entro Drop");
                            return DropdownMenuItem(
                              alignment: Alignment.center,
                              value: times[key],
                              child: Text(key),
                            );
                          }).toList(),
                          isExpanded: true,
                          hint: const Text("Seleccione la duración del examen"),
                          onChanged: (value) {
                            selectedTime = value!;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                          ),
                          onPressed: () {
                            if (selectedTime == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Tiene que seleccionar una duración para el examen.',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Color.fromARGB(211, 209, 72, 72),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            } else if (selectedDificult == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Tiene que seleccionar una dificultad para el examen.',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Color.fromARGB(211, 209, 72, 72),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            } else {
                              irEstudiarExamen(context, ExamenArgs(nombreMateria: nombreAsignatura, idMateria: idAsignatura, dificultad: selectedDificult, temas: selectedTemas, tiempo: selectedTime));
                            }
                          },
                          child: Text(
                            "Empezar examen",
                            style: TextStyle(
                              color: colorScheme.scrim,
                            ),
                          )),  
                      ],
                    ),
              );
            } else {
              final mazos = snapshot.data!;
              print(mazos);
              return SizedBox(
                width: size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Seleccione los temas'),
                        MultiSelectDialogField(
                          title: const Text('Seleccione los temas'),
                          cancelText: const Text('Cancelar'),
                          dialogHeight: size.height * 0.3,
                          dialogWidth: size.width * 0.5,
                          searchHint: 'Seleccione los temas a evaluar',

                          items: mazos.map((mazo) => 
                            MultiSelectItem<String>(mazo.nombreMazo, mazo.nombreMazo)
                          ).toList(),
                          onConfirm: (results) {
                            selectedTemas = results;
                            print(selectedTemas);
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        DropdownButtonFormField(
                          alignment: Alignment.center,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 1,
                              ),
                            ),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          items: ['facil', 'medio', 'dificil'].map((dif) {
                            print("Entro Drop");
                            return DropdownMenuItem(
                              alignment: Alignment.center,
                              value: dif,
                              child: Text(dif),
                            );
                          }).toList(),
                          isExpanded: true,
                          hint: const Text("Seleccione la dificultad"),
                          onChanged: (value) {
                            selectedDificult = value!;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        DropdownButtonFormField(
                          alignment: Alignment.center,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 1,
                              ),
                            ),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          items: times.keys.map((key) {
                            print("Entro Drop");
                            return DropdownMenuItem(
                              alignment: Alignment.center,
                              value: times[key],
                              child: Text(key),
                            );
                          }).toList(),
                          isExpanded: true,
                          hint: const Text("Seleccione la duración del examen"),
                          onChanged: (value) {
                            selectedTime = value!;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                          ),
                          onPressed: () {
                            if (selectedTime == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Tiene que seleccionar una duración para el examen.',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Color.fromARGB(211, 209, 72, 72),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            } else if (selectedDificult == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Tiene que seleccionar una dificultad para el examen.',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Color.fromARGB(211, 209, 72, 72),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            } else {
                              irEstudiarExamen(context, ExamenArgs(nombreMateria: nombreAsignatura, idMateria: idAsignatura, dificultad: selectedDificult, temas: selectedTemas, tiempo: selectedTime));
                            }
                          },
                          child: Text(
                            "Empezar examen",
                            style: TextStyle(
                              color: colorScheme.scrim,
                            ),
                          )),  
                      ],
                    ),
              );
            }
          },
        ),
      ),
    );
  }
}