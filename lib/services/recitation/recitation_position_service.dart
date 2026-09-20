import '../../models/ayah.dart';
import '../../models/recitation_result.dart';
import 'recitation_position.dart';
import 'recitation_position_manager.dart';
import 'recitation_position_resolver.dart';
import 'recitation_position_updater.dart';

class RecitationPositionService {
  final RecitationPositionManager manager;
  final RecitationPositionResolver resolver;
  late final RecitationPositionUpdater updater;

  RecitationPositionService({
    RecitationPositionManager? manager,
    this.resolver = const RecitationPositionResolver(),
  }) : manager = manager ?? RecitationPositionManager() {
    updater = RecitationPositionUpdater(
      manager: this.manager,
    );
  }

  RecitationPosition? get position => manager.position;

  bool get hasPosition => manager.hasPosition;

  void startAtAyah(
    Ayah ayah, {
    int? pageNumber,
    int? juzNumber,
  }) {
    final position = resolver.resolveAyah(
      ayah,
      pageNumber: pageNumber,
      juzNumber: juzNumber,
    );

    manager.startAt(
      surahNumber: position.surahNumber,
      ayahNumber: position.ayahNumber,
      pageNumber: position.pageNumber,
      juzNumber: position.juzNumber,
    );
  }

  void updateFromResult(RecitationResult result) {
    updater.updateFromResult(result);
  }

  bool canAdvance(RecitationResult result) {
    return updater.canAdvance(result);
  }

  void advanceAfterCorrect(RecitationResult result) {
    updater.advanceAfterCorrect(result);
  }

  void reset() {
    manager.reset();
  }
}
