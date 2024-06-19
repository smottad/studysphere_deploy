import 'package:flutter/material.dart';

class TextCodigo extends StatelessWidget {
  const TextCodigo({super.key, required this.validator});

  final TextEditingController validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width * 0.2).clamp(1, 60),
      child: TextFormField(
        controller: validator,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ), 
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ), 
        ),
        cursorColor: Colors.black,
      ),
    );
  }
}