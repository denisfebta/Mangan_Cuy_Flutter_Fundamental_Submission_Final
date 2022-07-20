import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../common/styles.dart';
import '../ui/favorite_restaurant.dart';
import '../ui/main_page.dart';
import '../ui/preference_page.dart';
import '../ui/search_restaurant.dart';

class BottomNavigation extends StatefulWidget {
  static const routeName = '/bottom_navigation';

  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int indexBottomNav = 0;
  List<Widget> widgetOptions = [
    MainPage(),  SearchRestaurant(), FavoriteRestaurant(), PreferencePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions.elementAt(indexBottomNav),
      bottomNavigationBar: SalomonBottomBar(
          onTap: (index) {
            setState(() {
              indexBottomNav = index;
            });
          },
          currentIndex: indexBottomNav,
          items: [
            SalomonBottomBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
                selectedColor: secondaryColor),
            SalomonBottomBarItem(
                icon: Icon(Icons.search),
                title: Text("Search"),
                selectedColor: secondaryColor),
            SalomonBottomBarItem(
                icon: Icon(Icons.favorite_border),
                title: Text("Favorite"),
                selectedColor: secondaryColor),
            SalomonBottomBarItem(
                icon: Icon(Icons.settings),
                title: Text("Preference"),
                selectedColor: secondaryColor),
          ]),
    );
  }
}
