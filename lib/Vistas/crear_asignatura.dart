import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_crear_asignatura.dart';

class CrearAsignatura extends StatelessWidget {
  const CrearAsignatura({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textFormulario(context, name, "Nombre de asignatura"),
            const DatePickerExample(restorationId: 'main',),
            // DatePickerDialog(
            //   restorationId: 'date_picker_dialog',
            //   initialEntryMode: DatePickerEntryMode.input,
            //   initialDate: DateTime.now(),
            //   firstDate: DateTime.now(),
            //   lastDate: DateTime(2060),
            // ),
          ],
        ),
      )
    );
  }
}

class DatePickerExample extends StatefulWidget {
  const DatePickerExample({super.key, this.restorationId});

  final String? restorationId;

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

/// RestorationProperty objects can be used because of RestorationMixin.
class _DatePickerExampleState extends State<DatePickerExample>
    with RestorationMixin {
  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;
  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime.now());
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
          fieldLabelText: 'Fecha de inicio:',
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
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
              child: SizedBox(
                width: MediaQuery.of(context).size.width*0.7,
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.surface,
                    labelText: "Ingrese la fecha de inicio",
                    border: const OutlineInputBorder(),
                  )
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
    );
  }
}