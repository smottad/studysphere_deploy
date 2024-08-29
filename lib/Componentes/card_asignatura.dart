import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/selected_days.dart';
import 'package:studysphere/Controladores/controlador_estudiar_examen.dart';
import 'package:studysphere/Controladores/controlador_ver_asignatura.dart';
import 'package:studysphere/my_flutter_app_icons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:studysphere/Servicios/servicio_asignatura.dart';

class CardAsignatura extends StatelessWidget {
  const CardAsignatura({
    super.key,
    required this.nameSubject,
    required this.daysSelected,
    required this.idAsignatura,
  });

  final String idAsignatura;
  final String nameSubject;
  final List<bool> daysSelected;

  @override
  Widget build(BuildContext context) {
    Color colorText = Theme.of(context).colorScheme.onPrimary;
    Color backgroundBtn = Theme.of(context).colorScheme.secondary;

    return Card(
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
                    child: Title(
                      color: colorText,
                      child: Text(
                        nameSubject,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () => irEditarAsignatura(
                        context, nameSubject, daysSelected, idAsignatura),
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
                              // onDismissCallback: (type) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: Text('Dismissed by $type'),
                              //     ),
                              //   );
                              // },
                              // body: const Center(child: Text(
                              //         'If the body is specified, then title and description will be ignored, this allows to 											further customize the dialogue.',
                              //   style: TextStyle(fontStyle: FontStyle.italic),
                              // ),),
                              title:
                                  '¿Está seguro que quiere eliminar la asignatura $nameSubject?',
                              desc:
                                  'Estas a punto de eliminar la asignatura $nameSubject permanenetemente.',
                              btnOkOnPress: () async {
                                try {
                                  await deleteAsignatura(idAsignatura);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Asignatura $nameSubject eliminada con éxito'),
                                    ),
                                  );
                                  // Recargar la lista de asignaturas
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Error al eliminar la asignatura: $error'),
                                    ),
                                  );
                                }
                              },
                              btnCancelOnPress: () {})
                          .show();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ]),
            const SizedBox(
              height: 10,
            ),
            SelectedDays(selected: daysSelected),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundBtn,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  width: 80,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundBtn,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onPressed: () {
                    irPrepararExamen(context, ExamenArgs(nombreMateria: nameSubject, idMateria: idAsignatura));
                  },
                  child: Text(
                    "Estudiar",
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
