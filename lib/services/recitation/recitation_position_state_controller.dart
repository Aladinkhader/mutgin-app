import 'package:flutter/foundation.dart';

import '../../models/ayah.dart';
import 'recitation_position.dart';
import 'recitation_position_state.dart';
import 'recitation_position_state_manager.dart';

class RecitationPositionStateController extends ChangeNotifier {
  final RecitationPositionStateManager manager;

  RecitationPositionStateController({
    RecitationPositionStateManager? manager,
  }) : manager = manager ?? RecitationPositionStateManager();

  RecitationPosition? get position => manager.position;

  RecitationPositionState get state => manager.state;

  bool get hasPosition => manager.hasPosition;

  bool get isIdle => manager.isIdle;

  bool get isPositioned => manager.isPositioned;

  bool get isAdvancing => manager.isAdvancing;

  bool get isCompleted => manager.isCompleted;

  void setAyah(
    Ayah ayah, {
    int? pageNumber,
    int? juzNumber,
  }) {
    manager.setAyah(
      ayah,
      pageNumber: pageNumber,
      juzNumber: juzNumber,
    );

    notifyListeners();
  }

  void setPosition(RecitationPosition position) {
    manager.setPosition(position);
    notifyListeners();
  }

  void startAdvancing() {
    manager.startAdvancing();
    notifyListeners();
  }

  void complete() {
    manager.complete();
    notifyListeners();
  }

  void reset() {
    manager.reset();
    notifyListeners();
  }
}
