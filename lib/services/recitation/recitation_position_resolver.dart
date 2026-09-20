import '../../models/ayah.dart';
import '../../models/surah.dart';
import 'recitation_position.dart';

class RecitationPositionResolver {
  const RecitationPositionResolver();

  RecitationPosition resolveAyah(
    Ayah ayah, {
    int? pageNumber,
    int? juzNumber,
  }) {
    return RecitationPosition(
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
      pageNumber: pageNumber,
      juzNumber: juzNumber,
    );
  }

  Ayah? findAyah({
    required List<Ayah> ayahs,
    required int ayahNumber,
  }) {
    for (final ayah in ayahs) {
      if (ayah.ayahNumber == ayahNumber) {
        return ayah;
      }
    }

    return null;
  }

  Ayah? nextAyah({
    required List<Ayah> ayahs,
    required int currentAyahNumber,
  }) {
    for (final ayah in ayahs) {
      if (ayah.ayahNumber == currentAyahNumber + 1) {
        return ayah;
      }
    }

    return null;
  }

  Ayah? previousAyah({
    required List<Ayah> ayahs,
    required int currentAyahNumber,
  }) {
    for (final ayah in ayahs) {
      if (ayah.ayahNumber == currentAyahNumber - 1) {
        return ayah;
      }
    }

    return null;
  }

  Surah? findSurah({
    required List<Surah> surahs,
    required int surahNumber,
  }) {
    for (final surah in surahs) {
      if (surah.number == surahNumber) {
        return surah;
      }
    }

    return null;
  }
}
