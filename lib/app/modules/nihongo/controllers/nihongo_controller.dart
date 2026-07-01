import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kotoba_app/app/data/services/api_service.dart' show ApiService;

class NihongoController extends GetxController {
  final selectedIndex = 0.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  late final Dio dio;

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

  static const String baseUrl = "http://192.168.18.9:5000/api";

  @override
  void onInit() {
    super.onInit();

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );

    saveLearningActivity();
    loadHiragana();
  }

  Future<void> loadData(
    String endpoint,
    RxList<Map<String, dynamic>> target,
  ) async {
    try {
      isLoading.value = true;

      print("========== NIHONGO ==========");
      print("GET : $endpoint");

      final response = await dio.get(endpoint);

      print("STATUS : ${response.statusCode}");
      print("BODY : ${response.data}");

      if (response.statusCode == 200 && response.data["success"] == true) {
        final List<dynamic> data = response.data["data"] ?? [];

        target.assignAll(
          data.map((e) => Map<String, dynamic>.from(e)).toList(),
        );

        print("TOTAL DATA : ${target.length}");
      } else {
        target.clear();
      }
    } on DioException catch (e) {
      print("DIO ERROR : ${e.message}");
      print("RESPONSE : ${e.response?.data}");
    } catch (e) {
      print("ERROR : $e");
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
      title: "Belajar Materi Nihongo Dasar",
      detail: "Baru saja mempelajari materi Nihongo Dasar",
    );
  }

  Future<void> loadHiragana() => loadData("/nihongo/hiragana", hiragana);

  Future<void> loadKatakana() => loadData("/nihongo/katakana", katakana);

  Future<void> loadNumbers() => loadData("/nihongo/numbers", angka);

  Future<void> loadMonths() => loadData("/nihongo/months", bulan);

  Future<void> loadDates() => loadData("/nihongo/dates", tanggal);

  Future<void> loadFamily() => loadData("/nihongo/family", keluarga);

  Future<void> loadAnimals() => loadData("/nihongo/animals", hewan);

  Future<void> loadFoods() => loadData("/nihongo/foods", makanan);

  Future<void> loadDrinks() => loadData("/nihongo/drinks", minuman);

  Future<void> loadJobs() => loadData("/nihongo/jobs", pekerjaan);

  Future<void> loadObjects() => loadData("/nihongo/object_vocab", benda);

  List<Map<String, dynamic>> _filter(List<Map<String, dynamic>> data) {
    if (searchQuery.value.isEmpty) return data;

    final query = searchQuery.value.toLowerCase();

    return data.where((item) {
      final character = item["character"]?.toString().toLowerCase() ?? "";
      final romaji = item["romaji"]?.toString().toLowerCase() ?? "";
      final meaning = item["meaning"]?.toString().toLowerCase() ?? "";

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
        await loadHiragana();
        break;
      case 1:
        await loadKatakana();
        break;
      case 2:
        await loadNumbers();
        break;
      case 3:
        await loadMonths();
        break;
      case 4:
        await loadDates();
        break;
      case 5:
        await loadFamily();
        break;
      case 6:
        await loadAnimals();
        break;
      case 7:
        await loadFoods();
        break;
      case 8:
        await loadDrinks();
        break;
      case 9:
        await loadJobs();
        break;
      case 10:
        await loadObjects();
        break;
    }
  }
}
