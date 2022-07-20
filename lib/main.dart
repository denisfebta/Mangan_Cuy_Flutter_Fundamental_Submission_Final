import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_project/provider/database_provider.dart';
import 'package:restaurant_project/provider/detail_provider.dart';
import 'package:restaurant_project/provider/preferences_provider.dart';
import 'package:restaurant_project/provider/restaurant_provider.dart';
import 'package:restaurant_project/provider/scheduling_provider.dart';
import 'package:restaurant_project/provider/search_provider.dart';
import 'package:restaurant_project/ui/detail_restaurant.dart';
import 'package:restaurant_project/ui/favorite_restaurant.dart';
import 'package:restaurant_project/ui/main_page.dart';
import 'package:restaurant_project/ui/preference_page.dart';
import 'package:restaurant_project/ui/search_restaurant.dart';
import 'package:restaurant_project/ui/splash_screen.dart';
import 'package:restaurant_project/utils/background_service.dart';
import 'package:restaurant_project/utils/notification_helper.dart';
import 'package:restaurant_project/widget/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/navigation.dart';
import 'data/api/api_service.dart';
import 'data/db/database_helper.dart';
import 'data/model/restaurant.dart';
import 'data/preferences/preferences_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => RestaurantProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider(
            create: (_) => DetailProvider(apiService: ApiService(), id: ''),
          ),
          ChangeNotifierProvider(
            create: (_) => SearchProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider(
            create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
          ),
          ChangeNotifierProvider<SchedulingProvider>(
            create: (_) => SchedulingProvider(),
          ),
          ChangeNotifierProvider<PreferencesProvider>(
            create: (_) => PreferencesProvider(
              preferencesHelper: PreferencesHelper(
                sharedPreferences: SharedPreferences.getInstance(),
              ),
            ),
          ),
        ],
        child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mangan Cuy',
          theme: provider.themeData,
          builder: (context, child) {
            return CupertinoTheme(
              data: CupertinoThemeData(
                brightness:
                provider.isDarkTheme ? Brightness.dark : Brightness.light,
              ),
              child: Material(
                child: child,
              ),
            );
          },
          navigatorKey: navigatorKey,
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => const SplashScreen(),
            BottomNavigation.routeName: (context) => const BottomNavigation(),
            PreferencePage.routeName: (context) => const BottomNavigation(),
            MainPage.routeName: (context) => MainPage(),
            SearchRestaurant.routeName: (context) => const SearchRestaurant(),
            FavoriteRestaurant.routeName: (context) => const FavoriteRestaurant(),
            DetailRestaurant.routeName: (context) => DetailRestaurant(
                restaurant:
                ModalRoute.of(context)?.settings.arguments as Restaurant),
            },
          );
        }
      )
    );
  }
}
