import 'package:supabase_flutter/supabase_flutter.dart';

class Mazo {
  Mazo({this.id, required this.nombreMazo, required this.asignaturaMazo});

  int? id;
  String nombreMazo;
  int asignaturaMazo;
}

class ServicioBaseDatosMazo {
  final supabase = Supabase.instance.client;

  Future<void> guardarMazo(Mazo mazo) async {
    try{
      Session? sesion = supabase.auth.currentSession;

      await supabase
        .from("mazos")
        .insert({
          "nombre": mazo.nombreMazo,
          "id_usuario": sesion?.user.id,
          "id_asignatura": mazo.asignaturaMazo
        });
    } catch(error) {
      print("Este es el error: $error");
    }
  }

  Future<void> traerMazos() async {
    try {
      final data = await supabase
      .from("mazos")
      .select("*");

      print(data);
    } catch(error) {
      print(error);
    }
  }
}