import '../../models/recitation_error.dart';
import '../../models/recitation_result.dart';
import 'ai_engine.dart';
import '../recitation/recitation_matcher.dart';

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

    if (result.recognizedText == null ||
        result.recognizedText!.trim().isEmpty) {
      return RecitationResult(
        status: RecitationStatus.processing,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        expectedText: expectedText,
        confidence: result.confidence,
      );
    }

    final errors = matcher.compare(
      expectedText: expectedText,
      recognizedText: result.recognizedText!,
    );

    return RecitationResult(
      status: errors.isEmpty
          ? RecitationStatus.correct
          : RecitationStatus.mistake,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      recognizedText: result.recognizedText,
      expectedText: expectedText,
      confidence: result.confidence,
      errorMessage: errors.isEmpty
          ? null
          : _buildErrorMessage(errors),
    );
  }

  String _buildErrorMessage(List<RecitationError> errors) {
    if (errors.length == 1) {
      return errors.first.message;
    }

    return 'تم اكتشاف ${errors.length} مواضع تحتاج إلى مراجعة';
  }
}
