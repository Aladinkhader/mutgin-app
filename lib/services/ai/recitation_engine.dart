import '../../models/recitation_error.dart';
import '../../models/recitation_result.dart';
import '../recitation/recitation_analyzer.dart';
import 'ai_engine.dart';

class RecitationEngine {
  final AiEngine aiEngine;
  final RecitationAnalyzer analyzer;

  const RecitationEngine({
    required this.aiEngine,
    this.analyzer = const RecitationAnalyzer(),
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

    if (result.confidence < 0.60) {
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

    final errors = analyzer.analyze(
      expectedText: expectedText,
      recognizedText: recognizedText,
    );

    final accuracy = analyzer.calculateAccuracy(
      expectedText: expectedText,
      recognizedText: recognizedText,
    );

    return RecitationResult(
      status: errors.isEmpty
          ? RecitationStatus.correct
          : RecitationStatus.mistake,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      recognizedText: recognizedText,
      expectedText: expectedText,
      confidence: result.confidence,
      errorMessage: errors.isEmpty
          ? null
          : _buildErrorMessage(
              errors,
              accuracy,
            ),
    );
  }

  String _buildErrorMessage(
    List<RecitationError> errors,
    double accuracy,
  ) {
    final percentage = (accuracy * 100).round();

    if (errors.length == 1) {
      return '${errors.first.message} الدقة: $percentage٪';
    }

    return 'تم اكتشاف ${errors.length} مواضع تحتاج إلى مراجعة. '
        'الدقة: $percentage٪';
  }
}
