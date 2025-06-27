import 'package:aprendiz/utils/Style.dart';
import 'package:flutter/material.dart';

Button2(
    {required MainAxisAlignment mainaxisA,
    required BuildContext context,
    required int cor,
    required int cor2}) {
  return Row(
    mainAxisAlignment: mainaxisA,
    mainAxisSize: MainAxisSize.max,
    children: [
      ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Erro'),
              content: Text('Atividade não disponível'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        },
        child: Image.asset(
          'assets/imagens/trophy.png',
          color: Colors.white,
          width: 30,
          height: 30,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: cor2 == 1
              ? AppColors.v2
              : cor2 == 2
                  ? AppColors.b2
                  : cor2 == 3
                      ? AppColors.y2
                      : AppColors.g2,
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          shadowColor: cor == 1
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
