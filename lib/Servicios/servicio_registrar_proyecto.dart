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
      print(session?.user?.id.toString());
      print(session?.user?.email);

      // Intenta insertar el nuevo proyecto en la tabla Proyectos
      final response = await supabase.from('proyectos').insert({
        'nombre': nombreProyecto,
        'fecha_inicio': fechaInicio.toIso8601String(),
        'fecha_final': fechaFinal.toIso8601String(),
        'id_asignatura': idAsignatura,
        'id_usuario': session?.user?.id,
      });

      // Verifica si la inserción fue exitosa
      if (response != null) {
        // Verifica si la inserción fue exitosa
        if (response.error != null) {
          // Maneja el error si la inserción falla
          print('Error al guardar el proyecto: ${response.error!.message}');
        } else {
          // Maneja la inserción exitosa
          print('Proyecto guardado exitosamente en Supabase.');
        }
      } else {
        // Maneja el caso en el que la respuesta es null
        print('La respuesta de Supabase es nula.');
      }
    } catch (e) {
      // Manejo de cualquier excepción ocurrida durante el proceso
      print('Error al guardar el proyecto en Supabase: $e');
    }
  }
}
