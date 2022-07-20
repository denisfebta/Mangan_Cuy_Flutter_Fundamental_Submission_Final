import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../data/api/api_service.dart';
import '../provider/restaurant_provider.dart';
import 'home_restaurant.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/resto_recomend';

  @override
  State<MainPage> createState() => _RecomendRestoState();
}

class _RecomendRestoState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RestaurantProvider(apiService: ApiService()),
        child: HomeRestaurant());
  }
}
