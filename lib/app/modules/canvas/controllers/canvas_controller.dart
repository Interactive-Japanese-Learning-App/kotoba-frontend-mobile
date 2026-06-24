import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotoba_app/app/widgets/kana_background_painter.dart';
import '../../../data/models/stroke_model.dart';
import '../../../data/services/stroke_service.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/services/api_service.dart';

class CanvasController extends GetxController {
  final List<Offset?> points = [];
  List<Offset> currentStrokePoints = [];

  String kanaAssetPath(String kana) {
    switch (kana) {
      // =====================
      // HIRAGANA
      // =====================
      case 'あ':
        return 'assets/kana_images/あ_03042.svg';
      case 'い':
        return 'assets/kana_images/い_03044.svg';
      case 'う':
        return 'assets/kana_images/う_03046.svg';
      case 'え':
        return 'assets/kana_images/え_03048.svg';
      case 'お':
        return 'assets/kana_images/お_0304a.svg';

      case 'か':
        return 'assets/kana_images/か_0304b.svg';
      case 'き':
        return 'assets/kana_images/き_0304d.svg';
      case 'く':
        return 'assets/kana_images/く_0304f.svg';
      case 'け':
        return 'assets/kana_images/け_03051.svg';
      case 'こ':
        return 'assets/kana_images/こ_03053.svg';

      case 'さ':
        return 'assets/kana_images/さ_03055.svg';
      case 'し':
        return 'assets/kana_images/し_03057.svg';
      case 'す':
        return 'assets/kana_images/す_03059.svg';
      case 'せ':
        return 'assets/kana_images/せ_0305b.svg';
      case 'そ':
        return 'assets/kana_images/そ_0305d.svg';

      case 'た':
        return 'assets/kana_images/た_0305f.svg';
      case 'ち':
        return 'assets/kana_images/ち_03061.svg';
      case 'つ':
        return 'assets/kana_images/つ_03064.svg';
      case 'て':
        return 'assets/kana_images/て_03066.svg';
      case 'と':
        return 'assets/kana_images/と_03068.svg';

      case 'な':
        return 'assets/kana_images/な_0306a.svg';
      case 'に':
        return 'assets/kana_images/に_0306b.svg';
      case 'ぬ':
        return 'assets/kana_images/ぬ_0306c.svg';
      case 'ね':
        return 'assets/kana_images/ね_0306d.svg';
      case 'の':
        return 'assets/kana_images/の_0306e.svg';

      case 'は':
        return 'assets/kana_images/は_0306f.svg';
      case 'ひ':
        return 'assets/kana_images/ひ_03072.svg';
      case 'ふ':
        return 'assets/kana_images/ふ_03075.svg';
      case 'へ':
        return 'assets/kana_images/へ_03078.svg';
      case 'ほ':
        return 'assets/kana_images/ほ_0307b.svg';

      case 'ま':
        return 'assets/kana_images/ま_0307e.svg';
      case 'み':
        return 'assets/kana_images/み_0307f.svg';
      case 'む':
        return 'assets/kana_images/む_03080.svg';
      case 'め':
        return 'assets/kana_images/め_03081.svg';
      case 'も':
        return 'assets/kana_images/も_03082.svg';

      case 'や':
        return 'assets/kana_images/や_03084.svg';
      case 'ゆ':
        return 'assets/kana_images/ゆ_03086.svg';
      case 'よ':
        return 'assets/kana_images/よ_03088.svg';

      case 'ら':
        return 'assets/kana_images/ら_03089.svg';
      case 'り':
        return 'assets/kana_images/り_0308a.svg';
      case 'る':
        return 'assets/kana_images/る_0308b.svg';
      case 'れ':
        return 'assets/kana_images/れ_0308c.svg';
      case 'ろ':
        return 'assets/kana_images/ろ_0308d.svg';

      case 'わ':
        return 'assets/kana_images/わ_0308f.svg';
      case 'を':
        return 'assets/kana_images/を_03092.svg';
      case 'ん':
        return 'assets/kana_images/ん_03093.svg';

      // =====================
      // KATAKANA
      // =====================
      case 'ア':
        return 'assets/kana_images/ア_030a2.svg';
      case 'イ':
        return 'assets/kana_images/イ_030a4.svg';
      case 'ウ':
        return 'assets/kana_images/ウ_030a6.svg';
      case 'エ':
        return 'assets/kana_images/エ_030a8.svg';
      case 'オ':
        return 'assets/kana_images/オ_030aa.svg';

      case 'カ':
        return 'assets/kana_images/カ_030ab.svg';
      case 'キ':
        return 'assets/kana_images/キ_030ad.svg';
      case 'ク':
        return 'assets/kana_images/ク_030af.svg';
      case 'ケ':
        return 'assets/kana_images/ケ_030b1.svg';
      case 'コ':
        return 'assets/kana_images/コ_030b3.svg';

      case 'サ':
        return 'assets/kana_images/サ_030b5.svg';
      case 'シ':
        return 'assets/kana_images/シ_030b7.svg';
      case 'ス':
        return 'assets/kana_images/ス_030b9.svg';
      case 'セ':
        return 'assets/kana_images/セ_030bb.svg';
      case 'ソ':
        return 'assets/kana_images/ソ_030bd.svg';

      case 'タ':
        return 'assets/kana_images/タ_030bf.svg';
      case 'チ':
        return 'assets/kana_images/チ_030c1.svg';
      case 'ツ':
        return 'assets/kana_images/ツ_030c4.svg';
      case 'テ':
        return 'assets/kana_images/テ_030c6.svg';
      case 'ト':
        return 'assets/kana_images/ト_030c8.svg';

      case 'ナ':
        return 'assets/kana_images/ナ_030ca.svg';
      case 'ニ':
        return 'assets/kana_images/ニ_030cb.svg';
      case 'ヌ':
        return 'assets/kana_images/ヌ_030cc.svg';
      case 'ネ':
        return 'assets/kana_images/ネ_030cd.svg';
      case 'ノ':
        return 'assets/kana_images/ノ_030ce.svg';

      case 'ハ':
        return 'assets/kana_images/ハ_030cf.svg';
      case 'ヒ':
        return 'assets/kana_images/ヒ_030d2.svg';
      case 'フ':
        return 'assets/kana_images/フ_030d5.svg';
      case 'ヘ':
        return 'assets/kana_images/ヘ_030d8.svg';
      case 'ホ':
        return 'assets/kana_images/ホ_030db.svg';

      case 'マ':
        return 'assets/kana_images/マ_030de.svg';
      case 'ミ':
        return 'assets/kana_images/ミ_030df.svg';
      case 'ム':
        return 'assets/kana_images/ム_030e0.svg';
      case 'メ':
        return 'assets/kana_images/メ_030e1.svg';
      case 'モ':
        return 'assets/kana_images/モ_030e2.svg';

      case 'ヤ':
        return 'assets/kana_images/ヤ_030e4.svg';
      case 'ユ':
        return 'assets/kana_images/ユ_030e6.svg';
      case 'ヨ':
        return 'assets/kana_images/ヨ_030e8.svg';

      case 'ラ':
        return 'assets/kana_images/ラ_030e9.svg';
      case 'リ':
        return 'assets/kana_images/リ_030ea.svg';
      case 'ル':
        return 'assets/kana_images/ル_030eb.svg';
      case 'レ':
        return 'assets/kana_images/レ_030ec.svg';
      case 'ロ':
        return 'assets/kana_images/ロ_030ed.svg';

      case 'ワ':
        return 'assets/kana_images/ワ_030ef.svg';
      case 'ヲ':
        return 'assets/kana_images/ヲ_030f2.svg';
      case 'ン':
        return 'assets/kana_images/ン_030f3.svg';

      default:
        return 'assets/kana_images/あ_03042.svg';
    }
  }

  final RxList<StrokeData> strokeData = <StrokeData>[].obs;

  final currentStroke = 0.obs;
  final strokeStatus = ''.obs;

  bool isDrawing = false;
  bool strokeLocked = false;

  Offset? lastPoint;

  final label = ''.obs;
  final kana = ''.obs;
  final type = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};

    label.value = args['label'] ?? '';
    kana.value = args['kana'] ?? '';
    type.value = args['type'] ?? '';

    loadStrokeJson();
  }

  Future<void> loadStrokeJson() async {
    final data = await StrokeService.loadStroke(
      kana.value,
      type.value.toLowerCase(),
    );

    strokeData.assignAll(data);
    update();
  }

  Offset transformPoint(double x, double y) {
    const jsonSize = 300.0;

    final scaleX = KanaBackgroundPainter.lastWidth / jsonSize;
    final scaleY = KanaBackgroundPainter.lastHeight / jsonSize;

    // Offset kalibrasi agar titik user sejajar dengan stroke guide.
    // Angka ini bisa disesuaikan jika rendering background mengalami perbedaan scaling.
    const adjustX = 0.0;
    const adjustY = 0.0;

    return Offset(
      KanaBackgroundPainter.lastX + (x * scaleX) + adjustX,
      KanaBackgroundPainter.lastY + (y * scaleY) + adjustY,
    );
  }

  void startStroke(Offset point) {
    if (strokeLocked) return;
    if (currentStroke.value >= strokeData.length) return;

    isDrawing = true;
    lastPoint = point;
    currentStrokePoints = [point];
    update();
  }

  void addPoint(Offset point) {
    if (!isDrawing || strokeLocked) return;

    if (lastPoint != null) {
      final dist = (point - lastPoint!).distance;
      if (dist > 80) {
        isDrawing = false;
        strokeStatus.value = "salah";
        currentStrokePoints.clear();
        _resetStatus();
        return;
      }
      if (dist < 2) return;
    }

    lastPoint = point;
    currentStrokePoints.add(point);
    update();
  }

  Future<void> endStrokeCheck() async {
    if (!isDrawing) return;

    isDrawing = false;

    final target = strokeData[currentStroke.value];
    final end = transformPoint(target.end.x, target.end.y);

    final dist = (lastPoint! - end).distance;
    const tolerance = 35.0;

    if (dist < tolerance) {
      strokeStatus.value = "benar";

      points.addAll(currentStrokePoints);
      points.add(null);

      currentStrokePoints = [];
      currentStroke.value++;

      if (isCompleted()) {
        final box = GetStorage();
        final userId = box.read('userId');

        if (userId != null) {
          await ApiService.saveActivity(
            userId: userId,
            activityType: "kana_writing",
            title: "Latihan Menulis",
            detail: "${type.value} • ${kana.value} (${label.value})"
          );
        }
      }
      _resetStatus();
    } else {
      strokeStatus.value = "salah";
      currentStrokePoints.clear();
      _resetStatus();
    }

    lastPoint = null;
    update();
  }

  // ❗ TIDAK AUTO EXIT LAGI
  bool isCompleted() {
    return currentStroke.value >= strokeData.length;
  }

  void _resetStatus() {
    strokeLocked = true;

    Future.delayed(const Duration(milliseconds: 1200), () {
      strokeStatus.value = "";
      strokeLocked = false;
      update();
    });
  }

  void clearCanvas() {
    points.clear();
    currentStrokePoints.clear();
    currentStroke.value = 0;

    isDrawing = false;
    strokeLocked = false;
    lastPoint = null;
    strokeStatus.value = "";

    update();
  }

  void undo() {
    if (points.isEmpty) return;

    isDrawing = false;
    strokeLocked = false;
    lastPoint = null;
    strokeStatus.value = "";

    if (points.last == null) {
      points.removeLast();
    }

    while (points.isNotEmpty && points.last != null) {
      points.removeLast();
    }

    if (currentStroke.value > 0) {
      currentStroke.value--;
    }

    update();
  }
}
