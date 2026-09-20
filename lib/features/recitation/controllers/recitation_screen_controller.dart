import 'package:flutter/foundation.dart';

import '../../../models/ayah.dart';
import '../../../models/recitation_result.dart';
import '../../../services/audio/microphone_audio_packet_pipeline.dart';
import '../../../services/recitation/recitation_audio_controller.dart';
import 'microphone_recitation_controller.dart';

class RecitationScreenController extends ChangeNotifier {
  final RecitationAudioController audioController;
  final MicrophoneRecitationController microphoneController;
  final MicrophoneAudioPacketPipeline packetPipeline;

  Ayah? _currentAyah;

  RecitationResult _result = const RecitationResult(
    status: RecitationStatus.idle,
  );

  RecitationScreenController({
    RecitationAudioController? audioController,
    required this.microphoneController,
    MicrophoneAudioPacketPipeline? packetPipeline,
  })  : audioController =
            audioController ?? RecitationAudioController(),
        packetPipeline =
            packetPipeline ?? MicrophoneAudioPacketPipeline();

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
    packetPipeline.clear();

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

    audioController.addAudio(audio
