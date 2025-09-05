import 'package:flutter/material.dart';
import 'package:pmsn20252/screens/login_screen.dart';
import 'package:pmsn20252/screens/home_screen.dart';
import 'package:pmsn20252/utils/theme_app.dart';
import 'package:pmsn20252/utils/value_listener.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ValueListener.updTheme,
      builder: (context, value, _) {
        return MaterialApp(
          theme: value ? ThemeApp.lightTheme() : ThemeApp.darkTheme(),
          routes: {
            '/home': (context) => const HomeScreen(),
          },
          title: 'Material App',
          home: const LoginScreen(),
        );
      }
    );
  }
}