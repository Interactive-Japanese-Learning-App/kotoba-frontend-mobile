import 'package:get/get.dart';

class NihongoController extends GetxController {
  /// TAB INDEX
  final currentTab = 0.obs;

  /// SEARCH
  final searchQuery = ''.obs;

  /// DATA HIRAGANA
  final hiragana = [
    {"char": "あ", "romaji": "a"},
    {"char": "い", "romaji": "i"},
    {"char": "う", "romaji": "u"},
    {"char": "え", "romaji": "e"},
    {"char": "お", "romaji": "o"},
    {"char": "か", "romaji": "ka"},
    {"char": "き", "romaji": "ki"},
    {"char": "く", "romaji": "ku"},
  ];

  /// FILTERED DATA
  List<Map<String, String>> get filteredHiragana {
    if (searchQuery.value.isEmpty) return hiragana;

    return hiragana
        .where((item) =>
            item["char"]!.contains(searchQuery.value) ||
            item["romaji"]!.contains(searchQuery.value))
        .toList();
  }

  /// UPDATE SEARCH
  void updateSearch(String value) {
    searchQuery.value = value;
  }

  /// CHANGE TAB
  void changeTab(int index) {
    currentTab.value = index;
  }
}