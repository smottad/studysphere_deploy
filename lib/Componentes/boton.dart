import 'package:flutter/material.dart';

Padding boton(BuildContext context, String texto, Function funcion) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => funcion(context),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              //el secondary container es verde en el tema que puse
              Theme.of(context).colorScheme.secondaryContainer,
          elevation: 2,
          fixedSize: Size.fromWidth(MediaQuery.of(context).size.width / 2),
          maximumSize: const Size.fromWidth(300),
        ),
        child: Center(
          child: Text(
            texto,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
        ),
      ),
    );
