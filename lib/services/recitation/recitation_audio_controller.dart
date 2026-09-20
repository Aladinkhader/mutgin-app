import '../../models/recitation_result.dart';
import 'recitation_audio_factory.dart';
import 'recitation_audio_pipeline.dart';

class RecitationAudioController {
  final RecitationAudioPipeline pipeline;

  RecitationResult _result = const RecitationResult(
    status: RecitationStatus.idle,
  );

  bool _isProcessing = false;

  RecitationAudioController({
    RecitationAudioPipeline? pipeline,
  }) : pipeline =
            pipeline ?? RecitationAudioFactory.createMockPipeline();

  RecitationResult get result => _result;

  bool get isActive => pipeline.audioController.isActive;

  bool get isRecording => isActive;

  bool get isProcessing => _isProcessing;

  Duration get duration => pipeline.audioController.duration;

  void start() {
    if (isActive || _isProcessing) {
      return;
    }

    _result = const RecitationResult(
      status: RecitationStatus.listening,
    );

    pipeline.start();
  }

  void addAudio(List<int> audioData) {
    if (!isActive || _isProcessing) {
      return;
    }

    pipeline.addAudio(audioData);
  }

  Future<void> stop({
    required String expectedText,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    if (!isActive || _isProcessing) {
      return;
    }

    _isProcessing = true;

    _result = RecitationResult(
      status: RecitationStatus.processing,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      expectedText: expectedText,
    );

    try {
      _result = await pipeline.stopAndProcess(
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
        errorMessage: 'حدث خطأ أثناء تحليل التسجيل.',
      );
    } finally {
      _isProcessing = false;
    }
  }

  void cancel() {
    pipeline.cancel();
    _isProcessing = false;

    _result = const RecitationResult(
      status: RecitationStatus.idle,
    );
  }

  void reset() {
    cancel();
  }

  void dispose() {
    pipeline.cancel();
  }
}
