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
    {'label': 'ke', 'kana': 'け'},
    {'label': 'ko', 'kana': 'こ'},

    {'label': 'sa', 'kana': 'さ'},
    {'label': 'shi', 'kana': 'し'},
    {'label': 'su', 'kana': 'す'},
    {'label': 'se', 'kana': 'せ'},
    {'label': 'so', 'kana': 'そ'},

    {'label': 'ta', 'kana': 'た'},
    {'label': 'chi', 'kana': 'ち'},
    {'label': 'tsu', 'kana': 'つ'},
    {'label': 'te', 'kana': 'て'},
    {'label': 'to', 'kana': 'と'},

    {'label': 'na', 'kana': 'な'},
    {'label': 'ni', 'kana': 'に'},
    {'label': 'nu', 'kana': 'ぬ'},
    {'label': 'ne', 'kana': 'ね'},
    {'label': 'no', 'kana': 'の'},

    {'label': 'ha', 'kana': 'は'},
    {'label': 'hi', 'kana': 'ひ'},
    {'label': 'fu', 'kana': 'ふ'},
    {'label': 'he', 'kana': 'へ'},
    {'label': 'ho', 'kana': 'ほ'},

    {'label': 'ma', 'kana': 'ま'},
    {'label': 'mi', 'kana': 'み'},
    {'label': 'mu', 'kana': 'む'},
    {'label': 'me', 'kana': 'め'},
    {'label': 'mo', 'kana': 'も'},

    {'label': 'ya', 'kana': 'や'},
    {'label': 'yu', 'kana': 'ゆ'},
    {'label': 'yo', 'kana': 'よ'},

    {'label': 'ra', 'kana': 'ら'},
    {'label': 'ri', 'kana': 'り'},
    {'label': 'ru', 'kana': 'る'},
    {'label': 're', 'kana': 'れ'},
    {'label': 'ro', 'kana': 'ろ'},

    {'label': 'wa', 'kana': 'わ'},
    {'label': 'wo', 'kana': 'を'},
    {'label': 'n', 'kana': 'ん'},
  ];
  final katakana = [
    {'label': 'a', 'kana': 'ア'},
    {'label': 'i', 'kana': 'イ'},
    {'label': 'u', 'kana': 'ウ'},
    {'label': 'e', 'kana': 'エ'},
    {'label': 'o', 'kana': 'オ'},

    {'label': 'ka', 'kana': 'カ'},
    {'label': 'ki', 'kana': 'キ'},
    {'label': 'ku', 'kana': 'ク'},
    {'label': 'ke', 'kana': 'ケ'},
    {'label': 'ko', 'kana': 'コ'},

    {'label': 'sa', 'kana': 'サ'},
    {'label': 'shi', 'kana': 'シ'},
    {'label': 'su', 'kana': 'ス'},
    {'label': 'se', 'kana': 'セ'},
    {'label': 'so', 'kana': 'ソ'},

    {'label': 'ta', 'kana': 'タ'},
    {'label': 'chi', 'kana': 'チ'},
    {'label': 'tsu', 'kana': 'ツ'},
    {'label': 'te', 'kana': 'テ'},
    {'label': 'to', 'kana': 'ト'},

    {'label': 'na', 'kana': 'ナ'},
    {'label': 'ni', 'kana': 'ニ'},
    {'label': 'nu', 'kana': 'ヌ'},
    {'label': 'ne', 'kana': 'ネ'},
    {'label': 'no', 'kana': 'ノ'},

    {'label': 'ha', 'kana': 'ハ'},
    {'label': 'hi', 'kana': 'ヒ'},
    {'label': 'fu', 'kana': 'フ'},
    {'label': 'he', 'kana': 'ヘ'},
    {'label': 'ho', 'kana': 'ホ'},

    {'label': 'ma', 'kana': 'マ'},
    {'label': 'mi', 'kana': 'ミ'},
    {'label': 'mu', 'kana': 'ム'},
    {'label': 'me', 'kana': 'メ'},
    {'label': 'mo', 'kana': 'モ'},

    {'label': 'ya', 'kana': 'ヤ'},
    {'label': 'yu', 'kana': 'ユ'},
    {'label': 'yo', 'kana': 'ヨ'},

    {'label': 'ra', 'kana': 'ラ'},
    {'label': 'ri', 'kana': 'リ'},
    {'label': 'ru', 'kana': 'ル'},
    {'label': 're', 'kana': 'レ'},
    {'label': 'ro', 'kana': 'ロ'},

    {'label': 'wa', 'kana': 'ワ'},
    {'label': 'wo', 'kana': 'ヲ'},
    {'label': 'n', 'kana': 'ン'},
  ];

  /// GANTI TAB
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  /// DATA AKTIF
  List<Map<String, String>> get currentData =>
      selectedIndex.value == 0 ? hiragana : katakana;

  /// TYPE AKTIF (PINDAH DARI VIEW)
  String get currentType => selectedIndex.value == 0 ? "HIRAGANA" : "KATAKANA";
}
