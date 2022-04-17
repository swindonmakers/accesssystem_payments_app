

import 'package:flutter/material.dart';

import '../screens/config_screen.dart';
import '../screens/transactions_screen.dart';
import '../screens/login_screen.dart';
import '../providers/config.dart';

class AppDrawer extends StatelessWidget {
  final Config config = Config();

  AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    config.fetch();

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(TransactionsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ConfigScreen.routeName);
            },
          ),
          const Divider(),
          config.userGuid.isNotEmpty
          ? ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Logout'),
            onTap: () {
              config.userGuid = '';
              config.save();
            },
          )
          : ListTile(
            leading: const Icon(Icons.face),
            title: const Text('Login'),
            onTap: () {
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            },
          ),
        ],
      ), // Column
    );
  }
}
