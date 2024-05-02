import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/card_proyecto.dart';
import 'package:studysphere/Controladores/controlador_ver_proyectos.dart';

class VerProyectosPasados extends StatelessWidget {
  const VerProyectosPasados({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Proyectos Pasados", color: 0),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,  
        child: Column( 
          children: [
            const Center(
              child: Wrap(
                spacing: 10,
                // runAlignment: WrapAlignment.center,
                // crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  CardProject(nameProject: "Tetrizz",),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () => goVeProyectosActuales(context),
              child: Text(
                "Ver proyectos actuales",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ]
        ),
      ),
    ); 
  }
}