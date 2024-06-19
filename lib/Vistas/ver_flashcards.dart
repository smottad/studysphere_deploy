import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/card_flashcard.dart';
import 'package:studysphere/Controladores/controlador_flashcards.dart';
import 'package:studysphere/Servicios/servicio_flashcard.dart';

class VerFlashcards extends StatelessWidget {
  VerFlashcards({
    super.key,
    required this.idMaze,
    required this.nameMaze,
  });

  final int idMaze;
  final String nameMaze;

  final ServicioBaseDatosFlashcard dbFlashcards = ServicioBaseDatosFlashcard();

  static const routeName = '/inicio/flashcards/ver_flashcards';

  @override 
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: appBar(context, "Flashcards del mazo de $nameMaze"),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          goToCreateFlashcard(context, ArgumentsFlashcards(idMaze: idMaze, nameMaze: nameMaze));
        }, 
        icon: Icon(
          Icons.add,
          color: colorScheme.shadow,
        ), 
        label: Text(
          "Crear flashcard",
          style: TextStyle(
            color: colorScheme.shadow,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
        ),       
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,  
        child: FutureBuilder<List<Flashcard>>(
          future: dbFlashcards.traerFlashcards(idMaze),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator(),
                ) 
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No se encontraron flashcards'));
            } else {
              final flashcards = snapshot.data!;
              return Column( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Wrap(
                      spacing: 10,
                      // runAlignment: WrapAlignment.center,
                      // crossAxisAlignment: WrapCrossAlignment.center,
                      children: flashcards.map((flash) {
                          return CardFlashcard(
                            idFlashcard: flash.id, 
                            enunciado: flash.enunciado, 
                            respuesta: flash.respuesta,
                            idMaze: idMaze,
                            nameMaze: nameMaze,
                          );
                        }).toList(),
                    ),
                  ),
                ]
              );
            }
          }),
        ), 
        
    );
  }
}