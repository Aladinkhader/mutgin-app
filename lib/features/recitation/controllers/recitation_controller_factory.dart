import 'recitation_pipeline_controller.dart';
import 'recitation_session_controller.dart';
import '../../../services/recitation/recitation_factory.dart';

abstract final class RecitationControllerFactory {
  static RecitationSessionController createSessionController() {
    final sessionManager = RecitationFactory.createSessionManager();

    return RecitationSessionController(
      manager: sessionManager,
    );
  }

  static RecitationPipelineController createPipelineController() {
    final sessionManager = RecitationFactory.createSessionManager();
    final pipeline = RecitationFactory.createPipeline(
      sessionManager,
    );

    return RecitationPipelineController(
      pipeline: pipeline,
      sessionManager: sessionManager,
    );
  }
}
