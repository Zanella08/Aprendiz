import 'package:aprendiz/telas/progresso_assimilacao.dart';
import 'package:aprendiz/telas/progresso_audicao.dart';
import 'package:aprendiz/telas/progresso_fala.dart';
import 'package:aprendiz/telas/progresso_memoria.dart';
import 'package:aprendiz/transitions/Transicao.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

completar_fase(String modulo, String texto1) async {
  var context;

  // Toca o áudio ao abrir o diálogo
  final player = AudioPlayer();
  await player.play(AssetSource('assets/audio/completa.mp3'));

  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor:
              modulo == '1'
                  ? AppColors.v2
                  : modulo == '2'
                  ? AppColors.b2
                  : modulo == '3'
                  ? AppColors.y2
                  : AppColors.g2,
          title: Text(
            'Parabéns!',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          content: Text(
            texto1,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    modulo == '1'
                        ? AppColors.v3
                        : modulo == '2'
                        ? AppColors.b3
                        : modulo == '3'
                        ? AppColors.y3
                        : AppColors.g3,
              ),
              onPressed: () {
                Transicao(
                  context,
                  modulo == '1'
                      ? TelaAudicao()
                      : modulo == '2'
                      ? TelaFala()
                      : modulo == '3'
                      ? TelaAssimilacao()
                      : TelaMemoria(),
                );
              },
              child: Text(
                'Continuar',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
  );
}
