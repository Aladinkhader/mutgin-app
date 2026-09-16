import '../../models/ayah.dart';
import '../../models/recitation_result.dart';
import 'recitation_tracker.dart';

class RecitationSession {
  final RecitationTracker tracker;

  Ayah? _currentAyah;
  bool _isActive = false;

  RecitationSession({
    RecitationTracker? tracker,
  }) : tracker = tracker ?? RecitationTracker();

  Ayah? get currentAyah => _currentAyah;

  bool get isActive => _isActive;

  void start(Ayah ayah) {
    _currentAyah = ayah;
    _isActive = true;
    tracker.setCurrentAyah(ayah);
  }

  RecitationResult update({
    required RecitationStatus status,
    String? recognizedText,
    double confidence = 0.0,
    String? errorMessage,
  }) {
    if (!_isActive || _currentAyah == null) {
      return const RecitationResult(
        status: RecitationStatus.idle,
      );
    }

    return tracker.createResult(
      status: status,
      recognizedText: recognizedText,
      confidence: confidence,
      errorMessage: errorMessage,
    );
  }

  void stop() {
    _isActive = false;
    _currentAyah = null;
    tracker.clear();
  }
}
