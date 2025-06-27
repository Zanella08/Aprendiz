import 'package:aprendiz/Atividades/Audicao1.dart';
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
      home: TelaAudicao(),
    );
  }
}

class TelaAudicao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toppagina(cor4: AppColors.v2),
      backgroundColor: AppColors.v1,
      bottomNavigationBar:
          BottomApp(context: context, cor3: AppColors.v2, ismenu: false),
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
                      cor: 1,
                      cor2: 1,
                      pathAtividade: AudicaoActivity()),
                  SizedBox(height: 40),
                 
                  
                ],
              ),
            )),
      ),
    );
  }
}
