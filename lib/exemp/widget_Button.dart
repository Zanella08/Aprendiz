import 'package:flutter/material.dart';

widgetButton() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              disabledBackgroundColor: Colors.red,
              elevation: 20),
          onPressed: () => exibirtexto("oi, o botão foi apertado(lá ele)"),
          child: Text("ElevatedButton Ativo")),
    ],
  );
}

void exibirtexto(String msg) {
  print(msg);
}
