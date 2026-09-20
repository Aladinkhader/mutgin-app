import 'microphone_recitation_controller_factory.dart';
import 'recitation_screen_controller.dart';
import '../../../services/recitation/recitation_position_factory.dart';

abstract final class RecitationScreenControllerFactory {
  static RecitationScreenController create() {
    return RecitationScreenController(
      microphoneController:
          MicrophoneRecitationControllerFactory.create(),
      positionCoordinator:
          RecitationPositionFactory.createCoordinator(),
    );
  }
}
