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
    final expectedWords = _normalizeWords(expectedText);
    final recognizedWords = _normalizeWords(recognizedText);

    if (expectedWords.isEmpty) {
      return recognizedWords.isEmpty ? 1.0 : 0.0;
    }

    if (recognizedWords.isEmpty) {
      return 0.0;
    }

    final distance = _levenshteinDistance(
      expectedWords,
      recognizedWords,
    );

    final accuracy =
        1.0 - (distance / expectedWords.length);

    return accuracy.clamp(0.0, 1.0);
  }

  List<String> _normalizeWords(String text) {
    final normalized = text
        .replaceAll(RegExp(r'[ًٌٍَُِّْـ]'), '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا')
        .trim();

    if (normalized.isEmpty) {
      return const [];
    }

    return normalized
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
  }

  int _levenshteinDistance(
    List<String> expected,
    List<String> recognized,
  ) {
    final rows = expected.length + 1;
    final columns = recognized.length + 1;

    final distance = List.generate(
      rows,
      (_) => List<int>.filled(columns, 0),
    );

    for (var i = 0; i < rows; i++) {
      distance[i][0] = i;
    }

    for (var j = 0; j < columns; j++) {
      distance[0][j] = j;
    }

    for (var i = 1; i < rows; i++) {
      for (var j = 1; j < columns; j++) {
        final substitutionCost =
            expected[i - 1] == recognized[j - 1] ? 0 : 1;

        final deletion = distance[i - 1][j] + 1;
        final insertion = distance[i][j - 1] + 1;
        final substitution =
            distance[i - 1][j - 1] + substitutionCost;

        distance[i][j] = _minimum(
          deletion,
          insertion,
          substitution,
        );
      }
    }

    return distance[expected.length][recognized.length];
  }

  int _minimum(
    int first,
    int second,
    int third,
  ) {
    var result = first;

    if (second < result) {
      result = second;
    }

    if (third < result) {
      result = third;
    }

    return result;
  }
}
