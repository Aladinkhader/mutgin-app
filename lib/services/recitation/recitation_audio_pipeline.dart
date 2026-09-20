import '../../models/recitation_result.dart';
import '../ai/recitation_engine.dart';
import 'recitation_audio_controller.dart';
import 'recitation_audio_processor.dart';
import 'recitation_audio_result.dart';

class RecitationAudioPipeline {
  final RecitationAudioController audioController;
  final RecitationAudioProcessor processor;
  final RecitationEngine engine;

  const RecitationAudioPipeline({
    required this.audioController,
    required this.processor,
    required this.engine,
  });

  void start() {
    audioController.start();
  }

  void addAudio(List<int> audioData) {
    audioController.addAudio(audioData);
  }

  Future<RecitationResult> stopAndProcess({
    required String expectedText,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final audioResult = audioController.stop();

    if (audioResult == null) {
      return RecitationResult(
        status: RecitationStatus.processing,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        expectedText: expectedText,
        errorMessage: 'لم يتم تسجيل مقطع صوتي صالح للتحليل.',
      );
    }

    final preparedAudio = processor.prepare(audioResult);

    if (preparedAudio.isEmpty) {
      return RecitationResult(
        status: RecitationStatus.processing,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        expectedText: expectedText,
        errorMessage: 'تعذر تجهيز التسجيل الصوتي للتحليل.',
      );
    }

    return engine.process(
      audioData: preparedAudio,
      expectedText: expectedText,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
  }

  void cancel() {
    audioController.cancel();
  }
}
