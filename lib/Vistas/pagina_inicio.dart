import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';

class PaginaInicio extends StatelessWidget {
  const PaginaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    //final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: appBar(context, "Study Sphere"),
      floatingActionButton: menu(colorScheme),
    );
  }
}

menu(ColorScheme colorScheme) => FloatingActionButton(
      onPressed: () => something(),
      elevation: 2,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      isExtended: true,
      child: const Icon(Icons.add),
    );

something() => print("hace cositas");
