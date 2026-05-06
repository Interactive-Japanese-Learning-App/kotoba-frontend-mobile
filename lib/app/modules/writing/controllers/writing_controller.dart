import 'package:get/get.dart';

class WritingController extends GetxController {

  /// TAB INDEX
  var selectedIndex = 0.obs;

  /// DATA
  final hiragana = [
    {'label': 'a', 'kana': 'あ'},
    {'label': 'i', 'kana': 'い'},
    {'label': 'u', 'kana': 'う'},
    {'label': 'e', 'kana': 'え'},
    {'label': 'o', 'kana': 'お'},
    {'label': 'ka', 'kana': 'か'},
    {'label': 'ki', 'kana': 'き'},
    {'label': 'ku', 'kana': 'く'},
  ];

  final katakana = [
    {'label': 'a', 'kana': 'ア'},
    {'label': 'i', 'kana': 'イ'},
    {'label': 'u', 'kana': 'ウ'},
    {'label': 'e', 'kana': 'エ'},
  ];

  /// GANTI TAB
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  /// DATA AKTIF
  List<Map<String, String>> get currentData =>
      selectedIndex.value == 0 ? hiragana : katakana;

  /// TYPE AKTIF (PINDAH DARI VIEW)
  String get currentType =>
      selectedIndex.value == 0 ? "HIRAGANA" : "KATAKANA";
}