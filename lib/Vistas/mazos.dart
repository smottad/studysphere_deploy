import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/card_mazos.dart';
import 'package:studysphere/Servicios/servicio_mazo.dart';
import 'package:studysphere/Controladores/controlador_ver_mazos.dart';

class VerMazos extends StatelessWidget {
  const VerMazos({super.key});

  @override 
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: appBar(context, "Mazos"),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          goToCrearMazo(context);
        }, 
        icon: Icon(
          Icons.add,
          color: colorScheme.shadow,
        ), 
        label: Text(
          "Crear mazo",
          style: TextStyle(
            color: colorScheme.shadow,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
        ),       
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,  
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Wrap(
                spacing: 10,
                // runAlignment: WrapAlignment.center,
                // crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const CardMazo(nameMaze: "Sustantivos", subjectMaze: "Alemán",),
                  const CardMazo(nameMaze: "SCRUM", subjectMaze: "Ingeniería de software",),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        ServicioBaseDatosMazo dbMazo = ServicioBaseDatosMazo();
                        dbMazo.traerMazos();
                      } catch(error) {
                        print(error);
                      }
                    }, 
                    child: const Text("Traer mazos"), 
                  ),      
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}