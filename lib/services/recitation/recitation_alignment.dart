import '../../models/recitation_error.dart';

class RecitationAlignment {
  const RecitationAlignment();

  List<RecitationError> align({
    required String expectedText,
    required String recognizedText,
  }) {
    final expectedWords = _normalize(expectedText);
    final recognizedWords = _normalize(recognizedText);

    if (expectedWords.isEmpty && recognizedWords.isEmpty) {
      return const [];
    }

    if (expectedWords.isEmpty) {
      return List<RecitationError>.generate(
        recognizedWords.length,
        (index) => RecitationError(
          type: RecitationErrorType.added,
          expectedWord: '',
          recognizedWord: recognizedWords[index],
          wordIndex: index,
          message: 'كلمة زائدة',
        ),
      );
    }

    if (recognizedWords.isEmpty) {
      return List<RecitationError>.generate(
        expectedWords.length,
        (index) => RecitationError(
          type: RecitationErrorType.omitted,
          expectedWord: expectedWords[index],
          wordIndex: index,
          message: 'كلمة مفقودة',
        ),
      );
    }

    final rows = expectedWords.length + 1;
    final columns = recognizedWords.length + 1;

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
            expectedWords[i - 1] == recognizedWords[j - 1] ? 0 : 1;

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

    final errors = <RecitationError>[];

    var i = expectedWords.length;
    var j = recognizedWords.length;

    while (i > 0 || j > 0) {
      if (i > 0 &&
          j > 0 &&
          expectedWords[i - 1] == recognizedWords[j - 1]) {
        i--;
        j--;
        continue;
      }

      if (i > 0 &&
          j > 0 &&
          distance[i][j] == distance[i - 1][j - 1] + 1) {
        errors.add(
          RecitationError(
            type: RecitationErrorType.substituted,
            expectedWord: expectedWords[i - 1],
            recognizedWord: recognizedWords[j - 1],
            wordIndex: i - 1,
            message: 'الكلمة تحتاج إلى مراجعة',
          ),
        );

        i--;
        j--;
        continue;
      }

      if (i > 0 &&
          distance[i][j] == distance[i - 1][j] + 1) {
        errors.add(
          RecitationError(
            type: RecitationErrorType.omitted,
            expectedWord: expectedWords[i - 1],
            wordIndex: i - 1,
            message: 'كلمة مفقودة',
          ),
        );

        i--;
        continue;
      }

      if (j > 0 &&
          distance[i][j] == distance[i][j - 1] + 1) {
        errors.add(
          RecitationError(
            type: RecitationErrorType.added,
            expectedWord: '',
            recognizedWord: recognizedWords[j - 1],
            wordIndex: i,
            message: 'كلمة زائدة',
          ),
        );

        j--;
        continue;
      }

      break;
    }

    return errors.reversed.toList();
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

  List<String> _normalize(String text) {
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
}
