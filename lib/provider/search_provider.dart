import 'package:flutter/cupertino.dart';
import '../data/api/api_service.dart';
import '../data/model/restaurant.dart';
import '../utils/search_state.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchProvider({required this.apiService}) {
    fetchSearchRestaurant();
  }

  late RestaurantSearch _searchResult;
  late SearchState _state;
  String _message = '';
  String query = '';

  String get message => _message;
  RestaurantSearch get result => _searchResult;
  SearchState get state => _state;

  Future<dynamic> fetchSearchRestaurant() async {
    if (query != "") {
      try {
        _state = SearchState.Loading;
        final search = await apiService.searchRestaurant(query);
        if (search.restaurants.isEmpty) {
          _state = SearchState.NoData;
          notifyListeners();
          return _message = 'Not found';
        } else {
          _state = SearchState.HasData;
          notifyListeners();
          return _searchResult = search;
        }
      } catch (e) {
        _state = SearchState.Error;
        notifyListeners();
        return _message = 'You are not connected to Internet!';
      }
    } else {
      _state = SearchState.NoQueri;
      notifyListeners();
      return _message = 'No query';
    }
  }

  void addQuery(String query) {
    this.query = query;
    fetchSearchRestaurant();
    notifyListeners();
  }
}
