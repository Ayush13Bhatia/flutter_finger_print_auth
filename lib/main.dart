import 'package:finger_print_app/share_preference.dart';
import 'package:finger_print_app/splash_screen.dart';
import 'package:flutter/material.dart';

import 'finger_print_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SharedPrefUtils.getValue('fingerPrint', isBool: true) ? const SplashScreen() : const FingerPrintWidget(),
    );
  }
}
