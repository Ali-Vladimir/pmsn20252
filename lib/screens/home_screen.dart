import 'package:flutter/material.dart';
import 'package:pmsn20252/utils/value_listener.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:pmsn20252/screens/characters_list.dart';
import 'package:pmsn20252/screens/list_songs_screen.dart';
import 'package:pmsn20252/screens/cosmic/favorites_screen.dart';
import 'package:pmsn20252/screens/cosmic/home_screen_cosmic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color navigationBarColor = Colors.pink[100]!;
  int selectedIndex = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 237, 207, 217),
        actions: [
          ValueListenableBuilder(
            valueListenable: ValueListener.updTheme,
            builder: (context, value, child) {
              return IconButton(
                icon: Icon(value ? Icons.nightlight : Icons.sunny),
                onPressed: () {
                  ValueListener.updTheme.value = !ValueListener.updTheme.value;
                },
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: [
          CharactersListScreen(),
          ListSongsScreen(),
          FavoritesScreen(),
          HomeScreenCosmic(),
        ],
      ),
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: navigationBarColor,
        waterDropColor: Colors.pink,
        onItemSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
          pageController.animateToPage(
            selectedIndex,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutQuad,
          );
        },
        selectedIndex: selectedIndex,
        barItems: <BarItem>[
          BarItem(
            filledIcon: Icons.bookmark_rounded,
            outlinedIcon: Icons.bookmark_border_rounded,
          ),
          BarItem(
            filledIcon: Icons.music_note,
            outlinedIcon: Icons.music_note_outlined,
          ),
          BarItem(
            filledIcon: Icons.favorite_rounded,
            outlinedIcon: Icons.favorite_border_rounded,
          ),
          BarItem(
            filledIcon: Icons.email_rounded,
            outlinedIcon: Icons.email_outlined,
          ),
        ],
      ),
    );
  }
}
