import '../../models/recitation_result.dart';
import '../ai/recitation_engine.dart';
import 'recitation_audio_controller.dart';
import 'recitation_audio_processor.dart';
import 'recitation_audio_session.dart';

class RecitationAudioPipeline {
  final RecitationAudioController audioController;
  final RecitationAudioProcessor processor;
  final RecitationEngine engine;
  final RecitationAudioSession session;

  const RecitationAudioPipeline({
    required this.audioController,
    required this.processor,
    required this.engine,
    required this.session,
  });

  void start() {
    session.start();
  }

  void addAudio(List<int> audioData) {
    if (!session.isActive || audioData.isEmpty) {
      return;
    }

    session.addAudio(audioData);
  }

  bool get isActive => session.isActive;

  Duration get duration => session.duration;

  Future<RecitationResult> stopAndProcess({
    required String expectedText,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final audioResult = session.finish();

    if (audioResult == null) {
      return RecitationResult(
        status: RecitationStatus.processing,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        expectedText: expectedText,
        errorMessage:
            'لم يتم تسجيل مقطع صوتي صالح للتحليل.',
      );
    }

    final preparedAudio = processor.prepare(audioResult);

    if (preparedAudio.isEmpty) {
      return RecitationResult(
        status: RecitationStatus.processing,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        expectedText: expectedText,
        errorMessage:
            'تعذر تجهيز التسجيل الصوتي للتحليل.',
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
    session.cancel();
  }
}
