import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'app/data/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final box = GetStorage();

  final token = box.read('token');

  runApp(
    MyApp(
      initialRoute:
          token != null
              ? Routes.MAIN
              : AppPages.INITIAL,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kotoba App",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      theme: AppTheme.light,
    );
  }
}