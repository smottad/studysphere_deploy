import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studysphere/Componentes/image_container.dart';
import 'package:studysphere/Componentes/parte_frontal_flashcard.dart';
import 'package:studysphere/Componentes/parte_trasera_flashcard.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Servicios/servicio_flashcard.dart';
class PracticeFlashcard extends StatefulWidget {
  const PracticeFlashcard({
    super.key,
    required this.idFlashcard,
    required this.enunciado,
    required this.respuesta,
    required this.idMaze,
    required this.nameMaze,
    this.imageName,
    required this.itemcallback,
  });

  final int idFlashcard;
  final int idMaze;
  final String nameMaze;
  final String enunciado;
  final String respuesta;
  final String? imageName;
  final VoidCallback itemcallback;

  @override
  State<PracticeFlashcard> createState() => _PracticeFlashcardState();
}


class _PracticeFlashcardState extends State<PracticeFlashcard>{

  final ServicioBaseDatosFlashcard dbFlashcards = ServicioBaseDatosFlashcard();
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
   
    return SizedBox(
      width: size.width * 0.2,
      height: size.height * 0.5,
      child: FutureBuilder<Image>(
        future: dbFlashcards.bajarImagen(widget.imageName), 
        builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator(),
                ) 
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Card(
                shadowColor: colors.scrim,
                elevation: 10,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [ 
                      Title(
                        color: colors.onPrimary,
                        child: Text(
                          widget.enunciado,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const ImageContainer(asset: true, assetImage: 'lib/Assets/default_image.png'),
                    ]
                  ),
                ),
              );       
            } else {
              final Image downImage = snapshot.data!;
              return Card(
                shadowColor: colors.scrim,
                elevation: 10,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [ 
                      Title(
                        color: colors.onPrimary,
                        child: Text(
                          widget.enunciado,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ImageContainer(asset: false, image: downImage,),
                      Center(
                        child: textFormulario(
                          context, 
                          textController, 
                          "Escriba respuesta"
                          )
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (textController.text == widget.respuesta){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("¡¡¡Respuesta correcta!!!"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            widget.itemcallback();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Respuesta incorrecta",
                                  style: TextStyle(
                                    color: colors.onTertiary,
                                  ),
                                ),
                                duration: const Duration(seconds: 1),
                                backgroundColor: const Color.fromRGBO(255, 50, 50, 1),
                              )
                            );
                            print("Respuesta incorrecta");
                          }
                        },
                        child: Text(
                          'Comprobar respuesta',
                          style: TextStyle(
                            color: colors.primary
                          ),
                        ),
                      )
                    ]
                  ),
                ),
              );          
            }
        }
      ),  
    );
  }
}
