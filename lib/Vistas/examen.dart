import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';

class PaginaExamen extends StatelessWidget {
  const PaginaExamen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    //final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(context, "Study Sphere", menu: true),
      backgroundColor: colorScheme.surface,
    );
  }
}
