import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studysphere/Componentes/web_view.dart';
import 'package:studysphere/Controladores/controlador_editar_mazo.dart';
import 'package:studysphere/Vistas/ajustes.dart';
import 'package:studysphere/Vistas/crear_mazo.dart';
import 'package:studysphere/Vistas/crear_proyecto.dart';
import 'package:studysphere/Vistas/crear_recordatorio.dart';
import 'package:studysphere/Vistas/editar_asignatura.dart';
import 'package:studysphere/Vistas/editar_mazo.dart';
import 'package:studysphere/Vistas/editar_perfil.dart';
import 'package:studysphere/Vistas/editar_proyecto.dart';
import 'package:studysphere/Vistas/enviar_correo_nueva_contrasena.dart';
import 'package:studysphere/Vistas/horario.dart';
import 'package:studysphere/Vistas/ingreso_codigo.dart';
import 'package:studysphere/Vistas/iniciar_sesion.dart';
import 'package:studysphere/Vistas/nueva_contrasena.dart';
import 'package:studysphere/Vistas/pagina_inicio.dart';
import 'package:studysphere/Vistas/registro.dart';
import 'package:studysphere/Vistas/crear_asignatura.dart';
import 'package:studysphere/Vistas/ver_asignaturas.dart';
import 'package:studysphere/Vistas/ver_asignaturas_pasadas.dart';
import 'package:studysphere/Vistas/ver_proyectos.dart';
import 'package:studysphere/Vistas/ver_proyectos_pasados.dart';
import 'package:studysphere/Vistas/mazos.dart';
import 'package:studysphere/color_schemes.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Holas1");
  await Supabase.initialize(
    url: 'https://yvesvjnkzjfsesaxbtys.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl2ZXN2am5rempmc2VzYXhidHlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MzQ0NDAsImV4cCI6MjAyOTQxMDQ0MH0.AuGmOiya2KUjrAbJgTZ9DMyvePSskgauatcduWl8IAk',
  );
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
      onGenerateRoute: (settings) {
        if(settings.name == EditarMazo.routeName) {
          final args = settings.arguments as EditMazeArguments;

          return MaterialPageRoute(
            builder: (context) {
              return EditarMazo(
                idMaze: args.idMaze, 
                nameMaze: args.nameMaze, 
                subjectMaze: args.subjectMaze);
            }
          );
        }
      },
      routes: {
        '/': (context) => const IniciarSesion(),
        '/inicio': (context) => const PaginaInicio(),
        '/registro': (context) => const Registro(),
        '/correo_recuperar_contrasena': (context) => const CorreoNuevaContrasena(),
        '/correo_ingresar_codigo': (context) => const IngresoCodigoVerificacion(),
        '/nueva_contrasena': (context) => const NuevaContrasena(),
        '/terminos': (context) => const HTMLScreen(),
        '/inicio/crear_asignaturas': (context) => const CrearAsignatura(),
        '/inicio/asignaturas': (context) => const VerAsignaturas(),
        '/inicio/asignaturas_pasadas': (context) =>
            const VerAsignaturasPasadas(),
        '/inicio/editar_asignaturas': (context) => const EditarAsignatura(),
        '/inicio/crear_proyectos': (context) => const CrearProyecto(),
        '/inicio/proyectos': (context) => const VerProyectos(),
        '/inicio/proyectos_pasados': (context) => const VerProyectosPasados(),
        '/inicio/editar_proyectos': (context) => const EditProject(),
        '/inicio/horario': (context) => const Horario(),
        '/inicio/crear_recordatorio': (context) => const CrearRecordatorio(),
        '/inicio/ajustes': (context) => const Ajustes(),
        '/inicio/ajustes/editar_perfil': (context) => const EditProfile(),
        '/inicio/mazos': (context) => const VerMazos(),
        '/inicio/mazos/crear_mazo': (context) => const CrearMazo(),
      },
    );
  }
}
