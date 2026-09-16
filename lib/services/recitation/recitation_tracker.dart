import '../../models/ayah.dart';
import '../../models/recitation_result.dart';

class RecitationTracker {
  Ayah? _currentAyah;

  Ayah? get currentAyah => _currentAyah;

  void setCurrentAyah(Ayah ayah) {
    _currentAyah = ayah;
  }

  void clear() {
    _currentAyah = null;
  }

  RecitationResult createResult({
    required RecitationStatus status,
    String? recognizedText,
    double confidence = 0.0,
    String? errorMessage,
  }) {
    final ayah = _currentAyah;

    return RecitationResult(
      status: status,
      surahNumber: ayah?.surahNumber,
      ayahNumber: ayah?.ayahNumber,
      recognizedText: recognizedText,
      expectedText: ayah?.text,
      confidence: confidence,
      errorMessage: errorMessage,
    );
  }
}
