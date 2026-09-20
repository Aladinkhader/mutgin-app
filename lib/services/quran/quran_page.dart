import '../../models/ayah.dart';

class QuranPage {
  final int pageNumber;
  final int juzNumber;
  final String? surahName;
  final List<Ayah> ayahs;

  const QuranPage({
    required this.pageNumber,
    required this.juzNumber,
    required this.ayahs,
    this.surahName,
  });

  bool get isEmpty => ayahs.isEmpty;

  int get ayahCount => ayahs.length;
}
