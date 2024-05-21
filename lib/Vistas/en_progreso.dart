import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';

class EnProgreso extends StatelessWidget {
  const EnProgreso({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: appBar(context, "Study Sphere"),
      body: Center(
        child: Text(
          'Aquí no hay nada aún',
          style:
              textTheme.displayLarge?.copyWith(color: colorScheme.onBackground),
        ),
      ),
    );
  }
}
