import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:aprendiz/telas/progresso_fala.dart';
import 'package:aprendiz/utils/levels.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/widgets/Bottomapp.dart';
import 'package:aprendiz/widgets/topodapagina.dart';

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
    userSpeaks = List.generate(exercicios.length, (_) => '');
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 60),
                SizedBox(height: 16),
                Text(
                  "Parabéns!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("Você acertou a frase!"),
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
      listenFor: const Duration(seconds: 5),
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
        Navigator.push(context, MaterialPageRoute(builder: (_) => TelaFala()));
      }
    } else {
      setState(() => speakStatus = SpeakStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercicio = exercicios[currentExercicio];

    return Scaffold(
      appBar: Toppagina(cor4: AppColors.b2),
      backgroundColor: AppColors.b1,
      bottomNavigationBar: BottomApp(
        context: context,
        cor3: AppColors.b2,
        ismenu: false,
      ),
      body: SingleChildScrollView(
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
                    onPressed: () {
                      // Implementar áudio, se necessário
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(exercicio.speak),
            Image.network(exercicio.img),
            const SizedBox(height: 10),
            if (speakStatus == SpeakStatus.error)
              const Text("Frase errada", style: TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            isListening
                ? const Text("Te escutando 😁")
                : ElevatedButton(onPressed: listen, child: const Text("Falar")),
          ],
        ),
      ),
    );
  }
}
