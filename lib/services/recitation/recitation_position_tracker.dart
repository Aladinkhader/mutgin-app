import '../../models/ayah.dart';
import 'recitation_position.dart';

class RecitationPositionTracker {
  RecitationPosition? _position;

  RecitationPosition? get position => _position;

  bool get hasPosition => _position != null;

  void setAyah(
    Ayah ayah, {
    int? pageNumber,
    int? juzNumber,
  }) {
    _position = RecitationPosition(
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
      pageNumber: pageNumber,
      juzNumber: juzNumber,
    );
  }

  void setPosition(RecitationPosition position) {
    _position = position;
  }

  void moveToAyah(
    int ayahNumber, {
    int? pageNumber,
    int? juzNumber,
  }) {
    final current = _position;

    if (current == null) {
      return;
    }

    _position = current.copyWith(
      ayahNumber: ayahNumber,
      pageNumber: pageNumber,
      juzNumber: juzNumber,
    );
  }

  void clear() {
    _position = null;
  }

  bool isCurrentAyah(Ayah ayah) {
    final current = _position;

    if (current == null) {
      return false;
    }

    return current.surahNumber == ayah.surahNumber &&
        current.ayahNumber == ayah.ayahNumber;
  }
}
