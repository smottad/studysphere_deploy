import 'package:flutter/material.dart';
import 'package:group_select/components/group_select.dart';
import 'package:group_select/controllers/select_group_controller.dart';

class CardPregunta extends StatefulWidget {
  const CardPregunta({
    super.key,
    required this.pregunta,
    required this.respuestas,
    required this.id,
    required this.itemCallback,
  });

  final String pregunta;
  final List<dynamic> respuestas;
  final int id;
  final Function itemCallback;

  @override
  State<CardPregunta> createState() => _CardPreguntaState();
}

class _CardPreguntaState extends State<CardPregunta> {
  final controller = SelectGroupController<String>(
    multiple: false,
    dark: false,
  );

  List<String> ansValues = ['a', 'b', 'c', 'd'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.7,
      child: Column(
        children: [
          Card(
            child: GroupSelect<String>(
              title: widget.pregunta,
              activeColor: Colors.green.shade800,
              controller: controller,
              onChange: (values) {
                widget.itemCallback(widget.id, values);
                print(values);
              },
              items: [
                for (int i = 0; i < widget.respuestas.length; i++) Item(title: '${ansValues[i]}) ${widget.respuestas[i]}', value: ansValues[i])
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}