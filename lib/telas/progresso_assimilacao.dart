import 'package:aprendiz/Atividades/Assimilacao1.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/widgets/Bottomapp.dart';
import 'package:aprendiz/widgets/button.dart';

import 'package:aprendiz/widgets/topodapagina.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaAssimilacao(),
    );
  }
}

class TelaAssimilacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toppagina(cor4: AppColors.y2),
      backgroundColor: AppColors.y1,
      bottomNavigationBar:
          BottomApp(context: context, cor3: AppColors.y2, ismenu: false),
      body: Center(
        child: SizedBox(
            width: 270, // Defina a largura desejada
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Button(
                      mainaxisA: MainAxisAlignment.center,
                      context: context,
                      Icone: Icons.star,
                      cor: 3,
                      cor2: 3,
                      pathAtividade: AssimilacaoActivity()),
                  SizedBox(height: 40),
                  
                ],
              ),
            )),
      ),
    );
  }
}
