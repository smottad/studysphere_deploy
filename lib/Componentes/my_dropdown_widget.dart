import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyDropdownWidget extends StatefulWidget {
  const MyDropdownWidget({super.key, required this.asignaturas, required this.hintText, required this.currentItem, required this.itemCallback, required this.idCurrentItem});

  final Map<String, int> asignaturas;
  final String hintText;
  final String currentItem;
  final ValueChanged<String> itemCallback;
  final int idCurrentItem;

  @override
  State<StatefulWidget> createState() => _DropdownState(currentItem, idCurrentItem);
}

class _DropdownState extends State<MyDropdownWidget> {
  _DropdownState(this.currentItem, this.idCurrentItem);

  List<DropdownMenuItem<String>> dropDownItems = [];
  String currentItem;
  int idCurrentItem;

  @override
  void initState() {
    super.initState();
    for(String item in widget.asignaturas.keys) {
      dropDownItems.add(DropdownMenuItem(
        value: item,
        alignment: Alignment.center,
        child: Text(
          item,
        ),
      ));
    }
  }

  @override
  void didUpdateWidget(MyDropdownWidget oldWidget) {
    if(currentItem != widget.currentItem) {
      setState(() {
        currentItem = widget.currentItem;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      alignment: Alignment.center,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: 1,
          ),
        ),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      items: dropDownItems,
      value: currentItem,
      isExpanded: true,
      hint: Text(widget.hintText),
      onChanged: (value) {
        currentItem = value!;
        widget.itemCallback(currentItem);
      },
    );
  }
}