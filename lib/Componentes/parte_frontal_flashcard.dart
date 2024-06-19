import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:studysphere/Controladores/controlador_flashcards.dart';
import 'package:studysphere/Servicios/servicio_flashcard.dart';
import 'package:studysphere/my_flutter_app_icons.dart';

class FrontFlashcard extends StatelessWidget {
  const FrontFlashcard({
    super.key,
    required this.idFlashcard,
    required this.enunciado,
    required this.respuesta,
    required this.idMaze,
    required this.nameMaze,
    required this.itemCallback,
  });

  final int idFlashcard;
  final String enunciado;
  final String respuesta;
  final int idMaze;
  final String nameMaze;
  final ValueChanged<String> itemCallback;

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
   
    return SizedBox(
      width: size.width * 0.2,
      height: size.height * 0.6,
      child: Card(
        shadowColor: colors.scrim,
        elevation: 10,
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [ 
              Row(            // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      goToEditFlashcard(context, ArgumentsFlashcards(
                        idMaze: idMaze,
                        nameMaze: nameMaze,
                        idFlashcard: idFlashcard,
                        enunciado: enunciado,
                        respuesta: respuesta
                      ));
                    },
                    icon: const Icon(MyFlutterApp.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.scale,
                        dialogType: DialogType.warning,
                        width: 700,
                        dismissOnTouchOutside: true,
                        onDismissCallback: (type) {},
                        title:
                            '¿Está seguro que quiere eliminar la flashcard con el siguiente enunciado $enunciado?',
                        desc:
                            'Estas a punto de eliminar la flashcard con el siguiente enunciado $enunciado permanenetemente.',
                        btnOkOnPress: () {
                          ServicioBaseDatosFlashcard dbFlashcards = ServicioBaseDatosFlashcard();

                          dbFlashcards.eliminarFlashcard(Flashcard(
                            id: idFlashcard, 
                            enunciado: enunciado, 
                            respuesta: respuesta,
                            idMazo: idMaze, 
                            nombreMazo: nameMaze
                          ));

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mazo eliminado con éxito'),
                            ),
                          );

                          goToSeeFlashcards(context, 
                          ArgumentsFlashcards(
                            idMaze: idMaze, 
                            nameMaze: nameMaze)
                          );
                        },
                        btnCancelOnPress: () {})
                      .show();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              Title(
                color: colors.onPrimary,
                child: Text(
                  enunciado,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colors.tertiary,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10)
                    ),
                  ),
                  child: TextButton(
                    onPressed: () => itemCallback("Hola"), 
                    child: Text(
                      "Ver respuesta", 
                      style: TextStyle(
                        color:  colors.tertiary
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
      ),          
    );
  }
}