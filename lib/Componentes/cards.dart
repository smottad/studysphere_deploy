import 'package:flutter/material.dart';

Padding cards(
    BuildContext context, IconData icon, String text, Function funcion) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      color: colorScheme.primary,
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: InkWell(
        onTap: () => funcion(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: colorScheme.onPrimary,
              ),
              const Spacer(),
              Text(
                text,
                style: textTheme.headlineLarge
                    ?.copyWith(color: colorScheme.onPrimary),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    ),
  );
}
