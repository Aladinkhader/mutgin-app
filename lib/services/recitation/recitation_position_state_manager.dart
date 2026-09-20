import '../../models/ayah.dart';
import 'recitation_position.dart';
import 'recitation_position_state.dart';

class RecitationPositionStateManager {
  RecitationPosition? _position;
  RecitationPositionState _state = RecitationPositionState.idle;

  RecitationPosition? get position => _position;

  RecitationPositionState get state => _state;

  bool get hasPosition => _position != null;

  bool get isIdle => _state == RecitationPositionState.idle;

  bool get isPositioned =>
      _state == RecitationPositionState.positioned;

  bool get isAdvancing =>
      _state == RecitationPositionState.advancing;

  bool get isCompleted =>
      _state == RecitationPositionState.completed;

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

    _state = RecitationPositionState.positioned;
  }

  void setPosition(RecitationPosition position) {
    _position = position;
    _state = RecitationPositionState.positioned;
  }

  void startAdvancing() {
    if (_position == null) {
      return;
    }

    _state = RecitationPositionState.advancing;
  }

  void complete() {
    _state = RecitationPositionState.completed;
  }

  void reset() {
    _position = null;
    _state = RecitationPositionState.idle;
  }
}
