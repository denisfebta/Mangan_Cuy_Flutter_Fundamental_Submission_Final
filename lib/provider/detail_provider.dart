import 'package:flutter/cupertino.dart';
import '../data/api/api_service.dart';
import '../data/model/restaurant.dart';
import '../utils/result_state.dart';

class DetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  DetailProvider({required this.apiService, required this.id}) {
    _fetchAllDetailRestaurant(id);
  }

  RestaurantDetail? _detailRestaurant;
  String _message = '';
  ResultState? _state;

  String get message => _message;

  RestaurantDetail get detailRestaurant => _detailRestaurant!;

  ResultState get state => _state!;

  Future<dynamic> _fetchAllDetailRestaurant(String id) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.restaurantDetail(id);
      if (restaurant.restaurant.id.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _detailRestaurant = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Connection is lost!';
    }
  }
}
