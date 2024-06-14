import 'package:supabase_flutter/supabase_flutter.dart';

eliminarRecordatorio(id_recordatorio) async {
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
      .eq('id', int.parse(id_recordatorio));
  print(response);
}

markAsDone(id_recordatorio) {}
