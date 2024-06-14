import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/boton.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_examen.dart';

class PaginaExamen extends StatefulWidget {
  const PaginaExamen({super.key});

  @override
  State<PaginaExamen> createState() => _PaginaExamenState();
}

class _PaginaExamenState extends State<PaginaExamen> {
  var currentFlashcard;
  var flashcardList;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    //final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    flashcardList = getFlashcards();
    flashcardList.shuffle();
    currentFlashcard = flashcardList.removeLast();
    var textoBoton = "Verificar";
    return Scaffold(
      appBar: appBar(context, "Study Sphere", menu: true),
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          const Text("EXAMEN"),
          //un tercio del ancho de la pantalla
          SizedBox(
              width: size.width / 3,
              child: const Card(
//aqui iria la flashcard
                  )),
          textFormulario(
            context,
            respuesta,
            'Respuesta',
          ),
          boton(context, textoBoton, funcion(textoBoton, context)),
        ],
      ),
    );
  }

  funcion(String textoBoton, BuildContext context) {
    if (textoBoton != "Verificar") {
      setState(() {
        textoBoton = "Verificar";
        currentFlashcard = flashcardList.removeLast();
      });
      return;
    }
    if (respuesta.text == currentFlashcard['respuesta']) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Correcto"),
        backgroundColor: Colors.green,
      ));
      setState(() {
        textoBoton = "Siguente";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Incorrecto la respuesta es ${currentFlashcard['respuesta']}"),
        backgroundColor: Colors.green,
      ));
      setState(() {
        textoBoton = "Siguente";
      });
    }
  }

  getFlashcards() {
    return [];
  }
}
