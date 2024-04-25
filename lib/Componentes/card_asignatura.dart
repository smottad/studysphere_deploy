import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/selected_days.dart';
import 'package:studysphere/Controladores/controlador_ver_asignatura.dart';
import 'package:studysphere/my_flutter_app_icons.dart';

class CardAsignatura extends StatelessWidget {
  const CardAsignatura(
    {
      super.key,
      required this.nameSubject,
      required this.daysSelected,
    }
  );

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
        padding: const EdgeInsets.fromLTRB(20, 10, 20 , 10),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 70,
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
                  width: 40,
                ),
                IconButton(
                  onPressed: () => irEditarAsignatura(context, nameSubject, daysSelected), 
                  icon: const Icon(MyFlutterApp.edit),
                ),
              ]
            ),
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
                  width: 80,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundBtn,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onPressed: () {},
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