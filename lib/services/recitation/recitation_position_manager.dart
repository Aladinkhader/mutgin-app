import '../../models/ayah.dart';
import 'recitation_position.dart';
import 'recitation_position_tracker.dart';

class RecitationPositionManager {
  final RecitationPositionTracker tracker;

  RecitationPositionManager({
    RecitationPositionTracker? tracker,
  }) : tracker = tracker ?? RecitationPositionTracker();

  RecitationPosition? get position => tracker.position;

  bool get hasPosition => tracker.hasPosition;

  void start(Ayah ayah) {
    tracker.setAyah(ayah);
  }

  void startAt({
    required int surahNumber,
    required int ayahNumber,
    int? pageNumber,
    int? juzNumber,
  }) {
    tracker.setPosition(
      RecitationPosition(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        pageNumber: pageNumber,
        juzNumber: juzNumber,
      ),
    );
  }

  void moveToNextAyah() {
    final current = tracker.position;

    if (current == null) {
      return;
    }

    tracker.moveToAyah(
      current.ayahNumber + 1,
      pageNumber: current.pageNumber,
      juzNumber: current.juzNumber,
    );
  }

  void moveToAyah(
    int ayahNumber, {
    int? pageNumber,
    int? juzNumber,
  }) {
    tracker.moveToAyah(
      ayahNumber,
      pageNumber: pageNumber,
      juzNumber: juzNumber,
    );
  }

  bool isCurrentAyah(Ayah ayah) {
    return tracker.isCurrentAyah(ayah);
  }

  void reset() {
    tracker.clear();
  }
}
