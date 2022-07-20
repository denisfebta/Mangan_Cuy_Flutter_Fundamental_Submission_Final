import 'package:flutter/cupertino.dart';
import '../data/api/api_service.dart';
import '../data/model/restaurant.dart';
import '../utils/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    fetchRestaurantFull();
  }

  late RestaurantList _restaurant;

  late ResultState _state;
  String _message = '';

  String get message => _message;
  RestaurantList get result => _restaurant;

  ResultState get state => _state;

  Future<dynamic> fetchRestaurantFull() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurantList = await apiService.restaurantList();
      if (restaurantList.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurant = restaurantList;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Connection is lost!';
    }
  }
}
