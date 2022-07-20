import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/styles.dart';
import '../provider/preferences_provider.dart';
import '../provider/scheduling_provider.dart';

class PreferencePage extends StatelessWidget {
  static const routeName = '/preference_page';

  const PreferencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mangan Cuy',
        ),
        backgroundColor: secondaryColor,
      ),
      body: _PreferencePage(),
    );
  }
}
class _PreferencePage extends StatelessWidget {
  const _PreferencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              Material(
                child: ListTile(
                  title: Text(
                    'Dark Mode',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  subtitle: Text(
                    "Enable dark mode",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Switch.adaptive(
                        value: provider.isDarkTheme,
                        onChanged: (value) {
                          provider.enableDarkTheme(value);
                        },
                      ),
                ),
              ),
              Material(
                child: ListTile(
                  title: Text(
                    'Restaurant Notification',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  subtitle: Text(
                    "Enable notification",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Consumer<SchedulingProvider>(
                    builder: (context, scheduled, _) {
                      return Switch.adaptive(
                        value: provider.isDailyNotificationActive,
                        onChanged: (value) async {
                          scheduled.scheduledRestaurant(value);
                          provider.enableDailyNotification(value);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
      );
  }
}