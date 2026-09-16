class AiResult {
  final String text;
  final double confidence;
  final bool isFinal;

  const AiResult({
    required this.text,
    required this.confidence,
    required this.isFinal,
  });

  bool get hasText => text.trim().isNotEmpty;

  AiResult copyWith({
    String? text,
    double? confidence,
    bool? isFinal,
  }) {
    return AiResult(
      text: text ?? this.text,
      confidence: confidence ?? this.confidence,
      isFinal: isFinal ?? this.isFinal,
    );
  }
}
