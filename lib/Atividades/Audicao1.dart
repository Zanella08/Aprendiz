import 'package:aprendiz/widgets/completar_fase.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/desempenho_utils.dart';
import 'package:aprendiz/widgets/BottomAppAtividade.dart';
import 'package:aprendiz/widgets/topodapagina.dart';

/// Refatoração da tela de audição com foco em:
/// - separação em widgets reutilizáveis
/// - animações leves (feedback em toque, sucesso/erro)
/// - reuso de um único AudioPlayer
/// - melhora de performance (const, menos rebuilds)

class AudicaoActivity extends StatefulWidget {
  const AudicaoActivity({Key? key}) : super(key: key);

  @override
  AudicaoActivityState createState() => AudicaoActivityState();
}

class AudicaoActivityState extends State<AudicaoActivity> {
  final AudioPlayer _player = AudioPlayer();
  String? _currentAudio;

  int? selectedAudioIndex;
  int? selectedImageIndex;

  final List<bool> acertos = List<bool>.filled(4, false);
  final List<bool> erros = List<bool>.filled(4, false);

  final List<Map<String, String>> pares = [
    {'audio': 'assets/audios/Vaca.mp3', 'imagem': 'assets/imagens/vaca.png'},
    {'audio': 'assets/audios/GatoMiado.mp3', 'imagem': 'assets/imagens/gato.png'},
    {'audio': 'assets/audios/CachorroLatido.mp3', 'imagem': 'assets/imagens/cachorro.png'},
    {'audio': 'assets/audios/Galinha.mp3', 'imagem': 'assets/imagens/galinha.png'},
  ];

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _checkAllCorrect() async {
    if (acertos.every((e) => e)) {
      await _player?.stop();
      completarFase(context, "1", "Parabéns!", "Você completou a fase.");
    }
  }

  Future<void> _playAudio(String assetPath) async {
    // se já está tocando o mesmo audio, pare
    if (_currentAudio == assetPath && _player.state == PlayerState.playing) {
      await _player.stop();
      setState(() => _currentAudio = null);
      return;
    }

    // pare qualquer áudio anterior e toque o novo
    await _player.stop();
    setState(() => _currentAudio = assetPath);
    await _player.play(AssetSource(assetPath.replaceFirst('assets/', '')));
    // aguarda término (ou use onPlayerComplete)
    _player.onPlayerComplete.first.then((_) {
      if (mounted) setState(() => _currentAudio = null);
    });
  }

  void _handleSelection({required int index, required bool isAudio}) {
    setState(() {
      if (isAudio) {
        selectedAudioIndex = index;
      } else {
        selectedImageIndex = index;
      }

      // se ambos selecionados, verificar par
      if (selectedAudioIndex != null && selectedImageIndex != null) {
        final a = selectedAudioIndex!;
        final b = selectedImageIndex!;
        if (a == b) {
          acertos[a] = true;
          registrarDesempenho('audicao', true);
          _checkAllCorrect();
        } else {
          erros[a] = true;
          erros[b] = true;
          registrarDesempenho('audicao', false);
          // animação de erro: volta ao normal depois
          Future.delayed(const Duration(milliseconds: 900), () {
            if (mounted) setState(() {
              erros[a] = false;
              erros[b] = false;
            });
          });
        }
        selectedAudioIndex = null;
        selectedImageIndex = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.v1,
      appBar: Toppagina(cor4: AppColors.v2),
      bottomNavigationBar: BottomAppAtividade(context: context, cor: AppColors.v2),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildPairsRow(),
                const SizedBox(height: 20),
                const SizedBox(height: 60),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset('assets/imagens/doey_pen.png', height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.v2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.v1, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Quais animaizinhos fazem esses sons?',
              style: TextStyle(fontSize: 17, fontFamily: 'Oilvare', fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.spatial_audio, color: Colors.white),
            onPressed: () async {
              await _player.stop();
              await _player.play(AssetSource('audios/Audicao_1.mp3'));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPairsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // coluna de áudios
        Column(
          children: List<Widget>.generate(pares.length, (i) {
            final isSelected = selectedAudioIndex == i;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: AudioCell(
                icon: const Icon(Icons.multitrack_audio, color: Colors.white, size: 40),
                audioPath: pares[i]['audio']!,
                isPlaying: _currentAudio == pares[i]['audio'],
                onPlayRequested: () => _playAudio(pares[i]['audio']!),
                color: acertos[i]
                    ? Colors.green
                    : (erros[i] ? Colors.red : (isSelected ? Colors.blue : AppColors.v2)),
                onTap: () => _handleSelection(index: i, isAudio: true),
              ),
            );
          }),
        ),
        // coluna de imagens
        Column(
          children: List<Widget>.generate(pares.length, (i) {
            final isSelected = selectedImageIndex == i;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ImageCell(
                imagePath: pares[i]['imagem']!,
                color: acertos[i]
                    ? Colors.green
                    : (erros[i] ? Colors.red : (isSelected ? Colors.blue : AppColors.v2)),
                onTap: () => _handleSelection(index: i, isAudio: false),
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// Widget do botão de áudio com micro-animação
class AudioCell extends StatefulWidget {
  final Widget icon;
  final String audioPath;
  final bool isPlaying;
  final VoidCallback onPlayRequested;
  final Color color;
  final VoidCallback? onTap;

  const AudioCell({Key? key, required this.icon, required this.audioPath, required this.isPlaying, required this.onPlayRequested, required this.color, this.onTap}) : super(key: key);

  @override
  State<AudioCell> createState() => _AudioCellState();
}

class _AudioCellState extends State<AudioCell> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 110),
        child: ElevatedButton(
          onPressed: () async {
            widget.onTap?.call();
            widget.onPlayRequested();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.zero, shadowColor: Colors.transparent),
          child: Container(
            height: 80,
            width: 100,
            decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.v1, width: 2)),
            child: Center(child: widget.icon),
          ),
        ),
      ),
    );
  }
}

/// Widget do botão de imagem com micro-animação
class ImageCell extends StatefulWidget {
  final String imagePath;
  final Color color;
  final VoidCallback? onTap;

  const ImageCell({Key? key, required this.imagePath, required this.color, this.onTap}) : super(key: key);

  @override
  State<ImageCell> createState() => _ImageCellState();
}

class _ImageCellState extends State<ImageCell> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 110),
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.zero, shadowColor: Colors.transparent),
          child: Container(
            height: 80,
            width: 120,
            decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.v1, width: 2)),
            child: Center(child: SizedBox(height: 50, child: Image.asset(widget.imagePath, fit: BoxFit.contain))),
          ),
        ),
      ),
    );
  }
}
