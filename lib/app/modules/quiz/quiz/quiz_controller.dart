import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/quiz_section_model.dart';
import '../../../data/services/api_service.dart';

class QuizController extends GetxController {
  /// =========================
  /// LOADING
  /// =========================
  final isLoading = false.obs;

  /// =========================
  /// SECTION DARI BACKEND
  /// =========================
  final sections = <QuizSection>[].obs;

  /// =========================
  /// PROGRESS USER
  /// =========================
  final currentSection = 1.obs;
  final currentQuestion = 1.obs;
  final currentSectionId = "".obs;

  /// =========================
  /// COMPLETED QUESTIONS
  /// =========================
  final completedQuestions = <int>[].obs;

  /// =========================
  /// STORAGE
  /// =========================
  final box = GetStorage();

  String? get userId => box.read('userId');

  /// =========================
  /// RESULT QUIZ
  /// =========================
  final benar = 0.obs;
  final currentIndex = 0.obs;

  final totalSoal = 5;
  final xpPerSoal = 20;

  final pelafalanAccuracy = 0.0.obs;

  int get maxXp => totalSoal * xpPerSoal;

  /// XP berdasarkan progress backend
  int get xp => completedQuestions.length * xpPerSoal;

  /// =========================
  /// INIT
  /// =========================
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;

      await loadSections();
      await loadProgress();
    } catch (e) {
      print("Quiz Load Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// LOAD SECTION
  /// =========================
  Future<void> loadSections() async {
    try {
      final response = await ApiService.getQuizSections();

      if (response["success"] == true) {
        sections.value = (response["data"] as List)
            .map((e) => QuizSection.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Load Section Error: $e");
    }
  }

  /// =========================
  /// LOAD PROGRESS
  /// =========================
  Future<void> loadProgress() async {
    try {
      if (userId == null) return;
      if (sections.isEmpty) return;

      final firstSectionId = sections.first.id;

      final response = await ApiService.getQuizProgress(
        userId: userId!,
        sectionId: firstSectionId,
      );

      if (response["success"] == true) {
        final data = response["data"];

        currentSectionId.value = data["sectionId"]?.toString() ?? "";

        currentQuestion.value = data["currentQuestion"] ?? 1;

        /// AMBIL COMPLETED QUESTIONS DARI DATABASE
        completedQuestions.value = List<int>.from(
          data["completedQuestions"] ?? [],
        );

        final sectionCompleted = data["sectionCompleted"] ?? false;

        currentSection.value = (sectionCompleted && sections.length > 1)
            ? 2
            : 1;

        print("COMPLETED QUESTIONS = $completedQuestions");

        print("XP RESULT = $xp");
      }
    } catch (e) {
      print("Load Progress Error: $e");
    }
  }

  /// =========================
  /// LOCK / UNLOCK
  /// =========================
  bool isSectionUnlocked(int sectionNumber) {
    return sectionNumber <= currentSection.value;
  }

  bool isQuestionUnlocked(int sectionNumber, int questionNumber) {
    if (sectionNumber < currentSection.value) {
      return true;
    }

    if (sectionNumber == currentSection.value) {
      return questionNumber <= currentQuestion.value;
    }

    return false;
  }

  /// =========================
  /// RESULT QUIZ
  /// =========================
  void tambahBenar() {
    benar.value++;
  }

  void jawab({required bool isBenar}) {
    if (isBenar) {
      tambahBenar();
    }

    nextSoal();
  }

  void nextSoal() {
    if (currentIndex.value < totalSoal - 1) {
      currentIndex.value++;
    }
  }

  double get progress {
    return xp / maxXp;
  }

  double get accuracy {
    return (benar.value / totalSoal) * 100;
  }

  int get persen {
    return ((xp / maxXp) * 100).toInt();
  }

  /// =========================
  /// PELAFALAN
  /// =========================
  void setPelafalanAccuracy(double value) {
    pelafalanAccuracy.value = value;
  }

  /// =========================
  /// REFRESH PROGRESS
  /// =========================
  Future<void> refreshProgress() async {
    await loadProgress();
  }

  /// =========================
  /// RESET
  /// =========================
  void resetQuiz() {
    benar.value = 0;
    currentIndex.value = 0;
    pelafalanAccuracy.value = 0;
  }
}
