import '../../models/recitation_result.dart';
import 'recitation_position_manager.dart';

class RecitationPositionUpdater {
  final RecitationPositionManager manager;

  RecitationPositionUpdater({
    RecitationPositionManager? manager,
  }) : manager = manager ?? RecitationPositionManager();

  void updateFromResult(RecitationResult result) {
    final surahNumber = result.surahNumber;
    final ayahNumber = result.ayahNumber;

    if (surahNumber == null || ayahNumber == null) {
      return;
    }

    manager.startAt(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
  }

  bool canAdvance(RecitationResult result) {
    return result.status == RecitationStatus.correct &&
        result.surahNumber != null &&
        result.ayahNumber != null;
  }

  void advanceAfterCorrect(RecitationResult result) {
    if (!canAdvance(result)) {
      return;
    }

    final surahNumber = result.surahNumber;
    final ayahNumber = result.ayahNumber;

    if (surahNumber == null || ayahNumber == null) {
      return;
    }

    manager.startAt(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber + 1,
    );
  }

  void reset() {
    manager.reset();
  }
}
