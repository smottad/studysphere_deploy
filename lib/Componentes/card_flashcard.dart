import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/parte_frontal_flashcard.dart';
import 'package:studysphere/Componentes/parte_trasera_flashcard.dart';
class CardFlashcard extends StatefulWidget {
  const CardFlashcard({
    super.key,
    required this.idFlashcard,
    required this.enunciado,
    required this.respuesta,
    required this.idMaze,
    required this.nameMaze,
    this.imageName,
  });

  final int idFlashcard;
  final int idMaze;
  final String nameMaze;
  final String enunciado;
  final String respuesta;
  final String? imageName;

  @override
  State<CardFlashcard> createState() => _CardFlashcardState();
}


class _CardFlashcardState extends State<CardFlashcard>{
  bool answers = false;

  void cambiarTexto() {
      if(answers) {
        setState(() {
          answers = false;
        });
      } else {
        setState(() {
          answers = true;
        });
      }
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: answers ? 
        BackFlashcard(
          respuesta: widget.respuesta,
          itemCallback: (value) => cambiarTexto(),
        ) : 
        FrontFlashcard(
          idFlashcard: widget.idFlashcard,
          enunciado: widget.enunciado,
          respuesta: widget.respuesta,
          idMaze: widget.idMaze,
          nameMaze: widget.nameMaze,
          imageName: widget.imageName,
          itemCallback: (value) => cambiarTexto(),
        ),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation, 
          child: child
        );
      },          
    );
  }
}
