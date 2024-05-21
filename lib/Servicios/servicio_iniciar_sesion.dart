import 'package:supabase_flutter/supabase_flutter.dart';

class ServicioBaseDatosInicioSesion {
  Future<bool> iniciarSesion(String correo, String contrasena) async {
    try {
      final supabase = Supabase.instance.client;

      // Iniciar sesión con correo y contraseña
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: correo,
        password: contrasena,
      );
      // Verificar si la sesión se inició correctamente
      return true;
    } catch (error) {
      // Manejar cualquier otro error que pueda ocurrir durante el proceso de inicio de sesión
      print('Error al iniciar sesión: $error');
      return false;
    }
  }
}
