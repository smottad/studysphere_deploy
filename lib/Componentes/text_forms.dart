import 'package:flutter/material.dart';

Padding textFormulario(
        BuildContext context, TextEditingController controller, String label,
        {bool oscurecer = false,
        double padding = 6.0,
        TextInputType? teclado,
        Function? funcion}) =>
    Padding(
      padding: EdgeInsets.all(padding),
      child: SizedBox(
        width: (MediaQuery.of(context).size.width * 0.7).clamp(200, 500),
        child: TextFormField(
          onTap: () {
            funcion!(context);
          },
          autocorrect: !oscurecer,
          controller: controller,
          obscureText: oscurecer,
          obscuringCharacter: '*',
          keyboardType: teclado,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
    );
