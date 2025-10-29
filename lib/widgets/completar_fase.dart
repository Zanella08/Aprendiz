import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:just_audio/just_audio.dart';
import 'package:aprendiz/transitions/Transicao.dart';
import 'package:aprendiz/telas/progresso_audicao.dart';
import 'package:aprendiz/telas/progresso_fala.dart';
import 'package:aprendiz/telas/progresso_assimilacao.dart';
import 'package:aprendiz/telas/progresso_memoria.dart';
import 'package:aprendiz/utils/Style.dart';

Future<void> completarFase(
  BuildContext context,
  String modulo,
  String texto1,
  String texto2,
) async {
  final player = AudioPlayer();
  final confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  // Determina a cor base conforme o módulo
  final Color corFundo = modulo == '1'
      ? AppColors.v2
      : modulo == '2'
          ? AppColors.b1
          : modulo == '3'
              ? AppColors.y2
              : AppColors.g2;

  final Color corBotao = modulo == '1'
      ? AppColors.v3
      : modulo == '2'
          ? AppColors.b2
          : modulo == '3'
              ? AppColors.y3
              : AppColors.g3;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      confettiController.play();
      player.setAsset('assets/audios/completa.mp3');
      player.play();

      Future.delayed(const Duration(seconds: 3), () {
        confettiController.stop();
        // Após a celebração, avança automaticamente
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
      });

      return Stack(
        alignment: Alignment.center,
        children: [
          AlertDialog(
            backgroundColor: corFundo,
            title: Text(
              texto1,
              style: const TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.center,
            ),
            content: Text(
              texto2,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),

          // Confete animado
          Positioned.fill(
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.08,
              numberOfParticles: 20,
              colors: [Colors.white, corBotao, Colors.amber, Colors.pinkAccent],
            ),
          ),

          // Mascote com animação suave
          Positioned(
            bottom: 20,
            right: 20,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) => Transform.scale(
                scale: value,
                child: Opacity(opacity: value, child: child),
              ),
              child: Image.asset(
                'assets/imagens/doey.png', // substitua pelo seu caminho
                height: 120,
              ),
            ),
          ),
        ],
      );
    },
  );

  confettiController.dispose();
  player.dispose();
}
