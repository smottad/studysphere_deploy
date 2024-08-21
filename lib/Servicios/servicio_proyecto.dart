import 'package:studysphere/Controladores/controlador_crear_recordatorio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServicioRegistroProyectoBaseDatos {
  // final supabase = SupabaseClient('https://yvesvjnkzjfsesaxbtys.supabase.co',
  //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl2ZXN2am5rempmc2VzYXhidHlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MzQ0NDAsImV4cCI6MjAyOTQxMDQ0MH0.AuGmOiya2KUjrAbJgTZ9DMyvePSskgauatcduWl8IAk');

  Future<void> guardarProyectoEnSupabase(
    String nombreProyecto,
    DateTime fechaInicio,
    DateTime fechaFinal,
    int idAsignatura,
  ) async {
    try {
      final supabase = Supabase.instance.client;

      final Session? session = supabase.auth.currentSession;
      print(session?.user.id.toString());
      print(session?.user.email);

      // Intenta insertar el nuevo proyecto en la tabla Proyectos
      final response = await supabase.from('proyectos').insert({
        'nombre': nombreProyecto,
        'fecha_inicio': fechaInicio.toIso8601String(),
        'fecha_final': fechaFinal.toIso8601String(),
        'id_asignatura': idAsignatura,
        'id_usuario': session?.user.id,
      });
    } catch (e) {
      // Manejo de cualquier excepción ocurrida durante el proceso
      print('Error al guardar el proyecto en Supabase: $e');
    }
  }

  Future<List<String>> obtenerNombresProyectosPorUsuario(context) async {
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
        .select('nombre, fecha_final')
        .eq('id_usuario', userId as Object);

    print(response);
    // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron proyectos para el usuario
    if (response.isEmpty) {
      print('No se encontraron proyectos para el usuario con ID: $userId');
      return [];
    }

    // Filtra los proyectos que aún no han finalizado
    final now = DateTime.now();
    List<String> nombresProyectosActivos = [];
    for (var row in response) {
      final fechaFinal = DateTime.parse(row['fecha_final']);

      // Solo agregar los proyectos cuya fecha final es posterior a la fecha actual
      if (fechaFinal.isAfter(now)) {
        nombresProyectosActivos.add(row['nombre'] as String);
      }
    }

    print(nombresProyectosActivos);
    return nombresProyectosActivos;
  }

  Future<List<String>> obtenerNombresProyectosPorUsuarioAntiguos(
      context) async {
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
        .select('nombre, fecha_final')
        .eq('id_usuario', userId as Object);

    print(response);
    // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron proyectos para el usuario
    if (response.isEmpty) {
      print('No se encontraron proyectos para el usuario con ID: $userId');
      return [];
    }

    // Filtra los proyectos que aún no han finalizado
    final now = DateTime.now();
    List<String> nombresProyectosActivos = [];
    for (var row in response) {
      final fechaFinal = DateTime.parse(row['fecha_final']);

      // Solo agregar los proyectos cuya fecha final es posterior a la fecha actual
      if (fechaFinal.isBefore(now)) {
        nombresProyectosActivos.add(row['nombre'] as String);
      }
    }

    print(nombresProyectosActivos);
    return nombresProyectosActivos;
  }

  Future<Map<String, int>> obtenerAsignaturasPorUsuario() async {
    try {
      final supabase = Supabase.instance.client;
      final Session? session = supabase.auth.currentSession;
      final userId = session?.user.id;
      print(userId);
      if (userId == null) {
        throw ArgumentError('El userId no puede ser nulo');
      }

      // Realiza una consulta a la tabla de asignaturas para obtener los nombres y IDs de las asignaturas del usuario
      final response = await supabase
          .from('asignaturas')
          .select('nombre, id')
          .eq('id_usuario', userId as Object);

      print(response);
      // Verifica si la respuesta está vacía, lo que indicaría que no se encontraron asignaturas para el usuario
      if (response.isEmpty) {
        print('No se encontraron asignaturas para el usuario con ID: $userId');
        return {};
      }

      // Extrae los nombres y IDs de las asignaturas de la respuesta y los devuelve como un mapa
      Map<String, int> asignaturas = {};
      for (var row in response) {
        asignaturas[row['nombre'] as String] = row['id'] as int;
      }
      print(asignaturas);

      return asignaturas;
    } catch (error) {
      // Manejar cualquier error que pueda ocurrir durante la obtención de las asignaturas
      print('Error en obtenerAsignaturasPorUsuario: $error');
      rethrow; // Relanzar el error para que el widget pueda manejarlo
    }
  }
}

Future<void> deleteProyecto(String nombreProyecto) async {
  final SupabaseClient supabase = Supabase.instance.client;
  final Session? session = supabase.auth.currentSession;

  // Verifica si hay una sesión activa y obtiene el ID del usuario
  final userId = session?.user.id;
  if (userId == null) {
    throw Exception('No hay usuario autenticado');
  }

  try {
    await supabase.from('proyectos').delete().eq('nombre', nombreProyecto).eq(
        'id_usuario',
        userId); // Asegura que el proyecto pertenece al usuario autenticado
  } catch (e) {
    print('Error al eliminar el proyecto: $e');
    rethrow;
  }
}
