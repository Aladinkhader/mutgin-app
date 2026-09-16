import '../../models/recitation_error.dart';

class RecitationMatcher {
  const RecitationMatcher();

  List<RecitationError> compare({
    required String expectedText,
    required String recognizedText,
  }) {
    final expectedWords = _normalize(expectedText);
    final recognizedWords = _normalize(recognizedText);

    if (expectedWords.isEmpty || recognizedWords.isEmpty) {
      return const [];
    }

    final errors = <RecitationError>[];
    final length = expectedWords.length > recognizedWords.length
        ? expectedWords.length
        : recognizedWords.length;

    for (var i = 0; i < length; i++) {
      final expected = i < expectedWords.length ? expectedWords[i] : null;
      final recognized = i < recognizedWords.length ? recognizedWords[i] : null;

      if (expected == null && recognized != null) {
        errors.add(
          RecitationError(
            type: RecitationErrorType.added,
            expectedWord: '',
            recognizedWord: recognized,
            wordIndex: i,
            message: 'كلمة زائدة',
          ),
        );
        continue;
      }

      if (expected != null && recognized == null) {
        errors.add(
          RecitationError(
            type: RecitationErrorType.omitted,
            expectedWord: expected,
            wordIndex: i,
            message: 'كلمة مفقودة',
          ),
        );
        continue;
      }

      if (expected != recognized) {
        errors.add(
          RecitationError(
            type: RecitationErrorType.substituted,
            expectedWord: expected!,
            recognizedWord: recognized,
            wordIndex: i,
            message: 'الكلمة تحتاج إلى مراجعة',
          ),
        );
      }
    }

    return errors;
  }

  List<String> _normalize(String text) {
    return text
        .replaceAll(RegExp(r'[ًٌٍَُِّْـ]'), '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا')
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
  }
}
