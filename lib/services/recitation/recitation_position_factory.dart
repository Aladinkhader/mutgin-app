import 'recitation_position_coordinator.dart';
import 'recitation_position_service.dart';
import 'recitation_position_state_manager.dart';

abstract final class RecitationPositionFactory {
  static RecitationPositionCoordinator createCoordinator() {
    final service = RecitationPositionService();
    final stateManager = RecitationPositionStateManager();

    return RecitationPositionCoordinator(
      positionService: service,
      stateManager: stateManager,
    );
  }
}
