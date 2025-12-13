import 'package:flutter/material.dart';
import 'package:pmsn20252/screens/home_screen.dart';
import 'package:pmsn20252/screens/cosmic/home_screen_cosmic.dart';
import 'package:pmsn20252/screens/cosmic/favorites_screen.dart';
import 'package:pmsn20252/screens/cosmic/profile_screen.dart';
import 'package:pmsn20252/screens/cosmic/planets_list_screen.dart';
import 'package:pmsn20252/screens/cosmic/reservations_calendar_screen.dart';
import 'package:pmsn20252/utils/theme_app.dart';
import 'package:pmsn20252/utils/value_listener.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar sqflite para web
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  
  runApp(const MyApp());
}

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
            '/home-cosmic': (context) => HomeScreenCosmic(),
            '/favorites': (context) => FavoritesScreen(),
            '/profile': (context) => ProfileScreen(),
            '/planets': (context) => PlanetsListScreen(),
            '/calendar': (context) => ReservationsCalendarScreen(),
          },
          title: 'Cosmic Explorer',
          home: const HomeScreen(),
        );
      },
    );
  }
}
