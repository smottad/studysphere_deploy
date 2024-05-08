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
}
