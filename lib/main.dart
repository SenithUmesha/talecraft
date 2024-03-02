import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'view/onBoarding/splash_screen.dart';

main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<int, Color> color = {
    50: Color(0xFF0E0D0D),
    100: Color(0xFF0E0D0D),
    200: Color(0xFF0E0D0D),
    300: Color(0xFF0E0D0D),
    400: Color(0xFF0E0D0D),
    500: Color(0xFF0E0D0D),
    600: Color(0xFF0E0D0D),
    700: Color(0xFF0E0D0D),
    800: Color(0xFF0E0D0D),
    900: Color(0xFF0E0D0D),
  };

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF0E0D0D, color),
        useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
