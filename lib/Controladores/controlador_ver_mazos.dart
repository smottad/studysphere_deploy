import 'package:flutter/material.dart';
import 'package:studysphere/Controladores/controlador_flashcards.dart';

goToCrearMazo(BuildContext context) {
  Navigator.pushNamed(context, '/inicio/mazos/crear_mazo');
}

goToPracticarMazo(BuildContext context, ArgumentsFlashcards args) {
  Navigator.pushNamed(context, '/inicio/flashcards/practicar_flashcards', arguments: args);
}

goToVerMazos (BuildContext context) {
  Navigator.pushNamed(context, '/inicio/mazos');
}