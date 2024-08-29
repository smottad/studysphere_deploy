import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/cards.dart';
import 'package:studysphere/Componentes/menu_expandible.dart';
import 'package:studysphere/Controladores/controlador_pagina_inicio.dart';
import 'package:studysphere/Servicios/servicio_pagina_inicio.dart';

class PaginaInicio extends StatefulWidget {
  static const _actionTitles = [
    'Crear recordatorio',
    'Crear flashcard',
    'Añadir asignatura',
    'Añadir proyecto',
  ];
  const PaginaInicio({super.key});

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  refresh() {
    setState(() {
      builderExamenes();
      builderReuniones();
      builderTareas();
    });
  }

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
                  onPressed: () {
                    Navigator.pushNamed(context, '/inicio/crear_recordatorio')
                        .then(
                      (value) => refresh(),
                    );
                  },
                  icon: Icon(Icons.alarm, color: colorScheme.onSecondary)),
              Text(PaginaInicio._actionTitles[0])
            ]),
            Column(children: [
              ActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/inicio/mazos').then(
                    (value) => refresh(),
                  );
                },
                icon: Icon(
                  Icons.bookmark,
                  color: colorScheme.onSecondary,
                ),
              ),
              Text(PaginaInicio._actionTitles[1])
            ]),
            Column(children: [
              ActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/inicio/crear_asignaturas')
                      .then(
                    (value) => refresh(),
                  );
                },
                icon: Icon(
                  Icons.book,
                  color: colorScheme.onSecondary,
                ),
              ),
              Text(PaginaInicio._actionTitles[2])
            ]),
            Column(children: [
              ActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/inicio/crear_proyectos').then(
                    (value) => refresh(),
                  );
                },
                icon: Icon(
                  Icons.timeline,
                  color: colorScheme.onSecondary,
                ),
              ),
              Text(PaginaInicio._actionTitles[3])
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
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox.expand(
                  child: SingleChildScrollView(
                    child: builderTareas(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox.expand(
                  child: SingleChildScrollView(
                    child: builderExamenes(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox.expand(
                  child: SingleChildScrollView(
                    child: builderReuniones(),
                  ),
                ),
              ),
            ],
            //children: [FutureBuilder(future: getAsignaturas(), builder: )],
          ),
        ));
  }

  FutureBuilder<Card> builderReuniones() {
    return FutureBuilder(
        future: paginaInicioReuniones(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const CircularProgressIndicator();
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  FutureBuilder<Card> builderExamenes() {
    return FutureBuilder(
        future: paginaInicioExamenes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  FutureBuilder<Card> builderTareas() {
    return FutureBuilder(
        future: paginaInicioTareas(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Padding fotoYConfiguracion(
    Size size,
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          getFotoUsuario((size.height * 0.1).clamp(10, 50),
              (size.height * 0.1).clamp(10, 50)),
          const Spacer(),
          InkWell(
            onTap: () {
              irConfiguracion(context);
              refresh();
            },
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

  Future<Card> paginaInicioTareas() async {
    return Card(
      //color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Column(
        children: [
          const Text(
            "Próximas tareas",
            style: TextStyle(fontSize: 30),
          ),
          FutureBuilder(
              future: obtenerNombresTareasActuales(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final count = snapshot.data?.length;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: count,
                      itemBuilder: (context, index) {
                        String key = snapshot.data!.keys.elementAt(index);
                        List<List<String>>? data = snapshot.data![key];
                        List<Row> rows = [];
                        for (var item in data!) {
                          String body = "";
                          for (var i = 0; i < 3; i++) {
                            body += "${item[i].trim()}, ";
                          }
                          rows.add(Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${body.substring(0, body.length - 2)}.'),
                              const Spacer(),
                              IconButton(
                                  color: Theme.of(context).colorScheme.primary,
                                  hoverColor:
                                      Theme.of(context).colorScheme.secondary,
                                  tooltip: 'Marcar como hecha',
                                  onPressed: () async {
                                    await markAsDone(item[3]);
                                    refresh();
                                  },
                                  icon: const Icon(Icons.check_circle)),
                              IconButton(
                                  color: Theme.of(context).colorScheme.primary,
                                  hoverColor:
                                      Theme.of(context).colorScheme.secondary,
                                  tooltip: 'Eliminar',
                                  onPressed: () async {
                                    await eliminarRecordatorio(item[3]);
                                    refresh();
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          ));
                        }

                        return Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '⚫ $key:',
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          ListBody(
                            children: rows,
                          )
                        ]);
                      });
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }

  Future<Card> paginaInicioExamenes() async {
    return Card(
      //color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Column(
        children: [
          const Text(
            "Próximos Examenes",
            style: TextStyle(fontSize: 30),
          ),
          FutureBuilder(
              future: obtenerNombresExamenesActuales(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final count = snapshot.data?.length;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: count,
                      itemBuilder: (context, index) {
                        String key = snapshot.data!.keys.elementAt(index);
                        List<List<String>>? data = snapshot.data![key];
                        List<Row> rows = [];
                        for (var item in data!) {
                          String body = "";
                          for (var i = 0; i < 3; i++) {
                            body += "${item[i].trim()}, ";
                          }
                          rows.add(Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${body.substring(0, body.length - 2)}.'),
                              const Spacer(),
                              IconButton(
                                  color: Theme.of(context).colorScheme.primary,
                                  hoverColor:
                                      Theme.of(context).colorScheme.secondary,
                                  tooltip: 'Estudiar',
                                  // TODO:
                                  onPressed: () {},
                                  icon: const Icon(Icons.book)),
                              IconButton(
                                  color: Theme.of(context).colorScheme.primary,
                                  hoverColor:
                                      Theme.of(context).colorScheme.secondary,
                                  tooltip: 'Eliminar',
                                  onPressed: () async {
                                    await eliminarRecordatorio(item[3]);
                                    refresh();
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          ));
                        }

                        return Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '⚫ $key:',
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          ListBody(
                            children: rows,
                          )
                        ]);
                      });
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }

  Future<Card> paginaInicioReuniones() async {
    return Card(
      //color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Column(
        children: [
          const Text(
            "Próximas Reuniones",
            style: TextStyle(fontSize: 30),
          ),
          FutureBuilder(
              future: obtenerNombresReunionesActuales(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final count = snapshot.data?.length;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: count,
                      itemBuilder: (context, index) {
                        String key = snapshot.data!.keys.elementAt(index);
                        List<List<String>>? data = snapshot.data![key];
                        List<Row> rows = [];
                        for (var item in data!) {
                          String body = "";
                          for (var i = 0; i < 3; i++) {
                            body += "${item[i].trim()}, ";
                          }
                          rows.add(Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${body.substring(0, body.length - 2)}.'),
                              const Spacer(),
                              IconButton(
                                  color: Theme.of(context).colorScheme.primary,
                                  hoverColor:
                                      Theme.of(context).colorScheme.secondary,
                                  tooltip: 'Eliminar',
                                  onPressed: () async {
                                    await eliminarRecordatorio(item[3]);
                                    refresh();
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          ));
                        }

                        return Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '⚫ $key:',
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          ListBody(
                            children: rows,
                          )
                        ]);
                      });
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }
}

// Método para mostrar la foto del usuario
Widget getFotoUsuario(double width, double height) {
  return FutureBuilder<String?>(
    future: obtenerUrlImagenPerfil(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      final imageName = snapshot.data;
      print('Imagen: $imageName');
      if (imageName == null || imageName.isEmpty) {
        print('No hay enlace de imagen');
        return Image.asset(
          'lib/Assets/no_user.png',
          width: width,
          height: height,
        );
      }

      return FutureBuilder<Image>(
        future: bajarImagen(width, height, imageName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error al bajar la imagen: ${snapshot.error}');
            return Image.asset(
              'lib/Assets/no_user.png',
              width: width,
              height: height,
            );
          }

          if (snapshot.hasData) {
            return snapshot.data!;
          }

          // Imagen por defecto en caso de cualquier problema
          return Image.asset(
            'lib/Assets/no_user.png',
            width: width,
            height: height,
          );
        },
      );
    },
  );
}
