import 'package:flutter/material.dart';

Padding textFormulario(
        BuildContext context, TextEditingController controller, String label,
        {bool oscurecer = false}) =>
    Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        width: (MediaQuery.of(context).size.width * 0.7).clamp(200, 500),
        child: TextField(
          autocorrect: !oscurecer,
          controller: controller,
          obscureText: oscurecer,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
    );
