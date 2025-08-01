import 'package:audioplayers/audioplayers.dart';
import 'package:aprendiz/telas/progresso_Memoria.dart';
import 'package:aprendiz/transitions/Transicao.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/widgets/topodapagina.dart';
import 'package:flutter/material.dart';

class MemoriaActivity extends StatefulWidget {
  @override
  _MemoriaActivityState createState() => _MemoriaActivityState();
}

class _MemoriaActivityState extends State<MemoriaActivity> {
  // Variáveis-----------------------------------------------------------------------------------
  String ok = "n";
  bool certo = false;
  bool isPlaying = false;
  AudioPlayer? _player;
  String? _currentAudio;
  int? selectedAudioIndex;
  int? selectedImageIndex;

  void setIsPlaying(bool value) {
    setState(() {
      isPlaying = value;
    });
  }

  @override
  //Funções------------------------------------------------------------------------------------
  void mostrarResultado(bool acertou) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.g2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              acertou ? "Parabéns!" : "Que pena!",
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Oilvare",
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: Text(
              acertou
                  ? "Você acertou! Muito bem!"
                  : "Você errou dessa vez, quer tentar de novo?",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Oilvare",
                color: Colors.white,
              ),
            ),
            actions: [
              if (!acertou)
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: AppColors.g3),
                  onPressed: () {
                    Transicao(context, MemoriaActivity());
                    setState(() {
                      ok = "n";
                      selectedAudioIndex = null;
                      selectedImageIndex = null;
                    });
                  },
                  child: Text(
                    'Sim',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.g3,
                  textStyle: TextStyle(fontSize: 15, color: Colors.white),
                ),
                onPressed: () {
                  if (acertou) {
                    Transicao(context, TelaMemoria());
                  } else {
                    Transicao(context, TelaMemoria());
                  }
                },
                child: Text(
                  acertou ? 'Avançar' : 'Não',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  Future<void> handleAudio(
    String audioPath,
    Function()? onAudioStart,
    Function()? onAudioEnd,
  ) async {
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
      backgroundColor: AppColors.g1,
      appBar: Toppagina(cor4: AppColors.g2),
      body: Container(
        color: AppColors.g1,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              if (ok == "n") ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.g2,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.g1, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Conte a quantidade de \n vaquinhas e de galinhas",
                        style: TextStyle(
                          fontSize: 26,
                          fontFamily: "Oilvare",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.spatial_audio, color: Colors.white),
                        onPressed: () async {
                          final player = AudioPlayer();
                          await player.play(
                            AssetSource('audios/Memoria_1.mp3'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.g2,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.g1, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quantas vaquinhas \n você viu?",
                        style: TextStyle(
                          fontSize: 26,
                          fontFamily: "Oilvare",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.spatial_audio, color: Colors.white),
                        onPressed: () async {
                          final player = AudioPlayer();
                          await player.play(
                            AssetSource('audios/Memoria_2.mp3'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 50),
                  if (ok == "n") ...[
                    SizedBox(
                      width: 300,
                      child: Image.asset(
                        'assets/imagens/Fazenda.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.g2,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: AppColors.g1, width: 2),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          ok == "n" ? ok = "s" : ok = "n";
                          selectedAudioIndex = null;
                          selectedImageIndex = null;
                        });
                      },
                      child: Container(
                        width: 120,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "Pronto!",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "Oilvare",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.g2,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: AppColors.g1,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                mostrarResultado(false);
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                alignment: Alignment.center,
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontFamily: "Oilvare",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20, width: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.g2,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: AppColors.g1,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                mostrarResultado(false);
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                alignment: Alignment.center,
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontFamily: "Oilvare",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.g2,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: AppColors.g1,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                mostrarResultado(false);
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                alignment: Alignment.center,
                                child: Text(
                                  "3",
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontFamily: "Oilvare",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20, width: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.g2,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: AppColors.g1,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                mostrarResultado(true);
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                alignment: Alignment.center,
                                child: Text(
                                  "4",
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontFamily: "Oilvare",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
    String,
    Function()? onAudioStart,
    Function()? onAudioEnd,
  )
  handleAudio,
  Color color = AppColors.g2,
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
        border: Border.all(color: AppColors.g1, width: 2),
      ),
      child: Center(child: icone),
    ),
  );
}

Buttonass2(Widget icone, {Color color = AppColors.g2, VoidCallback? onTap}) {
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
        border: Border.all(color: AppColors.g1, width: 2),
      ),
      child: Center(child: icone),
    ),
  );
}
