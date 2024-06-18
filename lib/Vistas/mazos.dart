import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/card_mazos.dart';
import 'package:studysphere/Servicios/servicio_mazo.dart';
import 'package:studysphere/Controladores/controlador_ver_mazos.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

ServicioBaseDatosMazo dbMazo = ServicioBaseDatosMazo();

class VerMazos extends StatelessWidget {
  const VerMazos({super.key});

  @override 
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: appBar(context, "Mazos"),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          goToCrearMazo(context);
        }, 
        icon: Icon(
          Icons.add,
          color: colorScheme.shadow,
        ), 
        label: Text(
          "Crear mazo",
          style: TextStyle(
            color: colorScheme.shadow,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
        ),       
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,  
        child: FutureBuilder<List<Mazo>>(
          future: dbMazo.traerMazos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator(),
                ) 
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No se encontraron mazos'));
            } else {
              final mazos = snapshot.data!;
              print(mazos);
              return Column( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Wrap(
                      spacing: 10,
                      // runAlignment: WrapAlignment.center,
                      // crossAxisAlignment: WrapCrossAlignment.center,
                      children: mazos.map((mazo) {
                        return CardMazo(
                          idMaze: mazo.id,
                          nameMaze: mazo.nombreMazo, 
                          idSubject: mazo.idAsignaturaMazo,
                          subjectMaze: mazo.nombreAsignaturaMazo,
                        );
                      }).toList(),
                    ),
                  ),
                ]
              );
            }
          }),
        ), 
        
    );
  }
}