import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final listaAsignaturas = getProyectos();

  @override
  void initState() {
    super.initState();
    nombre.addListener(validarNombre);
    prioridad.addListener(validarPrioridad);
    asignatura = null;
    tipo = null;
    startHour = null;
    endHour = null;
    date = null;
  }

  @override
  void dispose() {
    super.dispose();
    nombre.clear();
    horaFin.clear();
    horaInicio.clear();
    fecha.clear();
    prioridad.clear();
    temas.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, titulo),
      //para que no salga el error cuando el teclado no deja que se vea todo el formulario
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            textFormulario(context, nombre, "Nombre",
                teclado: TextInputType.name,
                validator: (val) => nombreValidator_),
            Padding(
              padding: const EdgeInsets.all(8),
              child: FutureBuilder<List<DropdownMenuEntry<String>>>(
                future: getProyectos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return DropdownMenu<String>(
                      hintText: 'Proyecto',
                      width: (size.width * 0.8).clamp(200, 500),
                      onSelected: (value) => setAsignatura(value),
                      textStyle: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      dropdownMenuEntries: snapshot.data!,
                      inputDecorationTheme: InputDecorationTheme(
                        hintStyle: textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurface),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        filled: true,
                        fillColor: colorScheme.surface,
                        border: const OutlineInputBorder(),
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: DropdownMenu(
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 'Tarea', label: 'Tarea'),
                  DropdownMenuEntry(value: 'Examen', label: 'Examen'),
                  DropdownMenuEntry(value: 'Reunión', label: 'Reunion')
                ],
                hintText: 'Tipo',
                width: (size.width * 0.8).clamp(200, 500),
                onSelected: (value) => setTipo(value),
                textStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  hintStyle: textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurface),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            textFormulario(context, fecha, 'Fecha',
                funcion: escogerFecha, teclado: TextInputType.none),
            textFormulario(context, horaInicio, 'Hora inicio',
                funcion: escogerHoraInicio, teclado: TextInputType.none),
            textFormulario(context, horaFin, 'Hora fin (Opcional)',
                funcion: escogerHoraFinal, teclado: TextInputType.none),
            textFormulario(context, prioridad, 'Prioridad',
                teclado: TextInputType.number,
                validator: (val) => prioridadValidator_),
            textFormulario(context, temas, 'Temas'),
            kIsWeb //verifica si es una webapp
                ? const Spacer()
                : SizedBox(
                    width: (size.width * 0.6).clamp(200, 500),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                              onChanged: (value) async {
                                botonAlarma(value);
                              }),
                        ],
                      ),
                    )),
            boton(context, 'Guardar', funcionGuardar),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Future<void> botonAlarma(bool? value) async {
    if (await checkAndroidScheduleExactAlarmPermission()) {
      setState(() => alarma = value);
    }
  }
}

Future<bool> checkAndroidScheduleExactAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.status;
  //Schedule exact alarm permission
  if (status.isDenied) {
    //Requesting schedule exact alarm permission
    final res = await Permission.scheduleExactAlarm.request();
    if (res.isDenied) {
      return false;
    }
  }
  return true;
}
