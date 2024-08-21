import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:randomstring_dart/randomstring_dart.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/image_container.dart';
import 'package:studysphere/Componentes/image_deafault.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_flashcards.dart';
import 'package:studysphere/Servicios/servicio_flashcard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CrearFlashcard extends StatefulWidget {
  const CrearFlashcard({super.key});

  @override
  State<CrearFlashcard> createState() => _CrearFlashcardState();
}


class _CrearFlashcardState extends State<CrearFlashcard> {
  Image? image; 
  Uint8List? byteImage;
  bool isImage = false;
  final rs = RandomString();

  final TextEditingController textEnunciado = TextEditingController();
  final TextEditingController textRespuesta = TextEditingController();

  @override 
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

    final args = ModalRoute.of(context)!.settings.arguments as ArgumentsFlashcards;

    return Scaffold(
      appBar: appBar(context, "Crear Flashcard"),
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
                InkWell(
                  onTap: () async {
                    var file = await getFoto();
                    if (file == null) {
                      return;
                    }
                    
                    return setState(() {
                      // if (kIsWeb) {
                      //   image = Image.network(file.path);
                      // } else {
                      //   image = Image.file(File(file.path));
                      // }
                      image = Image.memory(file);
                      byteImage = file;
                      isImage = true;
                    });
                  },
                  customBorder: const CircleBorder(),
                  child: isImage ? ImageContainer(asset: false, image: image,) : const ImageContainer(asset: true, assetImage: 'lib/Assets/default_image.png',)
                ),
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
                    if(textEnunciado.text.isNotEmpty && textRespuesta.text.isNotEmpty) {
                      ServicioBaseDatosFlashcard dbFlashcards = ServicioBaseDatosFlashcard();
                      String enlaceImagen = rs.getRandomString(uppersCount: 5, lowersCount: 5, numbersCount: 5); 

                      dbFlashcards.guardarFlashcard(
                        Flashcard(
                          id: 0, 
                          enunciado: textEnunciado.text, 
                          respuesta: textRespuesta.text,
                          idMazo: args.idMaze, 
                          nombreMazo: args.nameMaze,
                          enlaceImagen: enlaceImagen,
                        )
                      ).then((value) => dbFlashcards.subirImagen(byteImage!, enlaceImagen).then((value) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Se ha guardado con exito"),
                          duration: Duration(seconds: 2),
                        ),
                      ),)
                      ).catchError((e) =>
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Error al guardar el mazo: $e",
                              style: TextStyle(
                                color: colorScheme.onTertiary,
                              ),
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: const Color.fromRGBO(255, 50, 50, 1),
                          )
                        )
                      );

                      textEnunciado.clear();
                      textRespuesta.clear();

                      goToSeeFlashcards(context, 
                        ArgumentsFlashcards(
                          idMaze: args.idMaze, 
                          nameMaze: args.nameMaze)
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Llene todo los campos",
                            style: TextStyle(
                              color: colorScheme.onTertiary,
                            ),
                          ),
                          duration: const Duration(seconds: 2),
                          backgroundColor: const Color.fromRGBO(255, 50, 50, 1),
                        )
                      );
                    }
                  }, 
                  child: Text(
                    "Guardar",
                    style: TextStyle(
                      color: colorScheme.scrim,
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}