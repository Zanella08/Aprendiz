import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/widgets/modulos.dart';
import 'package:aprendiz/transitions/Transicao.dart';
import 'package:flutter/material.dart';

Widget BottomAppAtividade({
  required BuildContext context,
  required Color cor,
}) {
  return Container(
    height: 70, // Barra mais alta
    decoration: BoxDecoration(
      color: cor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    child: Stack(
      children: [
        // Botão de início
        Positioned(
          left: 30,
          bottom: 5,
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => warning(context, cor == AppColors.v2 ? AppColors.v2 : cor == AppColors.b2 ? AppColors.b2 : cor == AppColors.y2 ? AppColors.y2 : AppColors.g2),
              );
              
            },
            icon: Icon(Icons.home, color: Colors.white, size: 40),
          ),
        ),
        // Mascote pensand
      ],
    ),
  );
}

warning(BuildContext context, Color cor2) {
  return AlertDialog(
    backgroundColor: cor2,
    title: Text('Saindo da Atividade', style: TextStyle(color: Colors.white),),
    content: Text('Você realmente deseja sair?', style: TextStyle(color: Colors.white),),
    actions: [
      TextButton(
        onPressed: () {
          
          Transicao(context, Modulos()
          );
        },
        child: Text('Sim', style: TextStyle(color: Colors.white),),
      ),
      TextButton(onPressed: () => Navigator.pop(context), child: Text('Não', style: TextStyle(color: Colors.white),)),
    ],
  );
}