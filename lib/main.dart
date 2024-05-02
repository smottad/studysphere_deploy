import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studysphere/Componentes/web_view.dart';
import 'package:studysphere/Vistas/crear_proyecto.dart';
import 'package:studysphere/Vistas/crear_recordatorio.dart';
import 'package:studysphere/Vistas/editar_asignatura.dart';
import 'package:studysphere/Vistas/editar_proyecto.dart';
import 'package:studysphere/Vistas/en_progreso.dart';
import 'package:studysphere/Vistas/horario.dart';
import 'package:studysphere/Vistas/iniciar_sesion.dart';
import 'package:studysphere/Vistas/pagina_inicio.dart';
import 'package:studysphere/Vistas/registro.dart';
import 'package:studysphere/Vistas/crear_asignatura.dart';
import 'package:studysphere/Vistas/ver_asignaturas.dart';
import 'package:studysphere/Vistas/ver_asignaturas_pasadas.dart';
import 'package:studysphere/Vistas/ver_proyectos.dart';
import 'package:studysphere/Vistas/ver_proyectos_pasados.dart';
import 'package:studysphere/color_schemes.g.dart';

Future<void> main() async {
  //PARA TENER ALARMAS
  runApp(const MyApp());
  await Alarm.init();
  //apagar la alarma
  Alarm.ringStream.stream.listen((data) => Alarm.stop(data.id));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        textTheme: GoogleFonts.jostTextTheme(),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
          colorScheme: darkColorScheme,
          textTheme: GoogleFonts.jostTextTheme(),
          useMaterial3: true), //aqui estan todos los colores

      themeMode: ThemeMode.light,
      initialRoute: '/',

      routes: {
        '/': (context) => const IniciarSesion(),
        '/inicio': (context) => const PaginaInicio(),
        '/registro': (context) => const Registro(),
        '/terminos': (context) => const HTMLScreen(),
        '/inicio/crear_asignaturas': (context) => const CrearAsignatura(),
        '/inicio/asignaturas': (context) => const VerAsignaturas(),
        '/inicio/asignaturas_pasadas': (context) => const VerAsignaturasPasadas(),
        '/inicio/editar_asignaturas': (context) => const EditarAsignatura(),
        '/inicio/crear_proyectos': (context) => const CrearProyecto(),
        '/inicio/proyectos': (context) => const VerProyectos(),
        '/inicio/proyectos_pasados': (context) => const VerProyectosPasados(),
        '/inicio/editar_proyectos': (context) => const EditProject(),
        '/inicio/horario': (context) => const Horario(),
        '/inicio/crear_recordatorio': (context) => const CrearRecordatorio(),
      },
    );
  }
}
