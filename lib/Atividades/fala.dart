import 'package:aprendiz/utils/levels.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/widgets/Bottomapp.dart';
import 'package:aprendiz/widgets/topodapagina.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class FalaActivity extends StatefulWidget {
  final int level;
  const FalaActivity({super.key, required this.level});

  @override
  State<FalaActivity> createState() => _FalaActivityState();
}

class _FalaActivityState extends State<FalaActivity> {
  late List<Map<String, dynamic>> currentLevel = [];
  late String theme = '';
  late List<Map<String, dynamic>> exercices = [];
  late List<String> userSpeaks = [];

  late bool isListening = false;
  final speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    currentLevel = fala[widget.level];
    theme = currentLevel[0]['theme'] ?? '';
    exercices = currentLevel.sublist(1);
    userSpeaks = List.generate(exercices.length, (_) => '');
  }

  void listen(int exercice) async {
    bool available = await speech.initialize(
      onStatus: (status) async {
        setState(() {
          isListening = status == "listening";
        });

        if (status == "listening") {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => AlertDialog(
                  title: Text("Te escutando"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/icons/Fala.png",
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: LinearProgressIndicator(),
                      ),
                    ],
                  ),
                ),
          );
        } else {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        }
      },
      onError: (error) {
        setState(() {
          isListening = false;
        });
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
    );

    if (available) {
      speech.listen(
        onResult: (result) {
          setState(() {
            userSpeaks[exercice] = result.recognizedWords;
          });

          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        },
        localeId: 'pt_BR',
      );
    }
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.b2,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.b1, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      theme,
                      style: TextStyle(
                        fontSize: 20,
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
                          AssetSource('audios/Fala_${widget.level}.mp3'),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ...exercices.asMap().entries.map((entry) {
                int index = entry.key;
                var exercice = entry.value;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.network(exercice['img'], width: 70, height: 70),
                          SizedBox(width: 10),
                          Text(
                            exercice['speak'],
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Oilvare",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed:
                            exercice['speak'] == userSpeaks[index]
                                ? null
                                : () => listen(index),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icons/Fala.png",
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "Falar",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Oilvare",
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
