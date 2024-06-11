// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServicioRegistroRecordatorios {
  final supabase = Supabase.instance.client;
  int pruebaasignatura = 1;

  Future<String> registrarRecordatorio(
    String nombre,
    String asignatura,
    String tipo,
    DateTime fecha,
    TimeOfDay horaInicio,
    TimeOfDay horaFinal,
    int prioridad,
    String temas,
    bool alarma,
    BuildContext context,
  ) async {
    try {
      // Convierte TimeOfDay a String en formato HH:mm:ss
      final String horaInicioStr = horaInicio.format(context);
      final String horaFinStr = horaFinal.format(context);

      // Inserta el nuevo recordatorio en la tabla Recordatorios
      final Session? session = supabase.auth.currentSession;
      final response = await supabase.from('recordatorios').insert({
        'nombre': nombre,
        'usuario': session?.user.id,
        'asignatura': pruebaasignatura,
        'tipo': tipo,
        'fecha': fecha.toIso8601String(),
        'hora_inicio': horaInicioStr,
        'hora_final': horaFinStr,
        'prioridad': prioridad,
        'temas': temas,
        'alarma': alarma
      });

      // Verifica si la inserción fue exitosa
      if (response.error != null) {
        // Maneja el error si la inserción falla
        print('Error al guardar el recordatorio: ${response.error!.message}');
        return 'Error al guardar el recordatorio';
      } else {
        // Maneja la inserción exitosa
        print('Recordatorio guardado exitosamente en Supabase.');
        return 'Recordatorio guardado correctamente';
      }
    } catch (error) {
      // Maneja cualquier error que pueda ocurrir durante el proceso de inserción
      print('Error al guardar el recordatorio: $error');
      return 'Error al guardar el recordatorio';
    }
  }

  Future<List<String>> obtenerNombresProyectosPorUsuario() async {
    // try {
    final supabase = Supabase.instance.client;
    final Session? session = supabase.auth.currentSession;
    final userId = session?.user.id;
    print(userId);
    if (userId == null) {
      throw ArgumentError('El userId no puede ser nulo');
    }
    // Realiza una consulta a la tabla de proyectos para obtener los nombres de los proyectos del usuario
    final response = await supabase
        .from('proyectos')
        .select('nombre')
        .eq('id_usuario', userId as Object);

    print(response);
    // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron proyectos para el usuario
    if (response.isEmpty) {
      print('No se encontraron proyectos para el usuario con ID: $userId');
      return [];
    }

    // Extrae los nombres de los proyectos de la respuesta y los devuelve como una lista de cadenas
    List<String> nombresProyectos = [];
    for (var row in response) {
      nombresProyectos.add(row['nombre'] as String);
    }
    print(nombresProyectos);

    return nombresProyectos;
    // } catch (error) {
    //   // Manejar cualquier error que pueda ocurrir durante la obtención de los nombres de los proyectos
    //   print('Error en obtenerNombresProyectosPorUsuario: $error');
    //   rethrow; // relanzar el error para que el widget pueda manejarlo
    // }
  }

  Future<List<String>> obtenerNombresAsignaturasPorUsuario() async {
    // try {
    final supabase = Supabase.instance.client;
    final Session? session = supabase.auth.currentSession;
    final userId = session?.user.id;
    print(userId);
    if (userId == null) {
      throw ArgumentError('El userId no puede ser nulo');
    }
    // Realiza una consulta a la tabla de proyectos para obtener los nombres de los proyectos del usuario
    final response = await supabase
        .from('asignaturas')
        .select('nombre')
        .eq('id_usuario', userId as Object);

    print(response);
    // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron proyectos para el usuario
    if (response.isEmpty) {
      print('No se encontraron proyectos para el usuario con ID: $userId');
      return [];
    }

    // Extrae los nombres de los proyectos de la respuesta y los devuelve como una lista de cadenas
    List<String> nombresProyectos = [];
    for (var row in response) {
      nombresProyectos.add(row['nombre'] as String);
    }
    print(nombresProyectos);

    return nombresProyectos;
    // } catch (error) {
    //   // Manejar cualquier error que pueda ocurrir durante la obtención de los nombres de los proyectos
    //   print('Error en obtenerNombresProyectosPorUsuario: $error');
    //   rethrow; // relanzar el error para que el widget pueda manejarlo
    // }
  }
}

Future<Map<String, List<List<String>>>> obtenerNombresTareas() async {
  final supabase = Supabase.instance.client;
  final Session? session = supabase.auth.currentSession;
  final userId = session?.user.id;
  print(userId);
  if (userId == null) {
    throw ArgumentError('El userId no puede ser nulo');
  }
  // Realiza una consulta a la tabla de proyectos para obtener los nombres de los proyectos del usuario
  final response = await supabase
      .from('recordatorios')
      .select('nombre')
      .eq('usuario', userId as Object)
      .eq('tipo', 'Tarea');

  print(response);
  // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron proyectos para el usuario
  if (response.isEmpty) {
    print('No se encontraron proyectos para el usuario con ID: $userId');
    return {};
  }

  // Extrae los nombres de los proyectos de la respuesta y los devuelve como una lista de cadenas
  Map<String, List<List<String>>> nombresTareas = {};
  for (var row in response) {
    nombresTareas.update(row['fecha'] as String, (value) {
      value.add([
        row['nombre'] as String,
        row['hora_inicio'] as String,
        row['asignatura'] as String
      ]);
      return value;
    },
        ifAbsent: () => [
              [
                row['nombre'] as String,
                row['hora_inicio'] as String,
                row['asignatura'] as String
              ]
            ]);
  }
  print(nombresTareas);

  return nombresTareas;
}

Future<Map<String, List<List<String>>>> obtenerNombresExamenes() async {
  final supabase = Supabase.instance.client;
  final Session? session = supabase.auth.currentSession;
  final userId = session?.user.id;
  print(userId);
  if (userId == null) {
    throw ArgumentError('El userId no puede ser nulo');
  }
  // Realiza una consulta a la tabla de proyectos para obtener los nombres de los proyectos del usuario
  final response = await supabase
      .from('recordatorios')
      .select('nombre')
      .eq('usuario', userId as Object)
      .eq('tipo', 'Examen');

  print(response);
  // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron proyectos para el usuario
  if (response.isEmpty) {
    print('No se encontraron proyectos para el usuario con ID: $userId');
    return {};
  }

  // Extrae los nombres de los proyectos de la respuesta y los devuelve como una lista de cadenas
  Map<String, List<List<String>>> nombresExamenes = {};
  for (var row in response) {
    nombresExamenes.update(row['fecha'] as String, (value) {
      value.add([
        row['nombre'] as String,
        row['hora_inicio'] as String,
        row['asignatura'] as String
      ]);
      return value;
    },
        ifAbsent: () => [
              [
                row['nombre'] as String,
                row['hora_inicio'] as String,
                row['asignatura'] as String
              ]
            ]);
  }
  print(nombresExamenes);

  return nombresExamenes;
}

Future<Map<String, List<List<String>>>> obtenerNombresReuniones() async {
  final supabase = Supabase.instance.client;
  final Session? session = supabase.auth.currentSession;
  final userId = session?.user.id;
  print(userId);
  if (userId == null) {
    throw ArgumentError('El userId no puede ser nulo');
  }
  // Realiza una consulta a la tabla de proyectos para obtener los nombres de los proyectos del usuario
  final response = await supabase
      .from('recordatorios')
      .select('nombre')
      .eq('usuario', userId as Object)
      .eq('tipo', 'Reunion');

  print(response);
  // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron proyectos para el usuario
  if (response.isEmpty) {
    print('No se encontraron proyectos para el usuario con ID: $userId');
    return {};
  }

  // Extrae los nombres de los proyectos de la respuesta y los devuelve como una lista de cadenas
  Map<String, List<List<String>>> nombresReuniones = {};
  for (var row in response) {
    nombresReuniones.update(row['fecha'] as String, (value) {
      value.add([
        row['nombre'] as String,
        row['hora_inicio'] as String,
        row['asignatura'] as String
      ]);
      return value;
    },
        ifAbsent: () => [
              [
                row['nombre'] as String,
                row['hora_inicio'] as String,
                row['asignatura'] as String
              ]
            ]);
  }
  print(nombresReuniones);

  return nombresReuniones;
  // } catch (error) {
}
