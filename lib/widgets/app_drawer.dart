import 'package:flutter/material.dart';

import '../screens/config_screen.dart';
import '../screens/transactions_screen.dart';
import '../screens/login_screen.dart';
import '../providers/config.dart';

class AppDrawer extends StatelessWidget {
  final Config config = Config();

  @override
  Widget build(BuildContext context) {
    config.fetch();

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(TransactionsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ConfigScreen.routeName);
            },
          ),
          Divider(),
          !config.userGuid.isEmpty
          ? ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Logout'),
            onTap: () {
              config.userGuid = '';
              config.save();
            },
          )
          : ListTile(
            leading: Icon(Icons.face),
            title: Text('Login'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          ),
        ],
      ), // Column
    );
  }
}
