import 'package:flutter/foundation.dart';

import '../../models/ayah.dart';
import 'recitation_position.dart';
import 'recitation_position_manager.dart';

class RecitationPositionController extends ChangeNotifier {
  final RecitationPositionManager manager;

  RecitationPositionController({
    RecitationPositionManager? manager,
  }) : manager = manager ?? RecitationPositionManager();

  RecitationPosition? get position => manager.position;

  bool get hasPosition => manager.hasPosition;

  void start(Ayah ayah) {
    manager.start(ayah);
    notifyListeners();
  }

  void startAt({
    required int surahNumber,
    required int ayahNumber,
    int? pageNumber,
    int? juzNumber,
  }) {
    manager.startAt(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      pageNumber: pageNumber,
      juzNumber: juzNumber,
    );

    notifyListeners();
  }

  void moveToNextAyah() {
    manager.moveToNextAyah();
    notifyListeners();
  }

  void moveToAyah(
    int ayahNumber, {
    int? pageNumber,
    int? juzNumber,
  }) {
    manager.moveToAyah(
      ayahNumber,
      pageNumber: pageNumber,
      juzNumber: juzNumber,
    );

    notifyListeners();
  }

  bool isCurrentAyah(Ayah ayah) {
    return manager.isCurrentAyah(ayah);
  }

  void reset() {
    manager.reset();
    notifyListeners();
  }
}
