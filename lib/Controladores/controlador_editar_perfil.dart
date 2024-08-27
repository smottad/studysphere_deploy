import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Controladores de texto para los campos del perfil
final nombre = TextEditingController();
final correo = TextEditingController();
final telefono = TextEditingController();
final contrasena = TextEditingController();
final verificarContrasena = TextEditingController();

// Función para actualizar el perfil del usuario
Future<void> actualizarPerfil(BuildContext context, nombreO, correoO, telefonoO,
    contrasenaO, verificarContrasenaO) async {
  // Controladores de texto para los campos del perfil
  final nombre = nombreO;
  final correo = correoO;
  final telefono = telefonoO;
  String contrasena = contrasenaO;
  String verificarContrasena = verificarContrasenaO;

  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  try {
    // Actualizar el perfil del usuario en la tabla 'profiles'
    final updates = {
      'nombre': nombre,
      'correo': correo,
      'telefono': int.tryParse(telefono),
      'contraseña': contrasena,
    };

    // Actualizar el email y la contraseña si han cambiado
    try {
      await supabase.auth.updateUser(UserAttributes(email: correo));
      await supabase.from('usuarios').update(updates).eq('id', user!.id);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al actualizar correo: $e'),
            backgroundColor: Colors.red),
      );
    }

    try {
      if (contrasena.isNotEmpty) {
        if (contrasena == verificarContrasena) {
          try {
            await supabase.auth
                .updateUser(UserAttributes(password: contrasena));
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'La contraseña deberia ser distinta de la antigua, se queda igual'),
                  backgroundColor: Colors.red),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Las contraseñas no coinciden'),
                backgroundColor: Colors.red),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Las contraseñas no pueden estar vacias, no se actualizan'),
              backgroundColor: Colors.red),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado con éxito'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Las contraseñas no coinciden:$e'),
            backgroundColor: Colors.red),
      );
    }

    if (context.mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/inicio', ModalRoute.withName('/'));
    }
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Error al actualizar perfil: $e'),
          backgroundColor: Colors.red),
    );
  }
}
