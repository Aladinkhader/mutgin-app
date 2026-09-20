import 'package:flutter/foundation.dart';

import '../../../models/recitation_result.dart';
import '../../../services/recitation/recitation_audio_factory.dart';
import '../../../services/recitation/recitation_audio_pipeline.dart';

class RecitationAudioController extends ChangeNotifier {
  late final RecitationAudioPipeline _pipeline;

  bool _isRecording = false;
  bool _isProcessing = false;
  RecitationResult _result = const RecitationResult(
    status: RecitationStatus.idle,
  );

  RecitationAudioController({
    RecitationAudioPipeline? pipeline,
  }) {
    _pipeline =
        pipeline ?? RecitationAudioFactory.createMockPipeline();
  }

  bool get isRecording => _isRecording;

  bool get isProcessing => _isProcessing;

  RecitationResult get result => _result;

  void start() {
    if (_isRecording || _isProcessing) {
      return;
    }

    _pipeline.start();
    _isRecording = true;

    _result = const RecitationResult(
      status: RecitationStatus.listening,
    );

    notifyListeners();
  }

  void addAudio(List<int> audioData) {
    if (!_isRecording) {
      return;
    }

    _pipeline.addAudio(audioData);
  }

  Future<void> stop({
    required String expectedText,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    if (!_isRecording || _isProcessing) {
      return;
    }

    _isRecording = false;
    _isProcessing = true;

    _result = RecitationResult(
      status: RecitationStatus.processing,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      expectedText: expectedText,
    );

    notifyListeners();

    try {
      _result = await _pipeline.stopAndProcess(
        expectedText: expectedText,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      );
    } catch (_) {
      _result = RecitationResult(
        status: RecitationStatus.processing,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        expectedText: expectedText,
        errorMessage: 'حدث خطأ أثناء معالجة التسجيل.',
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void cancel() {
    _pipeline.cancel();

    _isRecording = false;
    _isProcessing = false;

    _result = const RecitationResult(
      status: RecitationStatus.idle,
    );

    notifyListeners();
  }
}
