class RecitationPosition {
  final int surahNumber;
  final int ayahNumber;
  final int? pageNumber;
  final int? juzNumber;

  const RecitationPosition({
    required this.surahNumber,
    required this.ayahNumber,
    this.pageNumber,
    this.juzNumber,
  });

  RecitationPosition copyWith({
    int? surahNumber,
    int? ayahNumber,
    int? pageNumber,
    int? juzNumber,
  }) {
    return RecitationPosition(
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      pageNumber: pageNumber ?? this.pageNumber,
      juzNumber: juzNumber ?? this.juzNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is RecitationPosition &&
        other.surahNumber == surahNumber &&
        other.ayahNumber == ayahNumber &&
        other.pageNumber == pageNumber &&
        other.juzNumber == juzNumber;
  }

  @override
  int get hashCode => Object.hash(
        surahNumber,
        ayahNumber,
        pageNumber,
        juzNumber,
      );
}
