import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Controladores/controlador_ajustes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Ajustes extends StatelessWidget {
  const Ajustes({super.key});

  @override
  Widget build(BuildContext context) {
    Color colorText = Theme.of(context).colorScheme.onPrimary;
    Color backgroundBtn = Theme.of(context).colorScheme.secondary;

    // Función para cerrar sesión
    cerrarSesion() async {
      try {
        final supabase = Supabase.instance.client;

        final response = await supabase.auth.signOut();

        // Manejar el error
        print("Error al cerrar sesión");

        // Navegar a la pantalla de inicio de sesión
        Navigator.of(context).pushReplacementNamed('/');
      } catch (e) {
        // Manejar la excepción
        print("Error al cerrar sesión: $e");
      }
    }

    return Scaffold(
      appBar: appBar(context, "Ajustes", color: 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundBtn,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onPressed: () => irEditProfile(context),
              child: Text(
                "Editar perfil",
                style: TextStyle(
                  color: colorText,
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundBtn,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onPressed: cerrarSesion,
              child: Text(
                "Cerrar sesión",
                style: TextStyle(
                  color: colorText,
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
