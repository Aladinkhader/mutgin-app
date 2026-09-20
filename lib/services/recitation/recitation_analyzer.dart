import '../../models/recitation_error.dart';
import 'recitation_alignment.dart';

class RecitationAnalyzer {
  final RecitationAlignment alignment;

  const RecitationAnalyzer({
    this.alignment = const RecitationAlignment(),
  });

  List<RecitationError> analyze({
    required String expectedText,
    required String recognizedText,
  }) {
    return alignment.align(
      expectedText: expectedText,
      recognizedText: recognizedText,
    );
  }

  bool isCorrect({
    required String expectedText,
    required String recognizedText,
  }) {
    return analyze(
      expectedText: expectedText,
      recognizedText: recognizedText,
    ).isEmpty;
  }

  double calculateAccuracy({
    required String expectedText,
    required String recognizedText,
  }) {
    final errors = analyze(
      expectedText: expectedText,
      recognizedText: recognizedText,
    );

    final expectedWords = _wordCount(expectedText);

    if (expectedWords == 0) {
      return 0.0;
    }

    final errorCount = errors.length;
    final correctWords = expectedWords - errorCount;

    if (correctWords <= 0) {
      return 0.0;
    }

    return (correctWords / expectedWords).clamp(0.0, 1.0);
  }

  int _wordCount(String text) {
    final normalized = text.trim();

    if (normalized.isEmpty) {
      return 0;
    }

    return normalized.split(RegExp(r'\s+')).length;
  }
}
