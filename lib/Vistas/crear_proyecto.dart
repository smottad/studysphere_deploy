import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_crear_asignatura.dart';
import 'package:studysphere/Controladores/controlador_crear_proyecto.dart';
import 'package:studysphere/Componentes/app_bar.dart';

ControllerCalendar controllerCalendarInit =
    ControllerCalendar(DateTime.now(), 'Fecha de inicio');
ControllerCalendar controllerCalendarFinal = ControllerCalendar(
    DateTime.now().add(const Duration(days: 1)), 'Fecha de Finalización');
TextEditingController nameController =
    TextEditingController(); // Controlador para el nombre del proyecto
TextEditingController materiaController =
    TextEditingController(); // Controlador para la materia del proyecto

Map<String, int> asignaturas = {};

Future<void> actualizarAsignaturas() async {
  try {
    asignaturas = await getAsignaturas();
  } catch (error) {
    // Manejar cualquier error que pueda ocurrir durante la actualización de las asignaturas
    print('Error al actualizar las asignaturas: $error');
  }
}

String selectedMateria =
    ""; // Variable para almacenar el nombre de la materia seleccionada
int selectedMateriaId =
    0; // Variable para almacenar el ID de la materia seleccionada

class CrearProyecto extends StatelessWidget {
  const CrearProyecto({super.key});

  @override
  Widget build(BuildContext context) {
    actualizarAsignaturas();
    return Scaffold(
      appBar: appBar(context, 'Nuevo Proyecto', color: 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textFormulario(context, nameController, "Nombre del proyecto"),
            const SizedBox(
              height: 50,
            ),
            const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InitCalendar(
                  restorationId: 'main',
                ),
                SizedBox(
                  width: 20,
                ),
                FinalCalendar(
                  restorationId: 'main',
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  )),
              width: 300,
              child: DropdownButtonFormField(
                alignment: Alignment.center,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 1,
                    ),
                  ),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                items: asignaturas.keys.map((e) {
                  return DropdownMenuItem(
                    alignment: Alignment.center,
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                isExpanded: true,
                hint: const Text("Seleccione la materia"),
                onChanged: (value) {
                  selectedMateria = value!;
                  selectedMateriaId = asignaturas[value]!;
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  textStyle: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  // Llama a la función para crear el proyecto al presionar el botón "Guardar"
                  crearProyecto(
                      context,
                      nameController.text,
                      selectedMateria,
                      selectedMateriaId,
                      controllerCalendarInit.getDateTimeVar(),
                      controllerCalendarFinal.getDateTimeVar());
                },
                child: Text(
                  "Guardar",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class InitCalendar extends StatefulWidget {
  const InitCalendar({
    super.key,
    this.restorationId,
  });

  final String? restorationId;

  @override
  State<InitCalendar> createState() => _InitCalendar();
}

/// RestorationProperty objects can be used because of RestorationMixin.
class _InitCalendar extends State<InitCalendar> with RestorationMixin {
  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(controllerCalendarInit.getDateTimeVar());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendar,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime.now(),
          lastDate: DateTime(2060),
          fieldLabelText: controllerCalendarInit.getLabel(),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        controllerCalendarInit.setDateTimeVar(newSelectedDate);

        if (controllerCalendarFinal
            .getDateTimeVar()
            .isBefore(_selectedDate.value)) {
          controllerCalendarFinal
              .setDateTimeVar(newSelectedDate.add(const Duration(days: 1)));
        }
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //       'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        initial_date.text =
            '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width:
                      (MediaQuery.of(context).size.width * 0.5).clamp(100, 200),
                  child: TextField(
                    keyboardType: TextInputType.datetime,
                    enabled: false,
                    controller: initial_date,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.surface,
                      labelText: controllerCalendarInit.getLabel(),
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _restorableDatePickerRouteFuture.present();
                  },
                  icon: const Icon(Icons.calendar_month),
                  // label: Text('${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FinalCalendar extends StatefulWidget {
  const FinalCalendar({
    super.key,
    this.restorationId,
  });

  final String? restorationId;

  @override
  State<FinalCalendar> createState() => _FinalCalendar();
}

/// RestorationProperty objects can be used because of RestorationMixin.
class _FinalCalendar extends State<FinalCalendar> with RestorationMixin {
  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(controllerCalendarFinal.getDateTimeVar());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendar,
          initialDate: controllerCalendarFinal.getDateTimeVar(),
          firstDate: controllerCalendarInit
              .getDateTimeVar()
              .add(const Duration(days: 1)),
          lastDate: DateTime(2060),
          fieldLabelText: controllerCalendarFinal.getLabel(),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        controllerCalendarFinal.setDateTimeVar(newSelectedDate);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //       'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        final_date.text =
            '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width:
                      (MediaQuery.of(context).size.width * 0.5).clamp(100, 200),
                  child: TextField(
                    keyboardType: TextInputType.datetime,
                    enabled: false,
                    controller: final_date,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.surface,
                      labelText: controllerCalendarFinal.getLabel(),
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _restorableDatePickerRouteFuture.present();
                  },
                  icon: const Icon(Icons.calendar_month),
                  // label: Text('${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
