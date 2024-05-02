import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/card_asignatura.dart';
import 'package:studysphere/Controladores/controlador_ver_asignatura.dart';

class VerAsignaturasPasadas extends StatelessWidget {
  const VerAsignaturasPasadas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Asignaturas Pasadas", color: 0),
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
                  CardAsignatura(nameSubject: "Ingeniería de software I", daysSelected: [true, false, true, false, false, false, false,],),
                  CardAsignatura(nameSubject: "Italiano I", daysSelected: [false, true, false, true, false, true, false,],),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () => irVerAsignaturasActuales(context),
              child: Text(
                "Ver asignaturas actuales",
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