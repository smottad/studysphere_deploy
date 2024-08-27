import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/card_flashcard.dart';
import 'package:studysphere/Componentes/card_practice.dart';
import 'package:studysphere/Componentes/image_container.dart';
import 'package:studysphere/Controladores/controlador_flashcards.dart';
import 'package:studysphere/Controladores/controlador_ver_mazos.dart';
import 'package:studysphere/Servicios/servicio_flashcard.dart';

class PracticarFlashcards extends StatefulWidget {
  PracticarFlashcards({
    super.key,
    required this.idMaze,
    required this.nameMaze,
    required this.cantidad,
  });

  final int idMaze;
  final String nameMaze;
  final int cantidad;

  static const routeName = '/inicio/flashcards/practicar_flashcards';

  @override
  State<PracticarFlashcards> createState() => _PracticarFlashcardState();
}

class _PracticarFlashcardState extends State<PracticarFlashcards>{
  final ServicioBaseDatosFlashcard dbFlashcards = ServicioBaseDatosFlashcard();
  CarouselSliderController buttonCarouselController = CarouselSliderController();

  int pages = 0;

  void passPage () {
    buttonCarouselController.nextPage(
      duration: const Duration(milliseconds: 500), curve: Curves.linear);

    pages = pages + 1;

    if (pages == widget.cantidad) {
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.success,
        width: 700,
        btnCancelText: 'Salir',
        btnOkText: 'Volver a intentar',
        dismissOnTouchOutside: false,
        onDismissCallback: (type) {},
        title:
            '¡¡¡Muy bien!!!',
        desc:
            'Respondiste de manera correcta todas las preguntas.',
        btnOkOnPress: () {
          goToPracticarMazo(
            context, 
            ArgumentsFlashcards(idMaze: widget.idMaze, nameMaze: widget.nameMaze, cantidad: widget.cantidad)
          );
        },
        btnCancelOnPress: () {
          goToVerMazos(
            context
          );
          })
        .show();
    }

    print(pages);
  }

  @override 
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(context, "Práctica del mazo de ${widget.nameMaze}"),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,  
        child: FutureBuilder<List<Flashcard>>(
          future: dbFlashcards.traerFlashcards(widget.idMaze),
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
                  CarouselSlider(
                      // runAlignment: WrapAlignment.center,
                      // crossAxisAlignment: WrapCrossAlignment.center,
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      height: size.height * 0.6,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 1.0,
                      initialPage: 0,
                    ),
                    items: flashcards.map((flash) {

                      return 
                          PracticeFlashcard(
                            idFlashcard: flash.id, 
                            enunciado: flash.enunciado, 
                            respuesta: flash.respuesta,
                            idMaze: widget.idMaze,
                            nameMaze: widget.nameMaze,
                            imageName: flash.enlaceImagen,
                            itemcallback: passPage,
                          );
                    }).toList(),
                  ),
                ]
              );
            }
          }),
        ), 
        
    );
  }
}