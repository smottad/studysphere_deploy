import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:studysphere/Controladores/controlador_editar_mazo.dart';
import 'package:studysphere/my_flutter_app_icons.dart';
import 'package:studysphere/Servicios/servicio_mazo.dart';

class CardMazo extends StatelessWidget {
  CardMazo({
    super.key,
    this.idMaze,
    required this.nameMaze,
    required this.idSubject,
    required this.subjectMaze,
  });

  final int? idMaze;
  final String nameMaze;
  final int idSubject;
  final String subjectMaze;

  final ServicioBaseDatosMazo dbMazo = ServicioBaseDatosMazo();

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

    return Card(
      shadowColor: colors.scrim,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  Center(                    
                    child: Column( 
                     children: [
                      Title(
                        color: colors.onPrimary,
                        child: Text(
                          nameMaze,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                        child: Text(
                          subjectMaze,
                          style: TextStyle(
                            color: colors.tertiary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                     ]
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    onPressed: () {
                      goToEditMaze(context, EditMazeArguments(idMaze!, subjectMaze, nameMaze));
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
                        // body: const Center(child: Text(
                        //         'If the body is specified, then title and description will be ignored, this allows to 											further customize the dialogue.',
                        //   style: TextStyle(fontStyle: FontStyle.italic),
                        // ),),
                        title:
                            '¿Está seguro que quiere eliminar el mazo $nameMaze?',
                        desc:
                            'Estas a punto de eliminar el mazo $nameMaze permanenetemente.',
                        btnOkOnPress: () {
                          dbMazo.eliminarMazo(Mazo(
                            id: idMaze,
                            idAsignaturaMazo: idSubject,
                            nombreMazo: nameMaze,
                            nombreAsignaturaMazo: subjectMaze
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mazo eliminado con éxito'),
                            ),
                          );
                          goToMazes(context);
                        },
                        btnCancelOnPress: () {})
                      .show();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ]),
            const SizedBox(
              height: 20,
            ),
            Text("Cantidad de flashcards: 0"),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.secondary,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Ver flashcards",
                    style: TextStyle(
                      color: colors.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 80,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.secondary,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Practicar",
                    style: TextStyle(
                      color: colors.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
