import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_project/ui/detail_restaurant.dart';
import '../common/styles.dart';
import '../data/model/restaurant.dart';
import '../provider/database_provider.dart';
import '../utils/result_state.dart';

class FavoriteRestaurant extends StatefulWidget {
  const FavoriteRestaurant({Key? key}) : super(key: key);
  static const routeName = '/resto_favorite';

  @override
  State<FavoriteRestaurant> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoriteRestaurant> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DatabaseProvider>().getFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Restaurant',
        ),
        backgroundColor: secondaryColor,
      ),
      body: FavoriteBody(),
    );
  }
}

class FavoriteBody extends StatelessWidget {
  const FavoriteBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 20.0,
                ),
                Consumer<DatabaseProvider>(builder: (context, favorite, _) {
                  if (favorite.state == ResultState.Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (favorite.state == ResultState.HasData) {
                    return Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: favorite.favorites.length,
                          itemBuilder: (context, index) {
                            return FavoriteData(restaurant: favorite.favorites[index]);
                          },
                        ));
                  } else if (favorite.state == ResultState.NoData) {
                    return Center(
                      child: Text('No Favorite Restaurant'),
                    );
                  } else if (favorite.state == ResultState.Error) {
                    return Center(child: Text('Oops. Koneksi internet kamu mati!'));
                  } else {
                    return Container();
                  }
                })
              ],
            )));
  }
}

class FavoriteData extends StatelessWidget {
  final Restaurant restaurant;

  const FavoriteData({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(restaurant.id),
          builder: (context, snapshot) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(builder: (_) => DetailRestaurant(restaurant: restaurant)),
                )
                    .then((_) {
                  context.read<DatabaseProvider>().getFavorites();
                });
              },
              child: Hero(
                tag: restaurant.pictureId,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                image: DecorationImage(
                                    image: NetworkImage("https://restaurant-api.dicoding.dev/images/medium/" + restaurant.pictureId),
                                    fit: BoxFit.cover)),
                          ),
                          Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(bottom: 3),
                                        child: Text(
                                          restaurant.name,
                                          overflow: TextOverflow.visible,
                                          style: Theme.of(context).textTheme.subtitle1,
                                        )),
                                    Container(
                                        margin: EdgeInsets.only(bottom: 3),
                                        child: Text(
                                          restaurant.description,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        )),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 3),
                                      child: Row(
                                        children: List<Widget>.generate(
                                            5,
                                                (index) => Icon(
                                              (index < restaurant.rating.round())
                                                  ? Icons.star
                                                  : Icons.star_outline,
                                              size: 16,
                                              color: Colors.amber,
                                            )) +
                                            [
                                              const SizedBox(width: 4,),
                                              Text(
                                                restaurant.rating.toString(),
                                              )
                                            ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 20,
                                          ),
                                          Text(restaurant.city),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
