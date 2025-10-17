import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  final AudioPlayer _player = AudioPlayer();

  AudioManager._internal();

  AudioPlayer get player => _player;

  Future<void> playUrl(String url) async {
    try {
      await _player.setUrl(url);
      if (_player.playerState.processingState == ProcessingState.completed) {
        await _player.seek(Duration.zero);
      }
      await _player.play();
    } catch (e) {
      debugPrint("AudioManager error: $e");
    }
  }

  Future<void> stop() async => _player.stop();

  Future<void> pause() async => _player.pause();

  Future<void> setVolume(double volume) async => _player.setVolume(volume);

  Future<void> dispose() async => _player.dispose();
}
