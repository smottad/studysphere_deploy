import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:randomstring_dart/randomstring_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Flashcard {
  Flashcard({
    required this.id, 
    required this.enunciado, 
    required this.respuesta, 
    required this.idMazo,
    required this.nombreMazo,
    this.enlaceImagen,
  });

  int id;
  String enunciado;
  String respuesta;
  int idMazo;
  String nombreMazo;
  String? enlaceImagen;
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
          "enlace_imagen": flashcard.enlaceImagen,
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
          idMazo: flash["mazos"]["id"],
          enlaceImagen: flash["enlace_imagen"]), 
        );
      }

      print(data);
    } catch(error) {
      print("Hola $error");
    }
    return flashcards;
  }

  Future<void> subirImagen(Uint8List byteImage, String imageName) async {
    try {
      final String fullPath = await supabase.storage.from('imagenes').uploadBinary(imageName, byteImage);
    } catch (error) {
      print('Este es el error: $error');
      rethrow;
    }
  }

  Future<Image> bajarImagen(String? imageName) async {
    try {
      if (imageName != null) {
        final Uint8List file = await supabase.storage.from('imagenes').download(imageName!);
        final Image image = Image.memory(file);
        return image;
      } else {
        return Image.asset('lib/Assets/default_image.png');
      }
    } catch (error) {
      print('Este es el error: $error');
      rethrow;
    }
  }
}