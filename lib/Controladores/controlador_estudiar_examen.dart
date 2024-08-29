import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = 'AIzaSyAxg5KeMatnDubQEJbLhyCE_hRSNEDSuTA';

class ExamenArgs {
  ExamenArgs({
    required this.nombreMateria,
    this.idMateria,
    this.dificultad,
    this.tiempo,
    this.temas,
  });

  String nombreMateria;
  String? idMateria;
  String? dificultad;
  int? tiempo;
  List<String>? temas;
}

Future<Map> generacionExamen(String temas, String dificultad) async {
  if (apiKey == null) {
    print("No API KEY");
    exit(1);
  }

  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  final content = [Content.text("Escribir un exámen de dificultad $dificultad con los siguientes temas: $temas, que tenga 10 preguntas de selección multiple y cada una con 4 respuestas, con las respuestas al final, estas últimas mostrando solo la letra sin negrilla.")];
  final response = await model.generateContent(content);
  RegExp exp = RegExp(r'(a)');

  var list = response.text!.split('\n');
  var examList = {};
  var auxListAns = [];
  var answerList = [];
  int numAns = 0;
  int numQ = 0;

  for(int i = 0; i < list.length; i++) {
    var auxList = list[i].split('');
    // print(auxList);
    if(auxList.isNotEmpty) {
      if(auxList[0] == "#") {
        examList['titulo'] = list[i].substring(3);
      } else if(auxList[0] == '*') {
        var auxList2 = [];
        // print(list[i].split('**'));
        for(var item in list[i].split('**')) {
          if (item != '' && item != ' ') {
            auxList2.add(item.trim());
          }
        }
        if  (auxList2.length > 1) {
          examList['instrucciones'] = auxList2[1];
        } else if (auxList2.length <= 1 && numQ < 10) {
          examList['pregunta${numQ + 1}'] = auxList2[0];
          numQ = numQ + 1;
        } else {
          examList['respuestas'] = [];
        }
        
      } else if (auxList[0] == 'a' || auxList[0] == 'b' || auxList[0] == 'c' || auxList[0] == 'd') {
        // print(list[i].split('${auxList[0]}) '));
        auxListAns.add(list[i].split('${auxList[0]}) ')[1].trim());
        numAns = numAns + 1;
      } else if (auxList[0] == '1' && auxList[1] == '0') {
        var auxList3 = list[i].split('${auxList[0]}${auxList[1]}. ');
        answerList.add(auxList3[1].trim());
        print(auxList3);
        answerList.add(auxList3[1]);
      } else if (auxList[0] == '1' || auxList[0] == '2' || auxList[0] == '3' || auxList[0] == '4' || auxList[0] == '5' || auxList[0] == '6' || auxList[0] == '7' || auxList[0] == '8' || auxList[0] == '9') {
        var auxList3 = list[i].split('${auxList[0]}. ');
        print(auxList3);
        if (auxList3.length > 1) {
          answerList.add(auxList3[1].trim());
        }
      }

      if (numAns == 4) {
        examList['respuestas$numQ'] = auxListAns;
        auxListAns = [];
        numAns = 0;
      }
    }
  }

  examList['respuestas'] = answerList;

  examList.forEach((key, value) {
    print('$key: $value');
  });
  // for(int i = 0; i < examList.length; i++) {
  //   print('Item $i: ${examList[i]}');
  // }

  return examList;
}