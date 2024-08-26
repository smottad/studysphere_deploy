import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

//para la foto del menu lateral, por ahora es generico
Image getFotoUsuario(double width, double height) {
  return Image(
    image: const AssetImage('lib/Assets/no_user.png'),
    width: width,
    height: height,
  );
}

Future<Image> bajarImagen(
    double width, double height, String? imageName) async {
  try {
    final supabase = Supabase.instance.client;
    Session? sesion = supabase.auth.currentSession;
    if (imageName != null) {
      final Uint8List file =
          await supabase.storage.from('avatars').download(imageName!);
      final Image image = Image.memory(file);

      return Image(
        image: image.image,
        width: width,
        height: height,
      );
    } else {
      return Image.asset('lib/Assets/default_image.png');
    }
  } catch (error) {
    print('Este es el error: $error');
    rethrow;
  }
}

irAsignaturas(BuildContext context) {
  Navigator.pushNamed(context, '/inicio/asignaturas');
}

irProyectos(BuildContext context) {
  Navigator.pushNamed(context, '/inicio/proyectos');
}

irHorario(BuildContext context) {
  Navigator.pushNamed(context, '/inicio/horario');
}

irConfiguracion(BuildContext context) {
  Navigator.pushNamed(context, '/inicio/ajustes');
}

void showAction(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushNamed(context, '/inicio/crear_recordatorio');
      break;
    case 1:
      Navigator.pushNamed(context, '/inicio/mazos');
      //Navigator.pushNamed(context, '/inicio/crear_flashcard');
      break;
    case 2:
      Navigator.pushNamed(context, '/inicio/crear_asignaturas');
      //Navigator.pushNamed(context, '/inicio/crear_asignatura');
      break;
    case 3:
      Navigator.pushNamed(context, '/inicio/crear_proyectos');
      //Navigator.pushNamed(context, '/inicio/crear_proyecto');
      break;
    default:
      throw ('wtf');
  }
}
