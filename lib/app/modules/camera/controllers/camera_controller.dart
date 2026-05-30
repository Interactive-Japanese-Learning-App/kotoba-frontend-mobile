import 'package:camera/camera.dart' as cam;
import 'package:flutter_vision/flutter_vision.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:async';
import '../../../widgets/app_snackbar.dart'; // Menambahkan import untuk Timer

// Model data baru untuk menampung properti tiap objek yang terdeteksi
class DetectedObject {
  final String jp;
  final String rm;
  final String tr;
  final double x;
  final double y;
  final double w;
  final double h;

  DetectedObject({
    required this.jp,
    required this.rm,
    required this.tr,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });
}

class CameraController extends GetxController {
  final isCameraReady = false.obs;
  final isDetecting = false.obs;
  final isProcessing = false.obs;

  late cam.CameraController cameraController;
  late FlutterVision vision;

  bool isLoaded = false;
  Timer? _detectionTimer; // Menambahkan variabel Timer

  /// LIST OBJEK TERDETEKSI MULTIPEL
  final detectedObjects = <DetectedObject>[].obs;

  final Map<String, Map<String, String>> objectData = {
    "person": {"jp": "ひと", "rm": "Hito", "tr": "Orang"},
    "bicycle": {"jp": "じてんしゃ", "rm": "Jitensha", "tr": "Sepeda"},
    "car": {"jp": "くるま", "rm": "Kuruma", "tr": "Mobil"},
    "motorcycle": {"jp": "バイク", "rm": "Baiku", "tr": "Sepeda Motor"},
    "airplane": {"jp": "ひこうき", "rm": "Hikouki", "tr": "Pesawat Terbang"},
    "bus": {"jp": "バス", "rm": "Basu", "tr": "Bus"},
    "train": {"jp": "でんしゃ", "rm": "Densha", "tr": "Kereta Api"},
    "truck": {"jp": "トラック", "rm": "Torakku", "tr": "Truk"},
    "boat": {"jp": "ふね", "rm": "Fune", "tr": "Perahu"},
    "traffic light": {"jp": "しんごう", "rm": "Shingou", "tr": "Lampu Lalu Lintas"},
    "fire hydrant": {"jp": "しょうかせん", "rm": "Shoukasen", "tr": "Hidran Pemadam"},
    "stop sign": {"jp": "とまれ", "rm": "Tomare", "tr": "Rambu Stop"},
    "parking meter": {
      "jp": "パーキングメーター",
      "rm": "Paakingu meetaa",
      "tr": "Meteran Parkir",
    },
    "bench": {"jp": "ベンチ", "rm": "Benchi", "tr": "Bangku Taman"},
    "bird": {"jp": "とり", "rm": "Tori", "tr": "Burung"},
    "cat": {"jp": "ねこ", "rm": "Neko", "tr": "Kucing"},
    "dog": {"jp": "いぬ", "rm": "Inu", "tr": "Anjing"},
    "horse": {"jp": "うま", "rm": "Uma", "tr": "Kuda"},
    "sheep": {"jp": "ひつじ", "rm": "Hitsuji", "tr": "Domba"},
    "cow": {"jp": "うし", "rm": "Ushi", "tr": "Sapi"},
    "elephant": {"jp": "ぞう", "rm": "Zou", "tr": "Gajah"},
    "bear": {"jp": "くま", "rm": "Kuma", "tr": "Beruang"},
    "zebra": {"jp": "シマウマ", "rm": "Shimauma", "tr": "Zebra"},
    "giraffe": {"jp": "キリン", "rm": "Kirin", "tr": "Jerapah"},
    "backpack": {"jp": "リュックサック", "rm": "Ryukkusakku", "tr": "Tas Ransel"},
    "umbrella": {"jp": "かさ", "rm": "Kasa", "tr": "Payung"},
    "handbag": {"jp": "ハンドバッグ", "rm": "Handobaggu", "tr": "Tas Tangan"},
    "tie": {"jp": "ネクタイ", "rm": "Nekutai", "tr": "Dasi"},
    "suitcase": {"jp": "スーツケース", "rm": "Suutsukeesu", "tr": "Koper"},
    "frisbee": {"jp": "フリスピー", "rm": "Futisubii", "tr": "Frisbee"},
    "skis": {"jp": "スキーいた", "rm": "Sukii-ita", "tr": "Papan Ski"},
    "snowboard": {"jp": "スノーボード", "rm": "Sunouboudo", "tr": "Snowboard"},
    "sports ball": {"jp": "ボール", "rm": "Booru", "tr": "Bola Olahraga"},
    "kite": {"jp": "たこ", "rm": "Tako", "tr": "Layang-layang"},
    "baseball bat": {"jp": "バット", "rm": "Batto", "tr": "Pemukul Bisbol"},
    "baseball glove": {
      "jp": "グローブ",
      "rm": "Guroobu",
      "tr": "Sarung Tangan Bisbol",
    },
    "skateboard": {"jp": "スケートボード", "rm": "Sukeetoboodo", "tr": "Skateboard"},
    "surfboard": {"jp": "サーフボード", "rm": "Saafuboodo", "tr": "Papan Surfing"},
    "tennis racket": {"jp": "ラケット", "rm": "Raketto", "tr": "Raket Tenis"},
    "bottle": {"jp": "ボトル", "rm": "Botoru", "tr": "Botol"},
    "wine glass": {"jp": "ワイングラス", "rm": "Waingurasu", "tr": "Gelas Anggur"},
    "cup": {"jp": "コップ", "rm": "Koppu", "tr": "Cangkir"},
    "fork": {"jp": "フォーク", "rm": "Fooku", "tr": "Garpu"},
    "knife": {"jp": "ナイフ", "rm": "Naifu", "tr": "Pisau"},
    "spoon": {"jp": "スプーン", "rm": "Supuun", "tr": "Sendok"},
    "bowl": {"jp": "おわん", "rm": "Owan", "tr": "Mangkuk"},
    "banana": {"jp": "バナナ", "rm": "Banana", "tr": "Pisang"},
    "apple": {"jp": "りんご", "rm": "Ringo", "tr": "Apel"},
    "sandwich": {"jp": "サンドイッチ", "rm": "Sandoicchi", "tr": "Roti Lapis"},
    "orange": {"jp": "オレンジ", "rm": "Orenji", "tr": "Jeruk"},
    "broccoli": {"jp": "ブロッコリー", "rm": "Burokkorii", "tr": "Brokoli"},
    "carrot": {"jp": "にんじん", "rm": "Ninjin", "tr": "Wortel"},
    "hot dog": {"jp": "ホットドッグ", "rm": "Hottodoggu", "tr": "Hot Dog"},
    "pizza": {"jp": "ピザ", "rm": "Piza", "tr": "Piza"},
    "donut": {"jp": "ドーナツ", "rm": "Doonatsu", "tr": "Donat"},
    "cake": {"jp": "ケーキ", "rm": "Keeki", "tr": "Kue"},
    "chair": {"jp": "いす", "rm": "Isu", "tr": "Kursi"},
    "couch": {"jp": "ソファー", "rm": "Sofaa", "tr": "Sofa"},
    "potted plant": {"jp": "うえきばち", "rm": "Uekibachi", "tr": "Tanaman Pot"},
    "bed": {"jp": "ベッド", "rm": "Beddo", "tr": "Tempat Tidur"},
    "dining table": {"jp": "しょくたく", "rm": "Shokutaku", "tr": "Meja Makan"},
    "toilet": {"jp": "トイレット", "rm": "Toiretto", "tr": "Toilet"},
    "tv": {"jp": "テレビ", "rm": "Terebi", "tr": "TV"},
    "laptop": {"jp": "パソコン", "rm": "Pasokon", "tr": "Laptop"},
    "mouse": {"jp": "マウス", "rm": "Mausu", "tr": "Mouse Computer"},
    "remote": {"jp": "リモコン", "rm": "Rimokon", "tr": "Remot"},
    "keyboard": {"jp": "キーボード", "rm": "Kiiboodo", "tr": "Keyboard"},
    "cell phone": {"jp": "けいたいでおわ", "rm": "Keitai denwa", "tr": "HP"},
    "microwave": {"jp": "トースター", "rm": "Toosutaa", "tr": "Microwave"},
    "oven": {"jp": "オーブン", "rm": "Oobun", "tr": "Oven"},
    "toaster": {"jp": "トースター", "rm": "Toosutaa", "tr": "Pemanggang Roti"},
    "sink": {"jp": "ながしだい", "rm": "Nagashidai", "tr": "Wastafel Dapur"},
    "refrigerator": {"jp": "れいぞうこ", "rm": "Reizouko", "tr": "Kulkas"},
    "book": {"jp": "ほん", "rm": "Hon", "tr": "Buku"},
    "clock": {"jp": "とけい", "rm": "Tokei", "tr": "Jam"},
    "vase": {"jp": "かびん", "rm": "Kabin", "tr": "Vas Bunga"},
    "scissors": {"jp": "はさみ", "rm": "Hasami", "tr": "Gunting"},
    "teddy bear": {"jp": "テディベア", "rm": "Tedibea", "tr": "Beruang Mainan"},
    "hair drier": {"jp": "ドライヤー", "rm": "Doraiyaa", "tr": "Pengering Rambut"},
    "toothbrush": {"jp": "はぶらし", "rm": "Haburashi", "tr": "Sikat Gigi"},
  };

  @override
  void onInit() {
    super.onInit();
    vision = FlutterVision();
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await cam.availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == cam.CameraLensDirection.back,
    );

    cameraController = cam.CameraController(
      backCamera,
      cam.ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize();
    await loadModel();
    isCameraReady.value = true;
  }

  Future<void> loadModel() async {
    await vision.loadYoloModel(
      labels: 'assets/ml/labels.txt',
      modelPath: 'assets/ml/yolov8n_float32.tflite',
      modelVersion: "yolov8",
      quantization: false,
      numThreads: 2,
      useGpu: false,
    );
    isLoaded = true;
  }

  Future<void> captureAndDetect() async {
    if (!isLoaded || isProcessing.value) return;

    try {
      isProcessing.value = true;
      _clearDetection();

      final cam.XFile photo = await cameraController.takePicture();
      final File file = File(photo.path);
      final bytes = await file.readAsBytes();

      double imageWidth = 720.0;
      double imageHeight = 1280.0;

      final result = await vision.yoloOnImage(
        bytesList: bytes,
        imageHeight: imageHeight.toInt(),
        imageWidth: imageWidth.toInt(),
        iouThreshold: 0.4,
        confThreshold: 0.25,
        classThreshold: 0.25,
      );

      if (result.isNotEmpty) {
        final List<DetectedObject> tempObjects = [];

        for (var item in result) {
          final String label = item["tag"]?.toString() ?? "";
          final box = item["box"];

          final data = objectData[label];
          final String jp = data != null ? data["jp"]! : "物体";
          final String rm = data != null ? data["rm"]! : "Buttai";
          final String tr = data != null ? data["tr"]! : label;

          double xMin = box[0] / imageWidth;
          double yMin = box[1] / imageHeight;
          double xMax = box[2] / imageWidth;
          double yMax = box[3] / imageHeight;

          double w = xMax - xMin;
          double h = yMax - yMin;

          tempObjects.add(
            DetectedObject(
              jp: jp,
              rm: rm,
              tr: tr,
              x: xMin,
              y: yMin,
              w: w,
              h: h,
            ),
          );
        }

        detectedObjects.assignAll(tempObjects);
        isDetecting.value = true;

        // Memulai Timer untuk menghapus deteksi setelah 3 menit
        _startDetectionTimer(const Duration(seconds: 15));
      } else {
        AppSnackbar.show(
          title: "Pemberitahuan",
          message: "Objek tidak dikenali. Coba lagi.",
        );
      }
    } catch (e) {
      print("Error kalkulasi YOLO: $e");
    } finally {
      isProcessing.value = false;
    }
  }

  // Fungsi untuk memulai timer
  void _startDetectionTimer(Duration duration) {
    _detectionTimer?.cancel();
    _detectionTimer = Timer(duration, () {
      _clearDetection();
    });
  }

  void _clearDetection() {
    isDetecting.value = false;
    detectedObjects.clear();
    _detectionTimer?.cancel();
  }

  @override
  void onClose() async {
    _detectionTimer?.cancel(); // Pastikan timer bersih saat controller ditutup
    await vision.closeYoloModel();
    cameraController.dispose();
    super.onClose();
  }
}
