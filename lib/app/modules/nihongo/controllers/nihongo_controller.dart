import 'package:get/get.dart';

class NihongoController extends GetxController {
  /// TAB INDEX
  final selectedIndex = 0.obs;

  /// SEARCH
  final searchQuery = ''.obs;

  // DATA
  final hiragana = <Map<String, String>>[
    {"char": "あ", "romaji": "a"},
    {"char": "い", "romaji": "i"},
    {"char": "う", "romaji": "u"},
    {"char": "え", "romaji": "e"},
    {"char": "お", "romaji": "o"},
    {"char": "か", "romaji": "ka"},
    {"char": "き", "romaji": "ki"},
    {"char": "く", "romaji": "ku"},
  ];

  final katakana = <Map<String, String>>[
    {"char": "ア", "romaji": "a"},
    {"char": "イ", "romaji": "i"},
    {"char": "ウ", "romaji": "u"},
    {"char": "エ", "romaji": "e"},
    {"char": "オ", "romaji": "o"},
    {"char": "カ", "romaji": "ka"},
    {"char": "キ", "romaji": "ki"},
    {"char": "ク", "romaji": "ku"},
  ];

  final angka = <Map<String, String>>[
    {"char": "一", "romaji": "ichi"},
    {"char": "二", "romaji": "ni"},
    {"char": "三", "romaji": "san"},
    {"char": "四", "romaji": "yon"},
    {"char": "五", "romaji": "go"},
  ];

  // FILTER
  List<Map<String, String>> _filter(List<Map<String, String>> data) {
    if (searchQuery.value.isEmpty) return data;

    return data
        .where((item) =>
            item["char"]!
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            item["romaji"]!
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  List<Map<String, String>> get filteredHiragana => _filter(hiragana);
  List<Map<String, String>> get filteredKatakana => _filter(katakana);
  List<Map<String, String>> get filteredAngka => _filter(angka);

  // ACTION
  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void changeTab(int index) {
    selectedIndex.value = index;

    /// optional: reset search
    searchQuery.value = '';
  }
}