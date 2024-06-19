import 'package:flutter/widgets.dart';

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

