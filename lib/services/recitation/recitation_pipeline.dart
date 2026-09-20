import '../../models/recitation_result.dart';
import '../ai/recitation_engine.dart';
import 'recitation_session_manager.dart';

class RecitationPipeline {
  final RecitationEngine engine;
  final RecitationSessionManager sessionManager;

  const RecitationPipeline({
    required this.engine,
    required this.sessionManager,
  });

  Future<RecitationResult> processAudio({
    required List<int> audioData,
  }) async {
    final ayah = sessionManager.currentAyah;

    if (ayah == null) {
      return const RecitationResult(
        status: RecitationStatus.idle,
        errorMessage: 'لا توجد آية محددة للتسميع.',
      );
    }

    try {
      return await engine.process(
        audioData: audioData,
        expectedText: ayah.text,
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
      );
    } catch (_) {
      return RecitationResult(
        status: RecitationStatus.processing,
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
        expectedText: ayah.text,
        errorMessage: 'حدث خطأ أثناء معالجة التلاوة.',
      );
    }
  }
}
