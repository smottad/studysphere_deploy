import 'package:flutter/material.dart';

Padding textFormulario(
        BuildContext context, TextEditingController controller, String label,
        {bool oscurecer = false,
        double padding = 6.0,
        TextInputType? teclado,
        Function? funcion,
        String? Function(String?)? validator,}) =>
    Padding(
      padding: EdgeInsets.all(padding),
      child: SizedBox(
        width: (MediaQuery.of(context).size.width * 0.8).clamp(200, 500),
        child: TextFormField(
          onTap: () {
            funcion?.call(context);
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          autocorrect: !oscurecer,
          controller: controller,
          obscureText: oscurecer,
          obscuringCharacter: '*',
          keyboardType: teclado,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
    );
