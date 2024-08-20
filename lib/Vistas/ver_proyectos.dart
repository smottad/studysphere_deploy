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
        child: FutureBuilder<List<String>>(
          future: obtenerNombresProyectos(
              context), // Obtener los nombres de los proyectos
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child:
                    CircularProgressIndicator(), // Muestra un indicador de carga mientras se obtienen los datos
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                    'Error al cargar los proyectos'), // Maneja el caso de error
              );
            } else {
              // Si se obtienen los datos correctamente, crea las cards con los nombres de los proyectos
              List<String> nombresProyectos = snapshot.data ?? [];
              return Column(
                children: [
                  Center(
                    child: Wrap(
                      spacing: 10,
                      children: nombresProyectos.map((nombreProyecto) {
                        return CardProject(nameProject: nombreProyecto);
                      }).toList(),
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
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
