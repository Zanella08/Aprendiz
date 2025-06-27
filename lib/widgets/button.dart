import 'package:aprendiz/transitions/Transicao.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/global.dart';
import 'package:aprendiz/widgets/Bottomapp.dart';
import 'package:flutter/material.dart';

Button({
  required MainAxisAlignment mainaxisA,
  required BuildContext context,
  required IconData Icone,
  required int cor,
  required int cor2,
  required Widget pathAtividade,
}) {
  return Row(
    mainAxisAlignment: mainaxisA,
    mainAxisSize: MainAxisSize.max,
    children: [
      ElevatedButton(
        onPressed: () {
          Transicao(context, pathAtividade);
        },
        child: Icon(Icone, color: Colors.white, size: 30),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              cor2 == 1
                  ? AppColors.v2
                  : cor2 == 2
                  ? AppColors.b2
                  : cor2 == 3
                  ? AppColors.y2
                  : AppColors.g2,
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          shadowColor:
              cor == 1
                  ? AppColors.v3
                  : cor == 2
                  ? AppColors.b3
                  : cor == 3
                  ? AppColors.y3
                  : AppColors.g3,
        ),
      ),
    ],
  );
}
