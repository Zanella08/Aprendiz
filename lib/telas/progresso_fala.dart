import 'package:aprendiz/Atividades/fala/fala.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/levels.dart';
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
    return MaterialApp(debugShowCheckedModeBanner: false, home: TelaFala());
  }
}

class TelaFala extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toppagina(cor4: AppColors.b2),
      backgroundColor: AppColors.b1,
      bottomNavigationBar: BottomApp(
        context: context,
        cor3: AppColors.b2,
        ismenu: false,
      ),
      body: Center(
        child: SizedBox(
          width: 270, // Defina a largura desejada
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12.0,
              children: List.generate(fala.length, (index) {
                return Button(
                  mainaxisA: MainAxisAlignment.center,
                  context: context,
                  Icone: Icons.star,
                  cor: 4,
                  cor2: 4,
                  pathAtividade: FalaActivity(level: index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
