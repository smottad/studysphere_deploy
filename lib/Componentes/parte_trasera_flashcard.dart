import 'package:flutter/material.dart';

class BackFlashcard extends StatelessWidget {
  const BackFlashcard({
    super.key,
    required this.respuesta,
    required this.itemCallback,
  });

  final String respuesta;
  final ValueChanged<String> itemCallback;

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
   
    return SizedBox(
      width: size.width * 0.2,
      height: size.height * 0.6,
      child: Card(
        shadowColor: colors.scrim,
        elevation: 10,
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        color: colors.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Title(
                color: colors.onPrimary,
                child: const Text(
                  "Respuesta",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                respuesta,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colors.tertiary,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10)
                    ),
                  ),
                  child: TextButton(
                    onPressed: () => itemCallback("Hola"), 
                    child: Text(
                      "Volver", 
                      style: TextStyle(
                        color:  colors.tertiary
                      ),
                    )
                  ),
                ),
              ),
            ],
          ),   
        ),          
      ),
    );
  }
}