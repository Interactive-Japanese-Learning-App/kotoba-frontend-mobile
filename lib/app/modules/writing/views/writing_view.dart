import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../../../widgets/kana_card.dart';

class WritingView extends StatefulWidget {
  const WritingView({super.key});

  @override
  State<WritingView> createState() => _WritingViewState();
}

class _WritingViewState extends State<WritingView> {
  int selectedIndex = 0; // 0 = Hiragana, 1 = Katakana

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

  @override
  Widget build(BuildContext context) {
    final data = selectedIndex == 0 ? hiragana : katakana;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Writing Canvas",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// 🔴 TAB SWITCH
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTab("Hiragana", 0),
                const SizedBox(width: 20),
                _buildTab("Katakana", 1),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔷 GRID
            Expanded(
              child: GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final item = data[index];
                  return KanaCard(
                    label: item['label']!,
                    kana: item['kana']!,
                    type: selectedIndex == 0 ? "HIRAGANA" : "KATAKANA",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔴 TAB UI
  Widget _buildTab(String title, int index) {
    final isActive = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.danger : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}