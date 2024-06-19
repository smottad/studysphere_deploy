import 'package:supabase_flutter/supabase_flutter.dart';

class Flashcard {
  Flashcard({
    required this.id, 
    required this.enunciado, 
    required this.respuesta, 
    required this.idMazo,
    required this.nombreMazo,
  });

  int id;
  String enunciado;
  String respuesta;
  int idMazo;
  String nombreMazo;
}

class ServicioBaseDatosFlashcard {
  final supabase = Supabase.instance.client;

  Future<void> guardarFlashcard(Flashcard flashcard) async {
    try{
      Session? sesion = supabase.auth.currentSession;

      await supabase
        .from("flashcards")
        .insert({
          "enunciado": flashcard.enunciado,
          "respuesta": flashcard.respuesta,
          "id_usuario": sesion?.user.id,
          "id_mazo": flashcard.idMazo,
        });
    } catch(error) {
      print("Este es el error: $error");
    }
  }

  Future<void> actualizarFlashcard(Flashcard flashcard) async {
    try{
      Session? sesion = supabase.auth.currentSession;
      final userId = sesion?.user.id;

      await supabase
        .from("flashcards")
        .update({
          "enunciado": flashcard.enunciado,
          "respuesta": flashcard.respuesta
        })
        .eq("id", flashcard.id)
        .eq("id_usuario", userId!)
        .eq("id_mazo", flashcard.idMazo);
    } catch(error) {
      print("Este es el error: $error");
    }
  }

  Future<void> eliminarFlashcard(Flashcard flashcard) async {
    try{
      Session? sesion = supabase.auth.currentSession;
      final userId = sesion?.user.id;

      await supabase
        .from("flashcards")
        .delete()
        .eq("id", flashcard.id)
        .eq("id_usuario", userId!)
        .eq("id_mazo", flashcard.idMazo);
    } catch(error) {
      print("Este es el error: $error");
    }
  }

  Future<List<Flashcard>> traerFlashcards(int idMazo) async {
    List<Flashcard> flashcards = [];

    try {
      final Session? sesion = supabase.auth.currentSession;
      final userId = sesion?.user.id;

      if(userId == null) {
        throw ArgumentError("El user ID no puede ser nulo");
      }

      final data = await supabase
      .from("flashcards")
      .select("*, mazos(id, nombre)")
      .eq('id_usuario', userId)
      .eq("id_mazo", idMazo)
      .order("enunciado", ascending: true);

      for(var flash in data) {
        print(flash);
        flashcards.add(Flashcard(
          id: flash["id"],
          enunciado: flash["enunciado"], 
          respuesta: flash["respuesta"],
          nombreMazo: flash["mazos"]["nombre"],
          idMazo: flash["mazos"]["id"],),
        );
      }

      print(data);
    } catch(error) {
      print("Hola $error");
    }
    return flashcards;
  }
}