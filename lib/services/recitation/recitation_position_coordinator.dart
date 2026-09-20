import '../../models/ayah.dart';
import '../../models/recitation_result.dart';
import 'recitation_position.dart';
import 'recitation_position_service.dart';
import 'recitation_position_state.dart';
import 'recitation_position_state_manager.dart';

class RecitationPositionCoordinator {
  final RecitationPositionService positionService;
  final RecitationPositionStateManager stateManager;

  RecitationPositionCoordinator({
    RecitationPositionService? positionService,
    RecitationPositionStateManager? stateManager,
  })  : positionService =
            positionService ?? RecitationPositionService(),
        stateManager =
            stateManager ?? RecitationPositionStateManager();

  RecitationPosition? get position => stateManager.position;

  RecitationPositionState get state => stateManager.state;

  bool get hasPosition => stateManager.hasPosition;

  void start(Ayah ayah) {
    stateManager.setAyah(ayah);
  }

  void updateFromResult(RecitationResult result) {
    positionService.updateFromResult(result);

    final position = positionService.position;

    if (position == null) {
      return;
    }

    stateManager.setPosition(position);
  }

  void advanceAfterCorrect(RecitationResult result) {
    if (!positionService.canAdvance(result)) {
      return;
    }

    stateManager.startAdvancing();

    positionService.advanceAfterCorrect(result);

    final position = positionService.position;

    if (position == null) {
      return;
    }

    stateManager.setPosition(position);
  }

  void complete() {
    stateManager.complete();
  }

  void reset() {
    positionService.reset();
    stateManager.reset();
  }
}
