import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/styles.dart';
import '../provider/restaurant_provider.dart';
import '../utils/result_state.dart';
import '../widget/restaurant_card.dart';

class HomeRestaurant extends StatelessWidget {
  const HomeRestaurant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Mangan Cuy',
          ),
          backgroundColor: secondaryColor,
        ),
        body: Consumer<RestaurantProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.state == ResultState.HasData) {
              return SafeArea(
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.result.restaurants.length,
                            itemBuilder: (context, index) {
                              var restaurant = state.result.restaurants[index];
                              return RestaurantCard(
                                restaurant: restaurant,
                              );
                            })),
                  ],
                ),
              );
            } else if (state.state == ResultState.NoData) {
              return Center(
                child: Text(state.message),
              );
            } else if (state.state == ResultState.Error) {
              return Center(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 200),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/no-wifi.png'))),
                      ),
                      Container(
                        child: Text(
                          state.message,
                        ),
                      )
                    ],
                  ));
            } else {
              return Center(
                child: Text('', style: Theme.of(context).textTheme.subtitle1,),
              );
            }
          },
        )
      // padding: EdgeInsets.only(top: 15, left: 30),
    );
  }
}
