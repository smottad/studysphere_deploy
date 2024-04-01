import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/boton.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_crear_recordatorio.dart';

class CrearRecordatorio extends StatefulWidget {
  const CrearRecordatorio({super.key});

  @override
  State<CrearRecordatorio> createState() => _CrearRecordatorioState();
}

class _CrearRecordatorioState extends State<CrearRecordatorio> {
  final titulo = 'Nuevo recordatorio';
  final listaAsignaturas = getAsignaturasYProyectos();
  bool? alarma = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, titulo),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            textFormulario(context, nombre, 'Nombre'),
            Padding(
              padding: const EdgeInsets.all(8),
              child: FutureBuilder(
                future: listaAsignaturas,
                builder: (context, snapshot) => DropdownMenu<int>(
                  hintText: 'Asignatura o proyecto',
                  width: (size.width * 0.7).clamp(200, 500),
                  onSelected: (value) => setAsignatura(value),
                  textStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  dropdownMenuEntries: snapshot.data!,
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: DropdownMenu(
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 0, label: 'Tarea'),
                  DropdownMenuEntry(value: 1, label: 'Examen'),
                  DropdownMenuEntry(value: 2, label: 'Reunion')
                ],
                hintText: 'tipo',
                width: (size.width * 0.7).clamp(200, 500),
                onSelected: (value) => setTipo(value),
                textStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            textFormulario(context, fecha, 'Fecha'),
            textFormulario(context, hora, 'Hora'),
            textFormulario(context, prioridad, 'Prioridad'),
            (tipo == null
                ? textFormulario(context, temas, 'Temas')
                //esto es solo para que no salga nada
                : const Padding(padding: EdgeInsets.all(0))),
            SizedBox(
                width: (size.width * 0.7).clamp(200, 500),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        '¿Activar alarma?',
                        style: textTheme.bodyLarge
                            ?.copyWith(color: colorScheme.onBackground),
                      ),
                      const Spacer(),
                      Checkbox(
                          value: alarma,
                          onChanged: (value) => setState(() => alarma = value)),
                    ],
                  ),
                )),
            boton(context, 'guardar', () {
              if (alarma!) {
                funcionAlarma();
              }
              mandarALaBD();
            }),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void funcionAlarma() {}
}
