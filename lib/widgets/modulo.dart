import 'package:aprendiz/telas/progresso_assimilacao.dart';
import 'package:aprendiz/telas/progresso_audicao.dart';
import 'package:aprendiz/telas/progresso_fala.dart';
import 'package:aprendiz/telas/progresso_memoria.dart';
import 'package:aprendiz/transitions/Transicao.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/global.dart';
import 'package:flutter/material.dart';

Widget modulo({
  required int expandedIndex,
  required Function toggleContainer,
  required image,
  required String titulo,
  required Color cor,
  required Color cor2,
  required int cor3,
  required BuildContext context,
  required String descricao,
}) {
  return Container(
    height: 150,
    width: 150,
    decoration: BoxDecoration(
      color: cor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.all(16),
            minimumSize: Size(60, 60),
          ),
          onPressed: () {
            Global.color = cor3;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: cor,
                  content: Container(
                    height: 350,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        image,
                        SizedBox(height: 10),
                        Text(
                          titulo,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          descricao,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cor2,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.all(16),
                          minimumSize: Size(60, 60),
                        ),
                        onPressed: () {
                          Global.color = expandedIndex + 1;
                          Transicao(
                            context,
                            cor == AppColors.v1
                                ? TelaAudicao()
                                : cor == AppColors.b1
                                ? TelaFala()
                                : cor == AppColors.y1
                                ? TelaAssimilacao()
                                : TelaMemoria(),
                          );
                        },
                        child: Text(
                          "Ir para a atividade",
                          style: AppText.bases,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cor2, // Cor do botão de fechar
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.all(16),
                          minimumSize: Size(60, 60),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Fecha o popup
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                );
              },
            );
          },
          child: Column(
            children: [
              image,
              SizedBox(height: 10),
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
