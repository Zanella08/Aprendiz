import 'package:audioplayers/audioplayers.dart';

class AudioUtils {
  static AudioPlayer? _player;
  static bool isPlaying = false;
  static String? _currentAudio;

  /// Toca um áudio do assets. Exemplo de uso: AudioUtils.playAudio('audios/Memoria_1.mp3');
  static Future<void> playAudio(String audioPath) async {
    _player?.dispose();
    _player = AudioPlayer();
    isPlaying = true;
    _currentAudio = audioPath;
    await _player!.play(AssetSource(audioPath));
    await _player!.onPlayerComplete.first;
    isPlaying = false;
    _currentAudio = null;
  }

  /// Para o áudio atual, se estiver tocando.
  static Future<void> stopAudio() async {
    if (_player != null && isPlaying) {
      await _player!.stop();
      isPlaying = false;
      _currentAudio = null;
    }
  }

  /// Retorna se está tocando algum áudio.
  static bool get isAudioPlaying => isPlaying;

  /// Retorna o caminho do áudio atual.
  static String? get currentAudio => _currentAudio;
}
