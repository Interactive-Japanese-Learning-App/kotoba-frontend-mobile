import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';

class NihongoView extends StatelessWidget {
  const NihongoView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.white,

        body: SafeArea(
          child: Column(
            children: [
              /// 🔷 HEADER
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back, color: AppColors.primary),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Nihongo Basics",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔴 TAB BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: "Hiragana"),
                    Tab(text: "Katakana"),
                    Tab(text: "Angka"),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// 🔍 SEARCH
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColors.neutral,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.grey),
                      hintText: "Cari huruf...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// 📚 CONTENT
              Expanded(
                child: TabBarView(
                  children: [
                    _gridHiragana(),
                    Center(child: Text("Katakana")),
                    Center(child: Text("Angka")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔷 GRID HIRAGANA
  Widget _gridHiragana() {
    final data = [
      {"char": "あ", "romaji": "a"},
      {"char": "い", "romaji": "i"},
      {"char": "う", "romaji": "u"},
      {"char": "え", "romaji": "e"},
      {"char": "お", "romaji": "o"},
      {"char": "か", "romaji": "ka"},
      {"char": "き", "romaji": "ki"},
      {"char": "く", "romaji": "ku"},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final item = data[index];

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              /// 🔤 ROMAJI (pojok)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    item["romaji"]!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),

              /// 🔤 HURUF
              Center(
                child: Text(
                  item["char"]!,
                  style: TextStyle(
                    fontSize: 60,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// 🔤 LABEL
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: const Center(
                  child: Text(
                    "HIRAGANA",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
