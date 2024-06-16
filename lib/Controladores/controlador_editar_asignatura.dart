import 'package:flutter/material.dart';
import 'package:studysphere/Servicios/servicio_asignatura.dart';

class ControladorEditarAsignatura {
  static Future<void> guardarCambios(
      BuildContext context,
      TextEditingController name,
      DateTime fechaDeInicio,
      DateTime fechaDeFin,
      String idAsignatura) async {
    // Obtén los nuevos valores
    String newName = name.text;
    DateTime newStartDate = fechaDeInicio;
    DateTime newEndDate = fechaDeFin;
    String newIdAsignatura = idAsignatura;

    // Aquí puedes realizar cualquier operación necesaria antes de regresar,
    // como actualizar en la base de datos, etc.

    // Simplemente imprimo los nuevos valores para demostración
    updateAsignatura(
        idAsignatura: int.parse(newIdAsignatura),
        nombre: newName,
        fechaDeInicio: newStartDate,
        fechaDeFin: newEndDate);

    print('Nuevo nombre: $newName');
    print('Nueva fecha de inicio: $newStartDate');
    print('Nueva fecha de finalización: $newEndDate');
    print(idAsignatura);

    // Puedes agregar aquí cualquier navegación que necesites, como Navigator.pop()
    Navigator.pop(context); // Ejemplo de regresar a la pantalla anterior
  }
}
