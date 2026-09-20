import 'package:flutter/foundation.dart';

import '../../../models/ayah.dart';
import '../../../models/recitation_result.dart';
import '../../../services/audio/microphone_audio_packet_pipeline.dart';
import '../../../services/recitation/recitation_audio_controller.dart';
import '../../../services/recitation/recitation_position.dart';
import '../../../services/recitation/recitation_position_coordinator.dart';
import '../../../services/recitation/recitation_position_factory.dart';
import 'microphone_recitation_controller.dart';

class RecitationScreenController extends ChangeNotifier {
  final RecitationAudioController audioController;
  final MicrophoneRecitationController microphoneController;
  final MicrophoneAudioPacketPipeline packetPipeline;
  final RecitationPositionCoordinator positionCoordinator;

  Ayah? _currentAyah;

  RecitationResult _result = const RecitationResult(
    status: RecitationStatus.idle,
  );

  RecitationScreenController({
    RecitationAudioController? audioController,
    required this.microphoneController,
    MicrophoneAudioPacketPipeline? packetPipeline,
    RecitationPositionCoordinator? positionCoordinator,
  })  : audioController =
            audioController ?? RecitationAudioController(),
        packetPipeline =
            packetPipeline ?? MicrophoneAudioPacketPipeline(),
        positionCoordinator =
            positionCoordinator ??
                RecitationPositionFactory.createCoordinator();

  Ayah? get currentAyah => _currentAyah;

  RecitationResult get result => _result;

  RecitationPosition? get position =>
      positionCoordinator.position;

  bool get isRecording => audioController.isActive;

  bool get isProcessing => audioController.isProcessing;

  bool get isMicrophoneListening =>
      microphoneController.isListening;

  String? get microphoneError =>
      microphoneController.errorMessage;

  bool get hasPosition =>
      positionCoordinator.hasPosition;

  void setAyah(Ayah ayah) {
    _currentAyah = ayah;

    packetPipeline.clear();
    positionCoordinator.start(ayah);

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

    packetPipeline.clear();

    final started = await microphoneController.start(
      onAudio: addAudio,
    );

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

    final accepted = packetPipeline.add(audioData);

    if (!accepted) {
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

    await audioController.stop(
      expectedText: ayah.text,
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
    );

    packetPipeline.clear();

    _result = audioController.result;

    positionCoordinator.updateFromResult(_result);

    if (_result.status == RecitationStatus.correct) {
      positionCoordinator.advanceAfterCorrect(_result);
    }

    notifyListeners();
  }

  Future<void> cancel() async {
    await microphoneController.cancel();

    audioController.cancel();
    packetPipeline.clear();
    positionCoordinator.reset();

    final ayah = _currentAyah;

    _result = RecitationResult(
      status: RecitationStatus.idle,
      surahNumber: ayah?.surahNumber,
      ayahNumber: ayah?.ayahNumber,
      expectedText: ayah?.text,
    );

    notifyListeners();
  }

  void resetPosition() {
    final ayah = _currentAyah;

    if (ayah == null) {
      positionCoordinator.reset();
      notifyListeners();
      return;
    }

    positionCoordinator.start(ayah
