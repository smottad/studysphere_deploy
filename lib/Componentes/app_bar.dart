import 'package:flutter/material.dart';

AppBar appBar(BuildContext context, String titulo, {int color = 0}) {
  Color colorTexto = Theme.of(context).colorScheme.onPrimary;
  Color colorBar = Theme.of(context).colorScheme.primary;
  if (color == 1) {
    colorTexto = Theme.of(context).colorScheme.onSecondary;
    colorBar = Theme.of(context).colorScheme.secondary;
  } else if (color == 2) {
    colorTexto = Theme.of(context).colorScheme.onTertiary;
    colorBar = Theme.of(context).colorScheme.tertiary;
  }
  return AppBar(
    titleTextStyle:
        Theme.of(context).textTheme.headlineLarge?.copyWith(color: colorTexto),
    backgroundColor: colorBar,
    elevation: 2,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(titulo),
        const Spacer(),
        const Image(
          alignment: Alignment.centerRight,
          image: AssetImage("lib/Assets/logo.png"),
          fit: BoxFit.contain,
          height: 55,
        ),
      ],
    ),
  );
}
