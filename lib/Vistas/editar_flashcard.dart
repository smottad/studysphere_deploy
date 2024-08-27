import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_flashcards.dart';
import 'package:studysphere/Servicios/servicio_flashcard.dart';

class EditarFlashcard extends StatelessWidget {
  EditarFlashcard({super.key});

  final TextEditingController textEnunciado = TextEditingController();
  final TextEditingController textRespuesta = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

    final args =
        ModalRoute.of(context)!.settings.arguments as ArgumentsFlashcards;

    textEnunciado.text = args.enunciado!;
    textRespuesta.text = args.respuesta!;

    return Scaffold(
      appBar: appBar(context, "Editar Flashcard"),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: colorScheme.scrim,
                blurRadius: 20,
                offset: const Offset(5, 5),
              )
            ],
          ),
          width: (size.width * 0.3).clamp(300, 500),
          height: (size.height * 0.8).clamp(300, 1200),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textFormulario(context, textEnunciado, "Escribe el enunciado"),
                const SizedBox(
                  height: 20,
                ),
                textFormulario(context, textRespuesta, "Escribe la respuesta"),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                    ),
                    onPressed: () {
                      if (textEnunciado.text.isNotEmpty &&
                          textRespuesta.text.isNotEmpty) {
                        try {
                          ServicioBaseDatosFlashcard dbFlashcards =
                              ServicioBaseDatosFlashcard();

                          dbFlashcards.actualizarFlashcard(Flashcard(
                              id: args.idFlashcard!,
                              enunciado: textEnunciado.text,
                              respuesta: textRespuesta.text,
                              idMazo: args.idMaze,
                              nombreMazo: args.nameMaze));

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Se ha actualizado con exito"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          textEnunciado.clear();
                          textRespuesta.clear();

                          goToSeeFlashcards(
                              context,
                              ArgumentsFlashcards(
                                  idMaze: args.idMaze,
                                  nameMaze: args.nameMaze));
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Error al guardar el mazo: $error",
                              style: TextStyle(
                                color: colorScheme.onTertiary,
                              ),
                            ),
                            duration: const Duration(seconds: 1),
                            backgroundColor:
                                const Color.fromRGBO(255, 50, 50, 1),
                          ));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Llene todo los campos",
                            style: TextStyle(
                              color: colorScheme.onTertiary,
                            ),
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: const Color.fromRGBO(255, 50, 50, 1),
                        ));
                      }
                    },
                    child: Text(
                      "Guardar",
                      style: TextStyle(
                        color: colorScheme.scrim,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
