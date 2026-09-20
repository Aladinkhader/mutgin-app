import 'microphone_recitation_controller.dart';

abstract final class MicrophoneRecitationControllerFactory {
  static MicrophoneRecitationController create() {
    return MicrophoneRecitationController();
  }
}
