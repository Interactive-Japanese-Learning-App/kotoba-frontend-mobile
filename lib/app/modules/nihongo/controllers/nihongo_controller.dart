import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kotoba_app/app/data/services/api_service.dart' show ApiService;

class NihongoController extends GetxController {
  final selectedIndex = 0.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  final Dio dio = Dio();

  final hiragana = <Map<String, dynamic>>[].obs;
  final katakana = <Map<String, dynamic>>[].obs;
  final angka = <Map<String, dynamic>>[].obs;
  final bulan = <Map<String, dynamic>>[].obs;
  final tanggal = <Map<String, dynamic>>[].obs;
  final keluarga = <Map<String, dynamic>>[].obs;
  final hewan = <Map<String, dynamic>>[].obs;
  final makanan = <Map<String, dynamic>>[].obs;
  final minuman = <Map<String, dynamic>>[].obs;
  final pekerjaan = <Map<String, dynamic>>[].obs;
  final benda = <Map<String, dynamic>>[].obs;

  static const String baseUrl = "http://192.168.18.11:5000/api/nihongo";

  @override
  void onInit() {
    super.onInit();
    saveLearningActivity();
    loadHiragana();
  }

  Future<void> loadData(
    String endpoint,
    RxList<Map<String, dynamic>> target,
  ) async {
    try {
      isLoading.value = true;

      print("REQUEST => $baseUrl/$endpoint");

      final response = await dio.get("$baseUrl/$endpoint");

      print("STATUS => ${response.statusCode}");
      print("DATA => ${response.data}");

      final List data = response.data["data"];

      target.assignAll(data.map((e) => Map<String, dynamic>.from(e)));

      print("TOTAL => ${target.length}");
    } catch (e) {
      print("ERROR NIHONGO => $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveLearningActivity() async {
    final box = GetStorage();
    final userId = box.read('userId');

    if (userId == null) return;

    await ApiService.saveActivity(
      userId: userId,
      activityType: "learning",
      title: "Belajar Materi Nihongo Basic",
      detail: "Baru saja mempelajari materi Nihongo Basic",
    );
  }

  Future<void> loadHiragana() async {
    await loadData("hiragana", hiragana);
  }

  Future<void> loadKatakana() async {
    await loadData("katakana", katakana);
  }

  Future<void> loadNumbers() async {
    await loadData("numbers", angka);
  }

  Future<void> loadMonths() async {
    await loadData("months", bulan);
  }

  Future<void> loadDates() async {
    await loadData("dates", tanggal);
  }

  Future<void> loadFamily() async {
    await loadData("family", keluarga);
  }

  Future<void> loadAnimals() async {
    await loadData("animals", hewan);
  }

  Future<void> loadFoods() async {
    await loadData("foods", makanan);
  }

  Future<void> loadDrinks() async {
    await loadData("drinks", minuman);
  }

  Future<void> loadJobs() async {
    await loadData("jobs", pekerjaan);
  }

  Future<void> loadObjects() async {
    await loadData("object_vocab", benda);
  }

  List<Map<String, dynamic>> _filter(List<Map<String, dynamic>> data) {
    if (searchQuery.value.isEmpty) {
      return data;
    }

    return data.where((item) {
      final character = item["character"]?.toString().toLowerCase() ?? "";

      final romaji = item["romaji"]?.toString().toLowerCase() ?? "";

      final meaning = item["meaning"]?.toString().toLowerCase() ?? "";

      final query = searchQuery.value.toLowerCase();

      return character.contains(query) ||
          romaji.contains(query) ||
          meaning.contains(query);
    }).toList();
  }

  List<Map<String, dynamic>> get filteredHiragana => _filter(hiragana);

  List<Map<String, dynamic>> get filteredKatakana => _filter(katakana);

  List<Map<String, dynamic>> get filteredAngka => _filter(angka);

  List<Map<String, dynamic>> get filteredBulan => _filter(bulan);

  List<Map<String, dynamic>> get filteredTanggal => _filter(tanggal);

  List<Map<String, dynamic>> get filteredKeluarga => _filter(keluarga);

  List<Map<String, dynamic>> get filteredHewan => _filter(hewan);

  List<Map<String, dynamic>> get filteredMakanan => _filter(makanan);

  List<Map<String, dynamic>> get filteredMinuman => _filter(minuman);

  List<Map<String, dynamic>> get filteredPekerjaan => _filter(pekerjaan);

  List<Map<String, dynamic>> get filteredBenda => _filter(benda);

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  Future<void> changeTab(int index) async {
    selectedIndex.value = index;
    searchQuery.value = "";

    Get.focusScope?.unfocus();

    switch (index) {
      case 0:
        if (hiragana.isEmpty) {
          await loadHiragana();
        }
        break;

      case 1:
        if (katakana.isEmpty) {
          await loadKatakana();
        }
        break;

      case 2:
        if (angka.isEmpty) {
          await loadNumbers();
        }
        break;

      case 3:
        if (bulan.isEmpty) {
          await loadMonths();
        }
        break;

      case 4:
        if (tanggal.isEmpty) {
          await loadDates();
        }
        break;

      case 5:
        if (keluarga.isEmpty) {
          await loadFamily();
        }
        break;

      case 6:
        if (hewan.isEmpty) {
          await loadAnimals();
        }
        break;

      case 7:
        if (makanan.isEmpty) {
          await loadFoods();
        }
        break;

      case 8:
        if (minuman.isEmpty) {
          await loadDrinks();
        }
        break;

      case 9:
        if (pekerjaan.isEmpty) {
          await loadJobs();
        }
        break;

      case 10:
        if (benda.isEmpty) {
          await loadObjects();
        }
        break;
    }
  }
}
