import 'package:flutter/foundation.dart';

import '../../../models/ayah.dart';
import '../../../models/recitation_result.dart';
import '../../../services/recitation/recitation_audio_controller.dart';
import '../controllers/microphone_recitation_controller_factory.dart';
import 'microphone_recitation_controller.dart';

class RecitationScreenController extends ChangeNotifier {
  final RecitationAudioController audioController;
  final MicrophoneRecitationController microphoneController;

  Ayah? _currentAyah;
  RecitationResult _result = const RecitationResult(
    status: RecitationStatus.idle,
  );

  RecitationScreenController({
    RecitationAudioController? audioController,
    MicrophoneRecitationController? microphoneController,
  })  : audioController = audioController ?? RecitationAudioController(),
        microphoneController = microphoneController ??
            MicrophoneRecitationControllerFactory.create();

  Ayah? get currentAyah => _currentAyah;

  RecitationResult get result => _result;

  bool get isRecording => audioController.isActive;

  bool get isProcessing => audioController.isProcessing;

  bool get isMicrophoneListening =>
      microphoneController.isListening;

  String? get microphoneError =>
      microphoneController.errorMessage;

  void setAyah(Ayah ayah) {
    _currentAyah = ayah;

    _result = RecitationResult(
      status: RecitationStatus.idle,
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
      expectedText: ayah.text,
    );

    notifyListeners();
  }

  Future<void> start() async {
    final ayah = _currentAyah;

    if (ayah == null || isRecording || isProcessing) {
      return;
    }

    final started = await microphoneController.start();

    if (!started) {
      _result = RecitationResult(
        status: RecitationStatus.processing,
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
        expectedText: ayah.text,
        errorMessage:
            microphoneController.errorMessage ??
            'تعذر الوصول إلى الميكروفون.',
      );
      notifyListeners();
      return;
    }

    audioController.start();

    microphoneController.bridge.listen(addAudio);

    _result = RecitationResult(
      status: RecitationStatus.listening,
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
      expectedText: ayah.text,
    );

    notifyListeners();
  }

  void addAudio(List<int> audioData) {
    if (!isRecording || audioData.isEmpty) {
      return;
    }

    audioController.addAudio(audioData);
  }

  Future<void> stop() async {
    final ayah = _currentAyah;

    if (ayah == null || !isRecording || isProcessing) {
      return;
    }

    await microphoneController.stop();
    await microphoneController.bridge.cancelListening();

    await audioController.stop(
      expectedText: ayah.text,
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
    );

    _result = audioController.result;

    notifyListeners();
  }

  Future<void> cancel() async {
    await microphoneController.cancel();
    await microphoneController.bridge.cancelListening();

    audioController.cancel();

    final ayah = _currentAyah;

    _result = RecitationResult(
      status: RecitationStatus.idle,
      surahNumber: ayah?.surahNumber,
      ayahNumber: ayah?.ayahNumber,
      expectedText: ayah?.text,
    );

    notifyListeners();
  }

 
