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

  void start(
    Ayah ayah, {
    int? pageNumber,
    int? juzNumber,
  }) {
    final position = RecitationPosition(
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
      pageNumber: pageNumber,
      juzNumber: juzNumber,
    );

    positionService.reset();
    stateManager.setPosition(position);
  }

  void updateFromResult(RecitationResult result) {
    final surahNumber = result.surahNumber;
    final ayahNumber = result.ayahNumber;

    if (surahNumber == null || ayahNumber == null) {
      return;
    }

    final position = RecitationPosition(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );

    stateManager.setPosition(position);
  }

  bool canAdvance(RecitationResult result) {
    return result.status == RecitationStatus.correct &&
        result.surahNumber != null &&
        result.ayahNumber != null;
  }

  void advanceAfterCorrect(RecitationResult result) {
    if (!canAdvance(result)) {
      return;
    }

    final surahNumber = result.surahNumber!;
    final ayahNumber = result.ayahNumber!;

    stateManager.startAdvancing();

    stateManager.setPosition(
      RecitationPosition(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber + 1,
      ),
    );
  }

  void complete() {
    stateManager.complete();
  }

  void reset() {
    positionService.reset();
    stateManager.reset();
  }
}
