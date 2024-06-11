
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/cards.dart';
import 'package:studysphere/Componentes/menu_expandible.dart';
import 'package:studysphere/Controladores/controlador_pagina_inicio.dart';

class PaginaInicio extends StatelessWidget {
  static const _actionTitles = [
    'Crear recordatorio',
    'Crear flashcard',
    'Añadir asignatura',
    'Añadir proyecto',
  ];
  const PaginaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    //final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(context, "Study Sphere", menu: true),
      floatingActionButton: ExpandableFab(
        distance: 200,
        children: [
          Column(children: [
            ActionButton(
                onPressed: () => showAction(context, 0),
                icon: Icon(Icons.alarm, color: colorScheme.onSecondary)),
            Text(_actionTitles[0])
          ]),
          Column(children: [
            ActionButton(
              onPressed: () => showAction(context, 1),
              icon: Icon(
                Icons.bookmark,
                color: colorScheme.onSecondary,
              ),
            ),
            Text(_actionTitles[1])
          ]),
          Column(children: [
            ActionButton(
              onPressed: () => showAction(context, 2),
              icon: Icon(
                Icons.book,
                color: colorScheme.onSecondary,
              ),
            ),
            Text(_actionTitles[2])
          ]),
          Column(children: [
            ActionButton(
              onPressed: () => showAction(context, 3),
              icon: Icon(
                Icons.timeline,
                color: colorScheme.onSecondary,
              ),
            ),
            Text(_actionTitles[3])
          ]),
        ],
      ),
        backgroundColor: colorScheme.surface,
      drawer: Drawer(
        width: (size.width * 0.8).clamp(100, 400),
        backgroundColor: colorScheme.primary,
        elevation: 2,
        child: Column(
          children: [
            //sin esto va desde el lugar de notificaciones, no se porque
            const SizedBox(height: 30),
            fotoYConfiguracion(size, context, colorScheme),
            cards(context, Icons.book, 'Asignaturas', irAsignaturas),
            cards(context, Icons.timeline, 'Proyectos', irProyectos),
            cards(context, Icons.view_week, 'Horario', irHorario),
          ],
        ),
      ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.count(
            scrollDirection: kIsWeb ? Axis.vertical : Axis.horizontal,
            crossAxisCount: 3,
            children: const [
              SizedBox(
                child: ColoredBox(color: Colors.blue),
              ),
              SizedBox(
                child: ColoredBox(color: Colors.blue),
              ),
              SizedBox(
                child: ColoredBox(color: Colors.blue),
              ),
            ],
            //children: [FutureBuilder(future: getAsignaturas(), builder: )],
          ),
        )
    );
  }

  Padding fotoYConfiguracion(
      Size size, BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          getFotoUsuario(
            (size.height * 0.1).clamp(10, 50),
            (size.height * 0.1).clamp(10, 50),
          ),
          const Spacer(),
          InkWell(
            onTap: () => irConfiguracion(context),
            child: Icon(
              Icons.settings,
              color: colorScheme.onPrimary,
              size: (size.height * 0.1).clamp(10, 50),
            ),
          ),
        ],
      ),
    );
  }
}
