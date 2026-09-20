import 'package:flutter/foundation.dart';

import '../../../models/ayah.dart';
import '../../../models/recitation_result.dart';
import '../../../services/audio/microphone_audio_packet_pipeline.dart';
import '../../../services/recitation/recitation_audio_controller.dart';
import '../../../services/recitation/recitation_ayah_navigator.dart';
import '../../../services/recitation/recitation_position.dart';
import '../../../services/recitation/recitation_position_coordinator.dart';
import '../../../services/recitation/recitation_position_factory.dart';
import 'microphone_recitation_controller.dart';

class RecitationScreenController extends ChangeNotifier {
  final RecitationAudioController audioController;
  final MicrophoneRecitationController microphoneController;
  final MicrophoneAudioPacketPipeline packetPipeline;
  final RecitationPositionCoordinator positionCoordinator;
  final RecitationAyahNavigator ayahNavigator;

  Ayah? _currentAyah;

  RecitationResult _result = const RecitationResult(
    status: RecitationStatus.idle,
  );

  RecitationScreenController({
    RecitationAudioController? audioController,
    required this.microphoneController,
    MicrophoneAudioPacketPipeline? packetPipeline,
    RecitationPositionCoordinator? positionCoordinator,
    RecitationAyahNavigator? ayahNavigator,
  })  : audioController =
            audioController ?? RecitationAudioController(),
        packetPipeline =
            packetPipeline ?? MicrophoneAudioPacketPipeline(),
        positionCoordinator =
            positionCoordinator ??
                RecitationPositionFactory.createCoordinator(),
        ayahNavigator =
            ayahNavigator ?? const RecitationAyahNavigator();

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
      await _moveToNextAyah();
    }

    notifyListeners();
  }

  Future<void> _moveToNextAyah() async {
    final currentAyah = _currentAyah;

    if (currentAyah == null) {
      return;
    }

    final nextAyah =
        await ayahNavigator.getNextAyah(currentAyah);

    if (nextAyah == null) {
      return;
    }

    _currentAyah = nextAyah;
    positionCoordinator.start(nextAyah);

    _result = RecitationResult(
      status: RecitationStatus.completed,
      surahNumber: nextAyah.surahNumber,
      ayahNumber: nextAyah.ayahNumber,
      expectedText: nextAyah.text,
      confidence: 1.0,
    );
  }

  Future<void> moveToNextAyah() async {
    await _moveToNextAyah();
    notifyListeners();
  }

  Future<void> moveToPreviousAyah() async {
    final currentAyah = _currentAyah;

    if (currentAyah == null) {
      return;
    }

    final previousAyah =
        await ayahNavigator.getPreviousAyah(currentAyah);

    if (previousAyah == null) {
      return;
    }

    _currentAyah = previousAyah;
    positionCoordinator.start(previousAyah);

    _result = RecitationResult(
      status: RecitationStatus.idle,
      surahNumber: previousAyah.surahNumber,
      ayahNumber: previousAyah.ayahNumber,
      expectedText: previousAyah.text,
    );

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

    positionCoordinator.start(ayah);
    notifyListeners();
  }

  @override
  void dispose() {
    microphoneController.dispose();
    audioController.dispose();
    packetPipeline.clear();
    super.dispose();
  }
}
