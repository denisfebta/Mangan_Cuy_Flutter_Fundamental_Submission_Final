import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/styles.dart';
import '../data/api/api_service.dart';
import '../provider/search_provider.dart';
import '../utils/search_state.dart';
import '../widget/restaurant_card.dart';

class SearchRestaurant extends StatelessWidget {
  const SearchRestaurant({Key? key}) : super(key: key);
  static const routeName = '/search_restaurant';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchProvider>(
      create: (_) => SearchProvider(apiService: ApiService()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Search Restaurant',
          ),
          backgroundColor: secondaryColor,
        ),
        body: BodySearch(),
      ),
    );
  }
}

class BodySearch extends StatelessWidget {
  const BodySearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final search = Provider.of<SearchProvider>(context, listen: false);
    return SafeArea(
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search',
                        filled: true),
                    onSubmitted: (value) {
                      search.addQuery(value);
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 0,
          ),
          Consumer<SearchProvider>(
            builder: (context, result, _) {
              if (result.state == SearchState.NoQueri) {
                return (Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Column(
                      children: <Widget>[
                        Text("Let's find your restaurant!")
                      ],
                    ),
                  ),
                ));
              } else if (result.state == SearchState.Loading) {
                return Center(child: CircularProgressIndicator());
              } else if (result.state == SearchState.HasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: result.result.restaurants.length,
                    itemBuilder: (context, index) {
                      var restaurant = result.result.restaurants[index];
                      return RestaurantCard(
                        restaurant: restaurant,
                      );
                    },
                  ),
                );
              } else if (result.state == SearchState.NoData) {
                return Center(
                  child: Text('Not found'),
                );
              } else if (result.state == SearchState.Error) {
                return Center(
                  child: Text("Whoops. You are not connected to internet!"),
                );
              } else {
                return Center(child: const Text(''));
              }
            },
          ),
        ]));
  }
}