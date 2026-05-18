import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/data/theme/app_theme.dart'; 
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Kotoba App",

      // ✅ ROUTE AWAL (Welcome)
      initialRoute: AppPages.INITIAL,

      // ✅ ROUTING
      getPages: AppPages.routes,

      // ✅ THEME 
      theme: AppTheme.light,

      // ✅ fallback kalau route tidak ada
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const Scaffold(
          body: Center(child: Text("Page Not Found")),
        ),
      ),
    );
  }
}