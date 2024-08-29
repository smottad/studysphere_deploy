import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

eliminarRecordatorio(idRecordatorio) async {
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
      .delete()
      .eq('id', int.parse(idRecordatorio));
  print(response);
}

markAsDone(idRecordatorio) async {
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
      .delete()
      .eq('id', int.parse(idRecordatorio));
  print(response);
}

Future<Map<String, List<List<String>>>>
    obtenerNombresReunionesActuales() async {
  final supabase = Supabase.instance.client;
  final Session? session = supabase.auth.currentSession;
  final userId = session?.user.id;
  if (userId == null) {
    throw ArgumentError('El userId no puede ser nulo');
  }
  // Realiza una consulta a la tabla de proyectos para obtener los nombres de los proyectos del usuario
  final response = await supabase
      .from('recordatorios')
      .select('*')
      .eq('usuario', userId as Object)
      .eq('tipo', 'Reunion');

  // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron proyectos para el usuario
  if (response.isEmpty) {
    print('No se encontraron reuniones el usuario con ID: $userId');
    return {};
  }

  // Extrae los nombres de los proyectos de la respuesta y los devuelve como una lista de cadenas
  Map<String, List<List<String>>> nombresReuniones = {};
  for (var row in response) {
    String nombre;
    int id;
    if (row['id_asignatura'] == null) {
      id = row['id_proyecto'];
      var getNombre =
          await supabase.from('proyectos').select('nombre').eq('id', id);
      nombre = getNombre[0]['nombre'] as String;
    } else {
      id = row['id_asignatura'];
      var getNombre =
          await supabase.from('asignaturas').select('nombre').eq('id', id);
      nombre = getNombre[0]['nombre'] as String;
    }

    var arr = [
      row['nombre'].toString(),
      row['hora_inicio'].toString().substring(
          0, row['hora_inicio'].toString().length - 3), //borrar los segundos
      nombre,
      '${row['id']}'
    ];
    final dateFormat = DateFormat('EEEE, MMMM dd');
    final date = DateTime.tryParse(row['fecha']);
    final checkDate = DateTime.tryParse('${row['fecha']} ${row['hora_final']}');
    if (checkDate!.isBefore(DateTime.now())) {
      continue;
    }
    nombresReuniones.update(dateFormat.format(date!), (value) {
      value.add(arr);
      return value;
    }, ifAbsent: () => [arr]);
  }

  return nombresReuniones;
}

Future<Map<String, List<List<String>>>> obtenerNombresExamenesActuales() async {
  final supabase = Supabase.instance.client;
  final Session? session = supabase.auth.currentSession;
  final userId = session?.user.id;
  if (userId == null) {
    throw ArgumentError('El userId no puede ser nulo');
  }
  // Realiza una consulta a la tabla de proyectos para obtener los nombres de los proyectos del usuario
  final response = await supabase
      .from('recordatorios')
      .select('*')
      .eq('usuario', userId as Object)
      .eq('tipo', 'Examen');

  // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron proyectos para el usuario
  if (response.isEmpty) {
    print('No se encontraron exámenes el usuario con ID: $userId');
    return {};
  }

  // Extrae los nombres de los proyectos de la respuesta y los devuelve como una lista de cadenas
  Map<String, List<List<String>>> nombresExamenes = {};
  for (var row in response) {
    String nombre;
    int id;
    if (row['id_asignatura'] == null) {
      id = row['id_proyecto'];
      var getNombre =
          await supabase.from('proyectos').select('nombre').eq('id', id);
      nombre = getNombre[0]['nombre'] as String;
    } else {
      id = row['id_asignatura'];
      var getNombre =
          await supabase.from('asignaturas').select('nombre').eq('id', id);
      nombre = getNombre[0]['nombre'] as String;
    }

    var arr = [
      row['nombre'].toString(),
      row['hora_inicio']
          .toString()
          .substring(0, row['hora_inicio'].toString().length - 3),
      nombre,
      '${row['id']}'
    ];
    final dateFormat = DateFormat('EEEE, MMMM dd');
    final date = DateTime.tryParse(row['fecha']);
    final checkDate = DateTime.tryParse('${row['fecha']} ${row['hora_final']}');
    if (checkDate!.isBefore(DateTime.now())) {
      continue;
    }
    nombresExamenes.update(dateFormat.format(date!), (value) {
      value.add(arr);
      return value;
    }, ifAbsent: () => [arr]);
  }

  return nombresExamenes;
}

Future<Map<String, List<List<String>>>> obtenerNombresTareasActuales() async {
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
    int id;
    if (row['id_asignatura'] == null) {
      id = row['id_proyecto'];
      var getNombre =
          await supabase.from('proyectos').select('nombre').eq('id', id);
      nombre = getNombre[0]['nombre'] as String;
    } else {
      id = row['id_asignatura'];
      var getNombre =
          await supabase.from('asignaturas').select('nombre').eq('id', id);
      nombre = getNombre[0]['nombre'] as String;
    }

    var arr = [
      row['nombre'].toString(),
      row['hora_inicio']
          .toString()
          .substring(0, row['hora_inicio'].toString().length - 3),
      nombre,
      '${row['id']}'
    ];
    final dateFormat = DateFormat('EEEE, MMMM dd');
    final date = DateTime.tryParse(row['fecha']);
    final checkDate = DateTime.tryParse('${row['fecha']} ${row['hora_final']}');
    if (checkDate!.isBefore(DateTime.now())) {
      continue;
    }
    nombresTareas.update(dateFormat.format(date!), (value) {
      value.add(arr);
      return value;
    }, ifAbsent: () => [arr]);
  }

  return nombresTareas;
}

Future<String?> obtenerUrlImagenPerfil() async {
  try {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      return null;
    }

    final response = await supabase
        .from(
            'usuarios') // Nombre de la tabla donde se guardan los datos del usuario
        .select(
            'avatar_url') // Nombre de la columna que contiene la URL de la foto
        .eq('id', userId)
        .single();

    return response['avatar_url'] as String?;
  } on Exception catch (e) {
    print('Error obteniendo la URL de la foto: $e');
  }
  return null;
}
