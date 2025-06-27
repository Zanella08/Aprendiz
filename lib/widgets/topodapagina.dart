import 'package:flutter/material.dart';

Toppagina({required cor4}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(70), // Define a altura do AppBar
    child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: cor4,
          borderRadius: BorderRadius.only(
            bottomLeft:
                Radius.circular(45), // Arredonda o canto inferior esquerdo
            bottomRight:
                Radius.circular(45), // Arredonda o canto inferior direito
          ),
        ),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor:
              Colors.transparent, // Torna o fundo do AppBar transparente
          elevation: 1,
          title: Container(
              child: SizedBox(
                  height: 50,
                  child: Image.asset(
                    "assets/imagens/aprendiz-b.png",
                    fit: BoxFit.cover,
                  ))),
        )),
  );
}
