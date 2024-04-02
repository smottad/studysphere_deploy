import 'package:add_2_calendar/add_2_calendar.dart';
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
      //para que no salga el error cuando el teclado no deja que se vea todo el formulario
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            textFormulario(context, nombre, 'Nombre',
                teclado: TextInputType.name),
            Padding(
              padding: const EdgeInsets.all(8),
              child: FutureBuilder(
                future: listaAsignaturas,
                builder: (context, snapshot) => DropdownMenu<String>(
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
            textFormulario(context, fecha, 'Fecha',
                funcion: escogerFecha, teclado: TextInputType.none),
            textFormulario(context, horaInicio, 'Hora inicio',
                funcion: escogerHoraInicio, teclado: TextInputType.none),
            textFormulario(context, horaFin, 'Hora fin',
                funcion: escogerHoraFinal, teclado: TextInputType.none),
            textFormulario(context, prioridad, 'Prioridad'),
            textFormulario(context, temas, 'Temas'),
            SizedBox(
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
                          onChanged: (value) => setState(() => alarma = value)),
                    ],
                  ),
                )),
            boton(context, 'Guardar en el calendario', funcionGuardar),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  funcionGuardar(BuildContext context) {
    if (alarma!) {
      funcionAlarma();
    }
    anadirAlCalendario();
    mandarALaBD(context);
  }

  funcionAlarma() {}

  anadirAlCalendario() async {
    DateTime fechaInicioEvento;
    DateTime fechaFinalEvento;
    if (endHour != null) {
      fechaInicioEvento =
          date!.copyWith(hour: startHour?.hour, minute: startHour?.minute);
      fechaFinalEvento =
          date!.copyWith(hour: endHour?.hour, minute: endHour?.minute);
    } else {
      fechaInicioEvento =
          date!.copyWith(hour: startHour?.hour, minute: startHour?.minute);
      fechaFinalEvento = date!
          .copyWith(hour: (startHour!.hour + 1), minute: startHour?.minute);
    }

    final Event event = Event(
      title: 'evento de $asignatura',
      description: 'creado automáticamente por Study Sphere',
      startDate: fechaInicioEvento,
      endDate: fechaFinalEvento,
    );
    await Add2Calendar.addEvent2Cal(event);
  }
}
