// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class ServicioRegistroRecordatorios {
  final supabase = Supabase.instance.client;
  int pruebaasignatura = 1;

  Future<bool> registrarRecordatorio(
    String nombre,
    String id,
    String tipoDato,
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

      print(id);

      // Inserta el nuevo recordatorio en la tabla Recordatorios
      final Session? session = supabase.auth.currentSession;
      var response;

      if (tipoDato == '0') {
        response = await supabase.from('recordatorios').insert({
          'nombre': nombre,
          'usuario': session?.user.id,
          'id_proyecto': int.parse(id),
          'tipo': tipo,
          'fecha': fecha.toIso8601String(),
          'hora_inicio': horaInicioStr,
          'hora_final': horaFinStr,
          'prioridad': prioridad,
          'temas': temas,
          'alarma': alarma
        });
      } else {
        response = await supabase.from('recordatorios').insert({
          'nombre': nombre,
          'usuario': session?.user.id,
          'id_asignatura': int.parse(id),
          'tipo': tipo,
          'fecha': fecha.toIso8601String(),
          'hora_inicio': horaInicioStr,
          'hora_final': horaFinStr,
          'prioridad': prioridad,
          'temas': temas,
          'alarma': alarma
        });
      }
      print("retorna true");
      return true;
    } catch (error) {
      // Maneja cualquier error que pueda ocurrir durante el proceso de inserción
      print('Error al guardar el recordatorio: $error');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> obtenerProyectosPorUsuario() async {
    try {
      final supabase = Supabase.instance.client;
      final Session? session = supabase.auth.currentSession;
      final userId = session?.user.id;
      print(userId);
      if (userId == null) {
        throw ArgumentError('El userId no puede ser nulo');
      }

      final response = await supabase
          .from('proyectos')
          .select('id, nombre')
          .eq('id_usuario', userId as Object);

      print(response);
      if (response.isEmpty) {
        print('No se encontraron proyectos para el usuario con ID: $userId');
        return [];
      }

      List<Map<String, dynamic>> proyectos = [];
      for (var row in response) {
        final id = row['id'];
        final nombre = row['nombre'];
        if (id != null && nombre != null) {
          proyectos.add({
            'id': row['id'].toString(),
            'nombre': nombre as String,
          });
        } else {
          print('Datos incompletos: $row');
        }
      }
      return proyectos;
    } catch (error) {
      print('Error en obtenerProyectosPorUsuario: $error');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> obtenerAsignaturasPorUsuario() async {
    try {
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
          .select('nombre, id')
          .eq('id_usuario', userId as Object);

      print(response);
      // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron proyectos para el usuario
      if (response.isEmpty) {
        print('No se encontraron asignaturas para el usuario con ID: $userId');
        return [];
      }

      // Extrae los nombres y IDs de las asignaturas de la respuesta y los devuelve como una lista de mapas
      List<Map<String, dynamic>> asignaturas = [];
      for (var row in response) {
        asignaturas.add({
          'id': row['id'].toString(),
          'nombre': row['nombre'] as String,
        });
      }
      print(asignaturas);

      return asignaturas;
    } catch (error) {
      // Manejar cualquier error que pueda ocurrir durante la obtención de los nombres de los proyectos
      print('Error en obtenerAsignaturasPorUsuario: $error');
      rethrow; // relanzar el error para que el widget pueda manejarlo
    }
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
      .select('*')
      .eq('usuario', userId as Object)
      .eq('tipo', 'Tarea');

  print(response);
  // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron proyectos para el usuario
  if (response.isEmpty) {
    print('No se encontraron tareas el usuario con ID: $userId');
    return {};
  }

  // Extrae los nombres de los proyectos de la respuesta y los devuelve como una lista de cadenas
  Map<String, List<List<String>>> nombresTareas = {};
  for (var row in response) {
    String nombre;
    if (row['id_asignatura'] == null) {
      var id = row['id_proyecto'];
      var getNombre =
          await supabase.from('proyectos').select('nombre').eq('id', id);
      nombre = getNombre[0]['nombre'] as String;
    } else {
      var id = row['id_asignatura'];
      var getNombre =
          await supabase.from('asignaturas').select('nombre').eq('id', id);
      nombre = getNombre[0]['nombre'] as String;
    }
    var arr = [row['nombre'].toString(), row['hora_inicio'].toString(), nombre];
    final dateFormat = DateFormat('EEEE, MMMM dd');
    final date = DateTime.tryParse(row['fecha']);
    nombresTareas.update(dateFormat.format(date!), (value) {
      value.add(arr);
      return value;
    }, ifAbsent: () => [arr]);
  }
  print("resultado");
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
      .select('*')
      .eq('usuario', userId as Object)
      .eq('tipo', 'Examen');

  print(response);
  // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron proyectos para el usuario
  if (response.isEmpty) {
    print('No se encontraron exámenes el usuario con ID: $userId');
    return {};
  }

  // Extrae los nombres de los proyectos de la respuesta y los devuelve como una lista de cadenas
  Map<String, List<List<String>>> nombresExamenes = {};
  for (var row in response) {
    String nombre;
    if (row['id_asignatura'] == null) {
      var id = row['id_proyecto'];
      var getNombre =
          await supabase.from('proyectos').select('nombre').eq('id', id);
      nombre = getNombre[0]['nombre'] as String;
    } else {
      var id = row['id_asignatura'];
      var getNombre =
          await supabase.from('asignaturas').select('nombre').eq('id', id);
      nombre = getNombre[0]['nombre'] as String;
    }
    var arr = [row['nombre'].toString(), row['hora_inicio'].toString(), nombre];
    final dateFormat = DateFormat('EEEE, MMMM dd');
    final date = DateTime.tryParse(row['fecha']);
    nombresExamenes.update(dateFormat.format(date!), (value) {
      value.add(arr);
      return value;
    }, ifAbsent: () => [arr]);
  }
  print("resultado");
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
      .select('*')
      .eq('usuario', userId as Object)
      .eq('tipo', 'Reunion');

  print(response);
  // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron proyectos para el usuario
  if (response.isEmpty) {
    print('No se encontraron reuniones el usuario con ID: $userId');
    return {};
  }

  // Extrae los nombres de los proyectos de la respuesta y los devuelve como una lista de cadenas
  Map<String, List<List<String>>> nombresReuniones = {};
  for (var row in response) {
    String nombre;
    if (row['id_asignatura'] == null) {
      var id = row['id_proyecto'];
      var getNombre =
          await supabase.from('proyectos').select('nombre').eq('id', id);
      nombre = getNombre[0]['nombre'] as String;
    } else {
      var id = row['id_asignatura'];
      var getNombre =
          await supabase.from('asignaturas').select('nombre').eq('id', id);
      nombre = getNombre[0]['nombre'] as String;
    }
    var arr = [row['nombre'].toString(), row['hora_inicio'].toString(), nombre];
    final dateFormat = DateFormat('EEEE, MMMM dd');
    final date = DateTime.tryParse(row['fecha']);
    nombresReuniones.update(dateFormat.format(date!), (value) {
      value.add(arr);
      return value;
    }, ifAbsent: () => [arr]);
  }
  print("resultado");
  print(nombresReuniones);

  return nombresReuniones;
}
