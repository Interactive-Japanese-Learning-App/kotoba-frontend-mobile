import 'package:get/get.dart';

class NihongoController extends GetxController {
  /// TAB INDEX
  final selectedIndex = 0.obs;

  /// SEARCH
  final searchQuery = ''.obs;

  // DATA
  final hiragana = <Map<String, String>>[
    {"char": "あ", "romaji": "a", "meaning": "a"},
    {"char": "い", "romaji": "i", "meaning": "i"},
    {"char": "う", "romaji": "u", "meaning": "u"},
    {"char": "え", "romaji": "e", "meaning": "e"},
    {"char": "お", "romaji": "o", "meaning": "o"},
    {"char": "か", "romaji": "ka", "meaning": "ka"},
    {"char": "き", "romaji": "ki", "meaning": "ki"},
    {"char": "く", "romaji": "ku", "meaning": "ku"},
  ];

  final katakana = <Map<String, String>>[
    {"char": "ア", "romaji": "a", "meaning": "a"},
    {"char": "イ", "romaji": "i", "meaning": "i"},
    {"char": "ウ", "romaji": "u", "meaning": "u"},
    {"char": "エ", "romaji": "e", "meaning": "e"},
    {"char": "オ", "romaji": "o", "meaning": "o"},
    {"char": "カ", "romaji": "ka", "meaning": "ka"},
    {"char": "キ", "romaji": "ki", "meaning": "ki"},
    {"char": "ク", "romaji": "ku", "meaning": "ku"},
  ];

  final angka = <Map<String, String>>[
    {"char": "いち", "romaji": "ichi", "meaning": "satu"},
    {"char": "に", "romaji": "ni", "meaning": "dua"},
    {"char": "さん", "romaji": "san", "meaning": "tiga"},
    {"char": "よん", "romaji": "yon", "meaning": "empat"},
    {"char": "ご", "romaji": "go", "meaning": "lima"},
  ];

  final bulanTanggal = <Map<String, String>>[
    {"char": "つき", "romaji": "tsuki", "meaning": "bulan"},
    {"char": "ひ", "romaji": "hi", "meaning": "hari"},
  ];

  final keluarga = <Map<String, String>>[
    {"char": "はは", "romaji": "haha", "meaning": "ibu"},
    {"char": "ちち", "romaji": "chichi", "meaning": "ayah"},
  ];

  final hewan = <Map<String, String>>[
    {"char": "いぬ", "romaji": "inu", "meaning": "anjing"},
    {"char": "ねこ", "romaji": "neko", "meaning": "kucing"},
  ];

  final makanan = <Map<String, String>>[
    {"char": "みず", "romaji": "mizu", "meaning": "air"},
    {"char": "こめ", "romaji": "kome", "meaning": "beras"},
  ];

  final pekerjaan = <Map<String, String>>[
    {"char": "せんせい", "romaji": "sensei", "meaning": "guru"},
    {"char": "いしゃ", "romaji": "isha", "meaning": "dokter"},
  ];

  final benda = <Map<String, String>>[
    {"char": "ほん", "romaji": "hon", "meaning": "buku"},
    {"char": "くるま", "romaji": "kuruma", "meaning": "mobil"},
  ];

  // FILTER
  List<Map<String, String>> _filter(List<Map<String, String>> data) {
    if (searchQuery.value.isEmpty) return data;

    return data
        .where(
          (item) =>
              item["char"]!.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              item["romaji"]!.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              item["meaning"]!.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ),
        )
        .toList();
  }

  List<Map<String, String>> get filteredHiragana => _filter(hiragana);
  List<Map<String, String>> get filteredKatakana => _filter(katakana);
  List<Map<String, String>> get filteredAngka => _filter(angka);
  List<Map<String, String>> get filteredBulanTanggal => _filter(bulanTanggal);
  List<Map<String, String>> get filteredKeluarga => _filter(keluarga);
  List<Map<String, String>> get filteredHewan => _filter(hewan);
  List<Map<String, String>> get filteredMakanan => _filter(makanan);
  List<Map<String, String>> get filteredPekerjaan => _filter(pekerjaan);
  List<Map<String, String>> get filteredBenda => _filter(benda);

  // ACTION
  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void changeTab(int index) {
    selectedIndex.value = index;
    searchQuery.value = '';

    Get.focusScope?.unfocus();
  }
}
