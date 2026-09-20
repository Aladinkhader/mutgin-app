enum RecitationStatus {
  idle,
  listening,
  processing,
  correct,
  mistake,
  completed,
}

class RecitationResult {
  final RecitationStatus status;
  final int? surahNumber;
  final int? ayahNumber;
  final String? recognizedText;
  final String? expectedText;
  final double confidence;
  final double accuracy;
  final String? errorMessage;

  const RecitationResult({
    required this.status,
    this.surahNumber,
    this.ayahNumber,
    this.recognizedText,
    this.expectedText,
    this.confidence = 0.0,
    this.accuracy = 0.0,
    this.errorMessage,
  });

  bool get isCorrect => status == RecitationStatus.correct;

  bool get hasMistake => status == RecitationStatus.mistake;

  bool get isListening => status == RecitationStatus.listening;

  bool get isCompleted => status == RecitationStatus.completed;

  int get accuracyPercentage => (accuracy * 100).round();
}
