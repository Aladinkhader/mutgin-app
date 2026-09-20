import 'package:flutter/foundation.dart';

import '../../../services/audio/microphone_audio_collector.dart';
import '../../../services/audio/microphone_recitation_bridge.dart';

class MicrophoneRecitationController extends ChangeNotifier {
  final MicrophoneRecitationBridge bridge;
  late final MicrophoneAudioCollector collector;

  bool _isListening = false;
  String? _errorMessage;

  MicrophoneRecitationController({
    MicrophoneRecitationBridge? bridge,
  }) : bridge = bridge ?? MicrophoneRecitationBridge() {
    collector = MicrophoneAudioCollector(
      audioStream: this.bridge.audioStream,
    );
  }

  bool get isListening => _isListening;

  String? get errorMessage => _errorMessage;

  Stream<List<int>> get audioStream => bridge.audioStream;

  Future<bool> start({
    void Function(List<int> audioData)? onAudio,
  }) async {
    if (_isListening) {
      return true;
    }

    _errorMessage = null;

    try {
      final granted = await bridge.requestPermission();

      if (!granted) {
        _errorMessage = 'لم يتم السماح باستخدام الميكروفون.';
        notifyListeners();
        return false;
      }

      await bridge.start();

      if (onAudio != null) {
        collector.start(onAudio);
      }

      _isListening = true;
      notifyListeners();

      return true;
    } catch (_) {
      _isListening = false;
      _errorMessage = 'تعذر بدء تسجيل الصوت.';
      notifyListeners();

      return false;
    }
  }

  Future<void> stop() async {
    if (!_isListening) {
      return;
    }

    try {
      await collector.stop();
      await bridge.stop();
    } finally {
      _isListening = false;
      notifyListeners();
    }
  }

  Future<void> cancel() async {
    try {
      await collector.stop();
      await bridge.stop();
    } catch (_) {
      // Keep the controller in a stopped state.
    }

    _isListening = false;
    _errorMessage = null;

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    collector.dispose();
    bridge.dispose();
    super.dispose();
  }
}
