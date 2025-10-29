import 'package:aprendiz/widgets/BottomAppAtividade.dart';
import 'package:aprendiz/widgets/completar_fase.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:aprendiz/utils/levels.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/widgets/topodapagina.dart';
import 'package:aprendiz/utils/desempenho_utils.dart'; // Adicione o import

enum SpeakStatus { none, success, error }

class Exercicio {
  final String speak;
  final String img;

  Exercicio({required this.speak, required this.img});

  factory Exercicio.fromMap(Map<String, dynamic> map) {
    return Exercicio(speak: map['speak'] ?? '', img: map['img'] ?? '');
  }
}

class FalaActivity extends StatefulWidget {
  final int level;
  const FalaActivity({super.key, required this.level});

  @override
  State<FalaActivity> createState() => _FalaActivityState();
}

class _FalaActivityState extends State<FalaActivity> {
  late String theme;
  late List<Exercicio> exercicios;
  int currentExercicio = 0;
  List<String> userSpeaks = [];
  SpeakStatus speakStatus = SpeakStatus.none;
  bool isListening = false;
  final stt.SpeechToText speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    final levelData = fala[widget.level];
    theme = levelData.first['theme'] ?? '';
    exercicios = levelData.sublist(1).map((e) => Exercicio.fromMap(e)).toList();
    userSpeaks = List.generate(exercicios.length, (_) => '2');
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.b1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Parabéns!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text("Você acertou!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
    );
  }

  Future<void> listen() async {
    if (isListening) return;

    final available = await speech.initialize(
      onStatus: (status) {
        if (!mounted) return;
        setState(() => isListening = status == 'listening');
      },
      onError: (_) {
        if (!mounted) return;
        setState(() {
          isListening = false;
          speakStatus = SpeakStatus.error;
        });
      },
    );

    if (!available || !mounted) return;

    setState(() {
      speakStatus = SpeakStatus.none;
      userSpeaks[currentExercicio] = '';
    });

    String capturedSpeech = '';

    await speech.listen(
      onResult: (result) {
        if (!mounted) return;
        capturedSpeech = result.recognizedWords.trim();
        setState(() => userSpeaks[currentExercicio] = capturedSpeech);
      },
      localeId: 'pt_BR',
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 2),
      partialResults: true,
      cancelOnError: true,
    );

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    await speech.stop();
    if (!mounted) return;

    setState(() => isListening = false);
    validarFala(capturedSpeech);
  }

  Future<void> validarFala(String captured) async {
    final esperado = exercicios[currentExercicio].speak.toLowerCase().trim();
    final falado = captured.toLowerCase().trim();

    if (falado == esperado) {
      registrarDesempenho('fala', true); // registra acerto
      setState(() => speakStatus = SpeakStatus.success);
      showSuccessDialog();
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pop(context); // fecha o dialog

      if (currentExercicio + 1 < exercicios.length) {
        setState(() {
          currentExercicio++;
          speakStatus = SpeakStatus.none;
        });
      } else {
        completarFase(context, "2", "Parabéns!", "Você completou a fase.");
      }
    } else {
      registrarDesempenho('fala', false); // registra erro
      setState(() => speakStatus = SpeakStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercicio = exercicios[currentExercicio];

    return Scaffold(
      appBar: Toppagina(cor4: AppColors.b2),
      backgroundColor: AppColors.b1,
      bottomNavigationBar: BottomAppAtividade(
        context: context,
        cor: AppColors.b2,
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
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
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: "Oilvare",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.spatial_audio, color: Colors.white),
                      onPressed: () async {
                        final player = AudioPlayer();
                        await player.play(AssetSource('audios/Fala_1.mp3'));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Image.network(exercicio.img),
              const SizedBox(height: 10),
              if (speakStatus == SpeakStatus.error)
                const Text("Tente denovo", style: TextStyle(color: AppColors.b3, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              isListening
                  ? const Text("Te escutando 😁", style: TextStyle(color: AppColors.b3, fontSize: 20, fontWeight: FontWeight.bold))
                  : ElevatedButton(
                      onPressed: listen,
                      child: const Text(
                        "Falar",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.b2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      // Mascote no canto inferior direito acima da barra
      floatingActionButton: Positioned(
        right: 0,
        bottom: 10, // ajuste para ficar acima da barra
        child: Image.asset(
          "assets/imagens/doey_pen.png", // nome do arquivo do mascote
          height: 200,
        ),
      ),
    );
  }
}
