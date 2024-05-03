import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/card_proyecto.dart';
import 'package:studysphere/Controladores/controlador_ver_proyectos.dart';

class VerProyectos extends StatelessWidget {
  const VerProyectos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Proyectos", color: 0),
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
                  CardProject(nameProject: "Study Sphere",),
                  CardProject(nameProject: "ChazApp",),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () => goVerProyectosPasados(context),
              child: Text(
                "Ver proyectos pasados",
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