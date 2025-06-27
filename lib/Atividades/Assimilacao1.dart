import 'package:audioplayers/audioplayers.dart';
import 'package:aprendiz/telas/progresso_assimilacao.dart';
import 'package:aprendiz/transitions/Transicao.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/widgets/topodapagina.dart';
import 'package:flutter/material.dart';

class AssimilacaoActivity extends StatefulWidget {
  @override
  _AssimilacaoActivityState createState() => _AssimilacaoActivityState();
}

class _AssimilacaoActivityState extends State<AssimilacaoActivity> {
  // Variáveis-----------------------------------------------------------------------------------
  bool isPlaying = false;
  AudioPlayer? _player;
  String? _currentAudio;
  int? selectedAudioIndex;
  int? selectedImageIndex;
  List<bool> acertos = [false, false, false, false];
  List<bool> erros = [false, false, false, false];
  final List<Map<String, String>> pares = [
    {
      'imagem1': 'assets/imagens/vaca.png',
      'imagem2': 'assets/imagens/grama.png',
    },
    {
      'imagem1': 'assets/imagens/gato.png',
      'imagem2': 'assets/imagens/peixe.png',
    },
    {
      'imagem1': 'assets/imagens/cachorro.png',
      'imagem2': 'assets/imagens/osso.png',
    },
    {
      'imagem1': 'assets/imagens/galinha.png',
      'imagem2': 'assets/imagens/milho.png',
    },
  ];
  void setIsPlaying(bool value) {
    setState(() {
      isPlaying = value;
    });
  }

  @override
  //Funções------------------------------------------------------------------------------------
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  void verificaAcertos() {
    if (acertos.every((a) => a)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.y2,
          title: Text(
            'Parabéns!',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          content: Text(
            'Você acertou todos os pares!',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.y3,
              ),
              onPressed: () {
                _player?.stop();
                Transicao(context, TelaAssimilacao());
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
  }

  Future<void> handleAudio(String audioPath, Function()? onAudioStart,
      Function()? onAudioEnd) async {
    if (_player != null && isPlaying && _currentAudio == audioPath) {
      await _player!.stop();
      setState(() {
        isPlaying = false;
        _currentAudio = null;
      });
      onAudioEnd?.call();
      return;
    }

    _player?.dispose();
    _player = AudioPlayer();
    setState(() {
      isPlaying = true;
      _currentAudio = audioPath;
    });
    onAudioStart?.call();
    await _player!.play(AssetSource(audioPath));
    await _player!.onPlayerComplete.first;
    setState(() {
      isPlaying = false;
      _currentAudio = null;
    });
    onAudioEnd?.call();
  }

  //Código------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.y1,
        appBar: Toppagina(
          cor4: AppColors.y2,
        ),
        body: Container(
            color: AppColors.y1,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.y2,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.y1, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("O que cada animal come?",
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: "Oilvare",
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                          IconButton(
                            icon:
                                Icon(Icons.spatial_audio, color: Colors.white),
                            onPressed: () async {
                              final player = AudioPlayer();
                              await player.play(
                                  AssetSource('audios/Assimilacao_1.mp3'));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Coluna dos áudios
                        Column(
                          children: List.generate(pares.length, (i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Buttonass(
                                SizedBox(
                                  height: 50,
                                  child: Image.asset(pares[i]['imagem1']!,
                                      fit: BoxFit.cover),
                                ),
                                pares[i]['imagem1']!,
                                isPlaying: isPlaying &&
                                    _currentAudio == pares[i]['imagem1'],
                                setIsPlaying: setIsPlaying,
                                player: _player,
                                currentAudio: _currentAudio,
                                handleAudio: handleAudio,
                                // Adicione destaque se selecionado ou acertou
                                color: acertos[i]
                                    ? Colors.green
                                    : (erros[i]
                                        ? Colors.red
                                        : (selectedAudioIndex == i
                                            ? Colors.blue
                                            : AppColors.y2)),
                                onTap: () {
                                  setState(() {
                                    selectedAudioIndex = i;
                                    if (selectedImageIndex != null) {
                                      if (selectedAudioIndex ==
                                          selectedImageIndex) {
                                        acertos[i] = true;
                                        verificaAcertos();
                                      } else {
                                        erros[i] = true;
                                        // Limpa o erro após 1 segundo
                                        Future.delayed(Duration(seconds: 1),
                                            () {
                                          setState(() {
                                            erros[i] = false;
                                          });
                                        });
                                      }
                                      selectedAudioIndex = null;
                                      selectedImageIndex = null;
                                    }
                                  });
                                },
                              ),
                            );
                          }),
                        ),
                        // Coluna das imagens
                        Column(
                          children: List.generate(pares.length, (i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Buttonass2(
                                SizedBox(
                                  height: 50,
                                  child: Image.asset(pares[i]['imagem2']!,
                                      fit: BoxFit.cover),
                                ),
                                color: acertos[i]
                                    ? Colors.green
                                    : (erros[i]
                                        ? Colors.red
                                        : (selectedImageIndex == i
                                            ? Colors.blue
                                            : AppColors.y2)),
                                onTap: () {
                                  setState(() {
                                    selectedImageIndex = i;
                                    if (selectedAudioIndex != null) {
                                      if (selectedAudioIndex ==
                                          selectedImageIndex) {
                                        acertos[i] = true;
                                        verificaAcertos();
                                      } else {
                                        erros[i] = true;
                                        Future.delayed(Duration(seconds: 1),
                                            () {
                                          setState(() {
                                            erros[i] = false;
                                          });
                                        });
                                      }
                                      selectedAudioIndex = null;
                                      selectedImageIndex = null;
                                    }
                                  });
                                },
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ))));
  }
}

Buttonass(
  Widget icone,
  String audioPath, {
  required bool isPlaying,
  required Function(bool) setIsPlaying,
  AudioPlayer? player,
  String? currentAudio,
  required void Function(
          String, Function()? onAudioStart, Function()? onAudioEnd)
      handleAudio,
  Color color = AppColors.y2,
  VoidCallback? onTap,
}) {
  return ElevatedButton(
    onPressed: () {
      if (onTap != null) onTap();
      if (isPlaying && currentAudio == audioPath) {
        player?.stop();
        setIsPlaying(false);
      } else if (!isPlaying) {
        handleAudio(
          audioPath,
          () => setIsPlaying(true),
          () => setIsPlaying(false),
        );
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.all(0),
      shadowColor: Colors.transparent,
    ),
    child: Container(
      height: 80,
      width: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.y1, width: 2),
      ),
      child: Center(child: icone),
    ),
  );
}

Buttonass2(
  Widget icone, {
  Color color = AppColors.y2,
  VoidCallback? onTap,
}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.all(0),
      shadowColor: Colors.transparent,
    ),
    child: Container(
      height: 80,
      width: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.y1, width: 2),
      ),
      child: Center(child: icone),
    ),
  );
}
