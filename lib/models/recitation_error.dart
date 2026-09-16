enum RecitationErrorType {
  omitted,
  added,
  substituted,
  repeated,
  pronunciation,
  unknown,
}

class RecitationError {
  final RecitationErrorType type;
  final String expectedWord;
  final String? recognizedWord;
  final int wordIndex;
  final String message;

  const RecitationError({
    required this.type,
    required this.expectedWord,
    this.recognizedWord,
    required this.wordIndex,
    required this.message,
  });

  bool get isOmitted => type == RecitationErrorType.omitted;

  bool get isAdded => type == RecitationErrorType.added;

  bool get isSubstituted => type == RecitationErrorType.substituted;

  bool get isRepeated => type == RecitationErrorType.repeated;

  bool get isPronunciation => type == RecitationErrorType.pronunciation;
}
