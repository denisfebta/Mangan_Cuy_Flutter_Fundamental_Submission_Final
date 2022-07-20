import 'package:flutter/material.dart';
import '../data/model/restaurant.dart';
import '../ui/detail_restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailRestaurant.routeName,
          arguments: restaurant,
        );
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
  }
}
