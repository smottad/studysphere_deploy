import 'package:flutter/material.dart';

AppBar appBar(BuildContext context, String titulo,
    {int color = 0, bool menu = false}) {
  Color colorTexto = Theme.of(context).colorScheme.onPrimary;
  Color colorBar = Theme.of(context).colorScheme.primary;
  if (color == 1) {
    colorTexto = Theme.of(context).colorScheme.onSecondary;
    colorBar = Theme.of(context).colorScheme.secondary;
  } else if (color == 2) {
    colorTexto = Theme.of(context).colorScheme.onTertiary;
    colorBar = Theme.of(context).colorScheme.tertiary;
  }
  Widget? leading;
  if (menu) {
    leading = Builder(builder: (BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      );
    });
  }
  return AppBar(
    leading: leading,
    titleTextStyle:
        Theme.of(context).textTheme.headlineMedium?.copyWith(color: colorTexto),
    backgroundColor: colorBar,
    foregroundColor: colorTexto,
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
