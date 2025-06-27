import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/global.dart';
import 'package:aprendiz/widgets/Bottomapp.dart';
import 'package:aprendiz/widgets/Menu.dart';
import 'package:aprendiz/widgets/topodapagina.dart';
import 'package:flutter/material.dart';

class Modulos extends StatefulWidget {
  @override
  State<Modulos> createState() => _ModulosState();
}

class _ModulosState extends State<Modulos> {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.nightMode == true
          ? AppColors.prin2
          : AppColors.prin1,
      appBar: Toppagina(
        cor4: Global.nightMode == true
          ? AppColors.prin1
          : AppColors.prin2,
      ),
      bottomNavigationBar:
          BottomApp(context: context, cor3: Global.nightMode == true
          ? AppColors.prin1
          : AppColors.prin2, ismenu: true),
      body: Menu(),
    );
  }
}
