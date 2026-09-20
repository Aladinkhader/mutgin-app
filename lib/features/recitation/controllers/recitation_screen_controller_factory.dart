import 'microphone_recitation_controller_factory.dart';
import 'recitation_screen_controller.dart';

abstract final class RecitationScreenControllerFactory {
  static RecitationScreenController create() {
    return RecitationScreenController(
      microphoneController:
          MicrophoneRecitationControllerFactory.create(),
    );
  }
}
