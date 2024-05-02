import 'package:flutter/material.dart';
import 'package:studysphere/my_flutter_app_icons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:studysphere/Controladores/controlador_ver_proyectos.dart';

class CardProject extends StatelessWidget {
  const CardProject(
    {
      super.key,
      required this.nameProject,
    }
  );

  final String nameProject;

  @override
  Widget build(BuildContext context) {
    Color colorText = Theme.of(context).colorScheme.onPrimary;
    Color backgroundBtn = Theme.of(context).colorScheme.secondary;

    return Card(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      color: Theme.of(context).colorScheme.primary,
      child: Padding( 
        padding: const EdgeInsets.fromLTRB(20, 10, 20 , 10),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 100,
                ), 
                Center(
                  child: Title(                
                    color: colorText,
                    child: Text(
                      nameProject,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                IconButton(
                  onPressed: () => goEditProject(context, nameProject), 
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
                       onDismissCallback: (type) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Dismissed by $type'),
                          ),
                        );
                      },
                      // body: const Center(child: Text(
                      //         'If the body is specified, then title and description will be ignored, this allows to 											further customize the dialogue.',
                            //   style: TextStyle(fontStyle: FontStyle.italic),
                            // ),),
                      title: '¿Está seguro que quiere eliminar el proyecto $nameProject?',
                      desc:   'Estas a punto de eliminar el proyecto $nameProject permanenetemente.',
                      btnOkOnPress: () {},
                      btnCancelOnPress: () {}
                      ).show();
                  },
                  icon: const Icon(Icons.delete),
                ),
              ]
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundBtn,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Tareas",
                    style: TextStyle(
                      color: colorText,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundBtn,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Reuniones",
                    style: TextStyle(
                      color: colorText,
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