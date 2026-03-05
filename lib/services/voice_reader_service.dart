import 'package:flutter_tts/flutter_tts.dart';

/// Service for text-to-speech functionality
class VoiceReaderService {
  static final VoiceReaderService _instance = VoiceReaderService._internal();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isPlaying = false;
  double _speechRate = 0.5; // 0.0 to 1.0
  double _pitch = 1.0; // 0.5 to 2.0
  double _volume = 1.0; // 0.0 to 1.0

  factory VoiceReaderService() {
    return _instance;
  }

  VoiceReaderService._internal() {
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setPitch(_pitch);
    await _flutterTts.setVolume(_volume);
  }

  bool get isPlaying => _isPlaying;
  double get speechRate => _speechRate;
  double get pitch => _pitch;
  double get volume => _volume;

  /// Start speaking text
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    try {
      _isPlaying = true;
      await _flutterTts.speak(text);
    } catch (e) {
      _isPlaying = false;
      rethrow;
    }
  }

  /// Pause speech (not supported on all platforms, falls back to stop)
  Future<void> pause() async {
    try {
      await _flutterTts.pause();
    } catch (e) {
      // Some platforms don't support pause, try stop instead
      await stop();
    }
  }

  /// Resume speech (alternative - restart the audio)
  Future<void> resume() async {
    try {
      // flutter_tts doesn't have native resume, this is a no-op
      // In a real app, you'd need to track position and restart
    } catch (e) {
      rethrow;
    }
  }

  /// Stop speech completely
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      _isPlaying = false;
    } catch (e) {
      rethrow;
    }
  }

  /// Set speech rate (0.0 - 1.0)
  Future<void> setSpeechRate(double rate) async {
    if (rate < 0.0 || rate > 2.0) return;

    try {
      _speechRate = rate;
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      rethrow;
    }
  }

  /// Set pitch (0.5 - 2.0)
  Future<void> setPitch(double pitch) async {
    if (pitch < 0.5 || pitch > 2.0) return;

    try {
      _pitch = pitch;
      await _flutterTts.setPitch(pitch);
    } catch (e) {
      rethrow;
    }
  }

  /// Set volume (0.0 - 1.0)
  Future<void> setVolume(double volume) async {
    if (volume < 0.0 || volume > 1.0) return;

    try {
      _volume = volume;
      await _flutterTts.setVolume(volume);
    } catch (e) {
      rethrow;
    }
  }

  /// Set language
  Future<void> setLanguage(String languageCode) async {
    try {
      await _flutterTts.setLanguage(languageCode);
    } catch (e) {
      rethrow;
    }
  }

  /// Get list of available languages
  Future<List<dynamic>> getLanguages() async {
    try {
      final languages = await _flutterTts.getLanguages;
      return languages ?? [];
    } catch (e) {
      return [];
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _flutterTts.stop();
      _isPlaying = false;
    } catch (e) {
      // silently handle
    }
  }
}
