import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/styles.dart';
import '../data/api/api_service.dart';
import '../data/db/database_helper.dart';
import '../data/model/restaurant.dart';
import '../provider/database_provider.dart';
import '../provider/detail_provider.dart';
import '../utils/result_state.dart';
import '../widget/drink_card.dart';
import '../widget/food_card.dart';

class DetailRestaurant extends StatelessWidget {
  static const routeName = 'detail_restaurant';
  final Restaurant restaurant;

  const DetailRestaurant({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DetailProvider>(
          create: (_) =>
              DetailProvider(apiService: ApiService(), id: restaurant.id),
        ),
        ChangeNotifierProvider<DatabaseProvider>(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
      ],
      child: Scaffold(
        body: _builder(context),
      ),
    );
  }

  Widget _builder(context) {
    return Consumer<DetailProvider>(builder: (context, state, _) {
      if (state.state == ResultState.Loading) {
        return Center(child: CircularProgressIndicator());
      } else if (state.state == ResultState.HasData) {
        final value = state.detailRestaurant;
        return NestedScrollView(
                headerSliverBuilder: (context, isScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 250,
                      stretch: true,
                      pinned: true,
                      collapsedHeight: 56.0,
                      backgroundColor: secondaryColor,
                      leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Container(
                              height: 30,
                              width: 30,
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.arrow_back,
                                  color: Colors.white)
                          )
                      ),
                      actions: [
                        Consumer<DatabaseProvider>(
                          builder: (context, favorite, child) {
                            return FutureBuilder<bool>(
                              future: favorite.isFavorited(restaurant.id),
                              builder: (context, snapshot) {
                                var isFavorited = snapshot.data ?? false;
                                return Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black54,),
                                    child: isFavorited
                                        ? IconButton(
                                      icon: const Icon(
                                          Icons.favorite),
                                      color: Colors.redAccent,
                                      onPressed: () => favorite
                                          .removeFavorite(restaurant.id),
                                    )
                                        : IconButton(
                                      icon: const Icon(
                                          Icons.favorite_border),
                                      color: Colors.redAccent,
                                      onPressed: () => favorite
                                          .addFavorite(restaurant),
                                    )
                                  // child: Center(child: LoveButton()),
                                );
                              },
                            );
                          },
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                          "https://restaurant-api.dicoding.dev/images/medium/" +
                              value.restaurant.pictureId,
                          fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ];
                  },
                  body: SingleChildScrollView(
                  child: Container(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value.restaurant.name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 15,
                                color: secondaryColor,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(value.restaurant.city)
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(value.restaurant.description),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Foods',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          FoodCard(foods: value.restaurant.menus.foods),
                          SizedBox(height: 30),
                          Text(
                            'Drinks',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          DrinkCard(drinks: value.restaurant.menus.drinks),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          );
      } else if (state.state == ResultState.Error) {
        return Center(
          child: Text(state.message),
        );
      } else {
        return Center(
          child: Text(''),
        );
      }
    });
  }
}
