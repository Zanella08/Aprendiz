import 'package:aprendiz/telas/progresso_Memoria.dart';
import 'package:aprendiz/transitions/Transicao.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/widgets/topodapagina.dart';
import 'package:aprendiz/utils/audio_utils.dart';
import 'package:aprendiz/widgets/completar a fase.dart'; // Importa completar_fase
import 'package:flutter/material.dart';

class MemoriaActivity extends StatefulWidget {
  @override
  _MemoriaActivityState createState() => _MemoriaActivityState();
}

class _MemoriaActivityState extends State<MemoriaActivity> {
  // Variáveis-----------------------------------------------------------------------------------
  String ok = "n";
  bool certo = false;
  int? selectedAudioIndex;
  int? selectedImageIndex;

  @override
  void dispose() {
    AudioUtils.stopAudio(); // Para qualquer áudio tocando ao sair
    super.dispose();
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
                          await AudioUtils.playAudio('audios/Memoria_1.mp3');
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
                          await AudioUtils.playAudio('audios/Memoria_2.mp3');
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
                                completar_fase(
                                  context,
                                  '4',
                                  "Você errou dessa vez, quer tentar de novo?",
                                );
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
                                completar_fase(
                                  context,
                                  '4',
                                  "Você errou dessa vez, quer tentar de novo?",
                                );
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
  completar_fase(
    context,
    '4',
    "Você errou dessa vez, quer tentar de novo?",
  );
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
  completar_fase(
    context,
    '4',
    "Você acertou! Parabéns por completar a atividade.",
  );
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
