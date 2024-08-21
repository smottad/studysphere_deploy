import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ArgumentsFlashcards {
  const ArgumentsFlashcards({
    required this.idMaze,
    required this.nameMaze,
    this.idFlashcard,
    this.enunciado,
    this.respuesta,
  });

  final int idMaze;
  final String nameMaze;
  final int? idFlashcard;
  final String? enunciado;
  final String? respuesta;
}

goToSeeFlashcards(BuildContext context, ArgumentsFlashcards args) {
  Navigator.pushNamed(context, '/inicio/flashcards/ver_flashcards', arguments: args);
}

goToCreateFlashcard(BuildContext context, ArgumentsFlashcards args) {
  Navigator.pushNamed(context, '/inicio/flashcards/crear_flashcard', arguments: args);
}

goToEditFlashcard(BuildContext context, ArgumentsFlashcards args) {
  Navigator.pushNamed(context, '/inicio/flashcards/editar_flashcard', arguments: args);
}

getFoto() async {
  final ImagePicker picker = ImagePicker();
  Uint8List? byteImage;

  XFile? file = await picker.pickImage(source: ImageSource.gallery);
  byteImage = await file?.readAsBytes();

  return byteImage;
}
