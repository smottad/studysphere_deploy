import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/card_asignatura.dart';
import 'package:studysphere/Controladores/controlador_ver_asignatura.dart';
import 'package:studysphere/Servicios/servicio_asignatura.dart';

final ServicioBaseDatosAsignatura servicioBaseDatos =
    ServicioBaseDatosAsignatura();

class VerAsignaturas extends StatelessWidget {
  const VerAsignaturas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Asignaturas", color: 0),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder<List<Asignatura>>(
          future: servicioBaseDatos.obtenerAsignaturasPorUsuario(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No se encontraron asignaturas'));
            } else {
              final asignaturas = snapshot.data!;
              return Column(
                children: [
                  Center(
                    child: Wrap(
                      spacing: 10,
                      children: asignaturas.map((asignatura) {
                        return CardAsignatura(
                          nameSubject: asignatura.nombre,
                          daysSelected: asignatura.diasSeleccionados,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () => irVerAsignaturasPasadas(context),
                    child: Text(
                      "Ver asignaturas pasadas",
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
