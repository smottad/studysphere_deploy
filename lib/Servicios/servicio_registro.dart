import 'package:supabase_flutter/supabase_flutter.dart';

class ServicioRegistroBaseDatos {
  Future<String> registrarUsuario(String nombre, String correo,
      String contrasena, String edad, String telefono) async {
    try {
      // Get a reference to your Supabase client
      final supabase = Supabase.instance.client;

      final AuthResponse res = await supabase.auth.signUp(
        email: correo,
        password: contrasena,
        // data: {'nombre': nombre, 'edad': edad, 'telefono': telefono}
      );
      final Session? session = res.session;
      final User? user = res.user;
      return "Usuario registrado correctamente";
    } catch (error) {
      // Manejar cualquier error que pueda ocurrir durante el proceso de registro
      print('Error al registrar el usuario dentro del servicio: $error');
      return 'Error al registrar el usuario';
    }
  }
}
