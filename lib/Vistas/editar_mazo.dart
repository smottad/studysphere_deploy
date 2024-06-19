import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/my_dropdown_widget.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_editar_mazo.dart';
import 'package:studysphere/Servicios/servicio_mazo.dart';

String selectedMateria = ""; // Variable para almacenar el nombre de la materia seleccionada
int selectedMateriaId = 0; // Variable para almacenar el ID de la materia seleccionada

Map<String, int> asignaturas = {};

Future<void> actualizarAsignaturas() async {
  try {
    asignaturas = await getAsignaturas();
    // print(asignaturas.keys.toList());
    for (var asignatura in asignaturas.keys) {
      print(asignatura is String);
    }
  } catch (error) {
    // Manejar cualquier error que pueda ocurrir durante la actualización de las asignaturas
    print('Error al actualizar las asignaturas: $error');
  }
}

class EditarMazo extends StatelessWidget {
  EditarMazo({super.key, required this.idMaze, required this.nameMaze, required this.subjectMaze, required this.cantidad});

  final int idMaze;
  final String nameMaze;
  String subjectMaze;
  final int cantidad;

  static const routeName = '/inicio/mazos/editar_mazo';

  @override 
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

    nombreMazo.text = nameMaze;

    print("---------- Hola ----------");
    // print(args.idMaze);
    actualizarAsignaturas();

    return Scaffold(
      appBar: appBar(context, "Editar Mazo"),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: colorScheme.scrim,
                blurRadius: 20,
                offset: const Offset(5, 5),
              )
            ],
          ),
          width: (size.width * 0.5).clamp(300, 600),
          height: (size.height * 0.5).clamp(300, 1200),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textFormulario(context, nombreMazo, "Ingrese el nombre del mazo",),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        left: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        right: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      )),
                  width: 300,
                  child: FutureBuilder<Map<String, int>>(
                    future: getAsignaturas(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return DropdownButtonFormField(
                          alignment: Alignment.center,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 1,
                              ),
                            ),
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          items: List.empty(),
                          isExpanded: true,
                          hint: const Text("Seleccione la materia"),
                          onChanged: (value) {},
                        );
                      } else if (snapshot.hasError) {
                        return DropdownButtonFormField(
                          alignment: Alignment.center,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 1,
                              ),
                            ),
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          items: List.empty(),
                          isExpanded: true,
                          hint: const Text("Seleccione la materia"),
                          onChanged: (value) {},
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty){
                        return DropdownButtonFormField(
                          alignment: Alignment.center,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 1,
                              ),
                            ),
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          items: List.empty(),
                          isExpanded: true,
                          hint: const Text("Seleccione la materia"),
                          onChanged: (value) {},
                        );
                      } else {
                        final subjects = snapshot.data!;
                        return MyDropdownWidget(
                          asignaturas: subjects, 
                          hintText: "Seleccione la materia", 
                          currentItem: subjectMaze, 
                          itemCallback: (String status) {
                            subjectMaze = status;
                            selectedMateria = status;
                            selectedMateriaId = subjects[selectedMateria]!;
                          }, 
                          idCurrentItem: subjects[subjectMaze]!);
                      }
                    },
                  ), 
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                  ),
                  onPressed: () {
                    if(nombreMazo.text.isNotEmpty && selectedMateria != "") {
                      try {
                        ServicioBaseDatosMazo bdMazo = ServicioBaseDatosMazo();
                        Mazo nuevoMazo = Mazo(
                          id: idMaze,
                          nombreMazo: nombreMazo.text, 
                          idAsignaturaMazo: selectedMateriaId, 
                          nombreAsignaturaMazo: selectedMateria,
                          cantidad: cantidad
                        );
                        
                        bdMazo.actualizarMazo(nuevoMazo);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Se ha actualizado con exito"),
                            duration: Duration(seconds: 1),),
                          );

                          goToMazes(context);
                      } catch(error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Error al guardar el mazo: $error",
                              style: TextStyle(
                                color: colorScheme.onTertiary,
                              ),
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: const Color.fromRGBO(255, 50, 50, 1),
                          )
                        );
                      }
                    } else {
                      print(nombreMazo.text.isNotEmpty);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Llene todo los campos",
                            style: TextStyle(
                              color: colorScheme.onTertiary,
                            ),
                          ),
                          duration: const Duration(seconds: 2),
                          backgroundColor: const Color.fromRGBO(255, 50, 50, 1),
                        )
                      );
                    }
                  }, 
                  child: Text(
                    "Guardar",
                    style: TextStyle(
                      color: colorScheme.scrim,
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}