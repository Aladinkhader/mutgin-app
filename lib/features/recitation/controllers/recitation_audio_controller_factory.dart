import 'recitation_audio_controller.dart';

abstract final class RecitationAudioControllerFactory {
  static RecitationAudioController create() {
    return RecitationAudioController();
  }
}
