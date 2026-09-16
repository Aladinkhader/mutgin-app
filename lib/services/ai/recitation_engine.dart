import '../../models/recitation_error.dart';
import '../../models/recitation_result.dart';
import '../recitation/recitation_matcher.dart';
import 'ai_engine.dart';

class RecitationEngine {
  final AiEngine aiEngine;
  final RecitationMatcher matcher;

  const RecitationEngine({
    required this.aiEngine,
    this.matcher = const RecitationMatcher(),
  });

  Future<RecitationResult> process({
    required List<int> audioData,
    required String expectedText,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final result = await aiEngine.recognize(
      audioData: audioData,
    );

    final recognizedText = result.recognizedText?.trim();

    if (recognizedText == null || recognizedText.isEmpty) {
      return RecitationResult(
        status: RecitationStatus.processing,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        expectedText: expectedText,
        confidence: result.confidence,
        errorMessage: 'لم يتم التعرف على التلاوة بوضوح.',
      );
    }

    final errors = matcher.compare(
      expectedText: expectedText,
      recognizedText: recognizedText,
    );

    final isReliable = result.confidence >= 0.60;

    if (!isReliable) {
      return RecitationResult(
        status: RecitationStatus.processing,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        recognizedText: recognizedText,
        expectedText: expectedText,
        confidence: result.confidence,
        errorMessage: 'جودة التعرف غير كافية للحكم على التلاوة.',
      );
    }

    return RecitationResult(
      status: errors.isEmpty
          ? RecitationStatus.correct
          : RecitationStatus.mistake,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      recognizedText: recognizedText,
      expectedText: expectedText,
      confidence: result.confidence,
      errorMessage: errors.isEmpty ? null : _buildErrorMessage(errors),
    );
  }

  String _buildErrorMessage(List<RecitationError> errors) {
    if (errors.length == 1) {
      return errors.first.message;
    }

    return 'تم اكتشاف ${errors.length} مواضع تحتاج إلى مراجعة.';
  }
}
