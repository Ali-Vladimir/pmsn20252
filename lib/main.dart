import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pmsn20252/firebase_options.dart';
import 'package:pmsn20252/models/character.dart';
import 'package:pmsn20252/screens/login_screen.dart';
import 'package:pmsn20252/screens/register_screen.dart';
import 'package:pmsn20252/screens/home_screen.dart';
import 'package:pmsn20252/screens/character_details.dart';
import 'package:pmsn20252/screens/cosmic/home_screen_cosmic.dart';
import 'package:pmsn20252/screens/cosmic/favorites_screen.dart';
import 'package:pmsn20252/screens/cosmic/profile_screen.dart';
import 'package:pmsn20252/screens/add_song_screen.dart';
import 'package:pmsn20252/utils/theme_app.dart';
import 'package:pmsn20252/utils/value_listener.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
            '/register': (context) => const RegisterScreen(),
            '/add-song': (context) => const AddSongScreen(),
            '/character-details': (context) => CharacterDetailsScreen(
              character:
                  ModalRoute.of(context)!.settings.arguments as Character,
            ),
          },
          title: 'Fighter App',
          home: LoginScreen(),
        );
      },
    );
  }
}
