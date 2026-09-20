import 'package:flutter/foundation.dart';

import '../../../models/ayah.dart';
import '../../../models/recitation_result.dart';
import '../../../services/ai/recitation_engine_factory.dart';
import '../../../services/recitation/recitation_audio_controller.dart';
import 'recitation_audio_controller_factory.dart';

class RecitationScreenController extends ChangeNotifier {
  final RecitationAudioController audioController;

  Ayah? _currentAyah;
  RecitationResult _result = const RecitationResult(
    status: RecitationStatus.idle,
  );

  RecitationScreenController({
    RecitationAudioController? audioController,
  }) : audioController =
            audioController ??
            RecitationAudioControllerFactory.create();

  Ayah? get currentAyah => _currentAyah;

  RecitationResult get result => _result;

  bool get isRecording => audioController.isRecording;

  bool get isProcessing => audioController.isProcessing;

  void setAyah(Ayah ayah) {
    if (_currentAyah?.number == ayah.number) {
      return;
    }

    _currentAyah = ayah;
    _result = const RecitationResult(
      status: RecitationStatus.idle,
    );

    notifyListeners();
  }

  void start() {
    if (_currentAyah == null) {
      return;
    }

    audioController.start();

    _result = RecitationResult(
      status: RecitationStatus.listening,
      surahNumber: _currentAyah!.surahNumber,
      ayahNumber: _currentAyah!.ayahNumber,
      expectedText: _currentAyah!.text,
    );

    notifyListeners();
  }

  void addAudio(List<int> audioData) {
    audioController.addAudio(audioData);
  }

  Future<void> stop() async {
    final ayah = _currentAyah;

    if (ayah == null || !isRecording) {
      return;
    }

    await audioController.stop(
      expectedText: ayah.text,
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
    );

    _result = audioController.result;
    notifyListeners();
  }

  void cancel() {
    audioController.cancel();

    _result = RecitationResult(
      status: RecitationStatus.idle,
      surahNumber: _currentAyah?.surahNumber,
      ayahNumber: _currentAyah?.ayahNumber,
      expectedText: _currentAyah?.text,
    );

    notifyListeners();
  }

  @override
  void dispose() {
    audioController.dispose();
    super.dispose();
  }
}
