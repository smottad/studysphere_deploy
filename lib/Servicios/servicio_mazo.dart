import 'package:supabase_flutter/supabase_flutter.dart';

class Mazo {
  Mazo({
    this.id, 
    required this.nombreMazo, 
    required this.idAsignaturaMazo, 
    required this.nombreAsignaturaMazo,
    required this.cantidad,
  });

  int? id;
  int cantidad;
  String nombreMazo;
  int idAsignaturaMazo;
  String nombreAsignaturaMazo;
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
          "id_asignatura": mazo.idAsignaturaMazo
        });
    } catch(error) {
      print("Este es el error: $error");
    }
  }

  Future<void> actualizarMazo(Mazo mazo) async {
    try{
      Session? sesion = supabase.auth.currentSession;
      final userId = sesion?.user.id;

      await supabase
        .from("mazos")
        .update({
          "nombre": mazo.nombreMazo,
          "id_asignatura": mazo.idAsignaturaMazo
        })
        .eq("id", mazo.id!)
        .eq("id_usuario", userId!);
    } catch(error) {
      print("Este es el error: $error");
    }
  }

  Future<void> eliminarMazo(Mazo mazo) async {
    try{
      Session? sesion = supabase.auth.currentSession;
      final userId = sesion?.user.id;

      await supabase
        .from("mazos")
        .delete()
        .eq("id", mazo.id!)
        .eq("id_usuario", userId!);
    } catch(error) {
      print("Este es el error: $error");
    }
  }

  Future<List<Mazo>> traerMazos() async {
    List<Mazo> mazos = [];

    try {
      final Session? sesion = supabase.auth.currentSession;
      final userId = sesion?.user.id;

      if(userId == null) {
        throw ArgumentError("El user OD no puede ser nulo");
      }

      final data = await supabase
      .from("mazos")
      .select("*, asignaturas(nombre), flashcards(id)")
      .eq('id_usuario', userId)
      .order("nombre", ascending: true);

      for(var maze in data) {
        mazos.add(Mazo(
          id: maze["id"],
          nombreMazo: maze["nombre"], 
          idAsignaturaMazo: maze["id_asignatura"],
          nombreAsignaturaMazo: maze["asignaturas"]["nombre"],
          cantidad: maze["flashcards"].length
        ));
      }

      print(data);
    } catch(error) {
      print(error);
    }
    return mazos;
  }
}