import 'package:flutter/material.dart';
import 'package:pmsn20252/utils/value_listener.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:pmsn20252/screens/cosmic/home_screen_cosmic.dart';
import 'package:pmsn20252/screens/cosmic/favorites_screen.dart';
import 'package:pmsn20252/screens/cosmic/profile_screen.dart';
import 'package:pmsn20252/screens/cosmic/planets_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color navigationBarColor = Color(0xFF091422);
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
        backgroundColor: Color(0xFF091422),
        title: Row(
          children: [
            Icon(Icons.explore, color: Colors.cyan),
            SizedBox(width: 8),
            Text(
              'Cosmic Explorer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.cyan),
            onPressed: () {
              Navigator.pushNamed(context, '/calendar');
            },
          ),
          ValueListenableBuilder(
            valueListenable: ValueListener.updTheme,
            builder: (context, value, child) {
              return IconButton(
                icon: Icon(
                  value ? Icons.nightlight : Icons.sunny,
                  color: Colors.white,
                ),
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
          HomeScreenCosmic(),
          PlanetsListScreen(),
          FavoritesScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: navigationBarColor,
        waterDropColor: Colors.cyan,
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
            filledIcon: Icons.home,
            outlinedIcon: Icons.home_outlined,
          ),
          BarItem(
            filledIcon: Icons.public,
            outlinedIcon: Icons.public_outlined,
          ),
          BarItem(
            filledIcon: Icons.favorite_rounded,
            outlinedIcon: Icons.favorite_border_rounded,
          ),
          BarItem(
            filledIcon: Icons.person,
            outlinedIcon: Icons.person_outline,
          ),
        ],
      ),
    );
  }
}
