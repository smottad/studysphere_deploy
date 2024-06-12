import 'package:flutter/material.dart';

class ProfileText extends StatefulWidget {
  ProfileText({super.key, this.oscurecer = false, this.padding = 6.0, this.teclado, required this.controller, required this.label, this.validator = false, this.compareController,});

  bool oscurecer;
  final double padding;
  final TextInputType? teclado;
  final TextEditingController controller;
  final String label;
  final bool validator;
  final TextEditingController? compareController;

  @override
  State<ProfileText> createState() => ProfileTextState();
}

class ProfileTextState extends State<ProfileText> {
  bool habilitar = false;

  void cambiarAHabilitado () {
    if (habilitar) {
      setState(() {
        habilitar = false;
      });
    } else {
      setState(() {
        habilitar = true;
      });
    }
  }

  void mostrarContrasena () {
    if (widget.oscurecer) {
      setState(() {
        widget.oscurecer = false;
      });
    } else {
      setState(() {
        widget.oscurecer = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Row( 
        mainAxisSize: MainAxisSize.min, 
        children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.8).clamp(200, 500),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: !widget.oscurecer,
              controller: widget.controller,
              obscureText: widget.oscurecer,
              obscuringCharacter: '*',
              keyboardType: widget.teclado,
              enabled: habilitar,
              validator: (value) {
                if (widget.validator) {
                  if (widget.controller.text != widget.compareController?.text) {
                    return "Ambos campos deben coincidir";
                  } else {
                    return null;
                  }
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                labelText: widget.label,
                border: const OutlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),  
        ],
      ),
    );
  }
}