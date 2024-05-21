import 'package:supabase_flutter/supabase_flutter.dart';

class ServicioRegistroBaseDatos {
  Future<bool> registrarUsuario(String nombre, String correo, String contrasena,
      String edad, String telefono) async {
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

      final String userId = res.user!.id;
      // Inserta los datos del usuario en la tabla Usuarios
      final response = await supabase.from('usuarios').insert({
        'id': userId,
        'nombre': nombre,
        'correo': correo,
        'edad': int.tryParse(edad),
        'telefono': int.tryParse(telefono),
        'contraseña': contrasena,
        'tipo_cuenta':
            1, // Aquí puedes definir el tipo de cuenta según tus requerimientos
      });

      return true;
    } catch (error) {
      // Manejar cualquier error que pueda ocurrir durante el proceso de registro
      print('Error al registrar el usuario dentro del servicio: $error');
      return false;
    }
  }
}

class ServicioRegistroBaseDatoss {
  Future<String> registrarUsuario(String nombre, String correo,
      String contrasena, String edad, String telefono) async {
    try {
      // Get a reference to your Supabase client
      final supabase = Supabase.instance.client;

      // Registra al usuario en Supabase Auth
      final AuthResponse res = await supabase.auth.signUp(
        email: correo,
        password: contrasena,
      );

      // Si el registro en Auth es exitoso
      // Obtiene el ID del usuario registrado
      final String userId = res.user!.id;

      // Inserta los datos del usuario en la tabla Usuarios
      final response = await supabase.from('Usuarios').insert({
        'id': userId,
        'nombre': nombre,
        'correo': correo,
        'edad': int.tryParse(edad),
        'telefono': int.tryParse(telefono),
        'contraseña': contrasena,
        'tipo_cuenta':
            1, // Aquí puedes definir el tipo de cuenta según tus requerimientos
      });

      // Verifica si la inserción en la tabla Usuarios fue exitosa
      if (response.error != null) {
        // Maneja el error si la inserción falla
        print(
            'Error al insertar el usuario en la tabla Usuarios: ${response.error!.message}');
        return 'Error al registrar el usuario';
      } else {
        // Si la inserción en la tabla Usuarios fue exitosa
        return "Usuario registrado correctamente";
      }
    } catch (error) {
      // Manejar cualquier otro error que pueda ocurrir durante el proceso de registro
      print('Error al registrar el usuario dentro del servicio: $error');
      return 'Error al registrar el usuario';
    }
  }
}
