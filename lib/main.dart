import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import './screens/transactions_screen.dart';
import './screens/config_screen.dart';
import './screens/new_transaction_screen.dart';
import './screens/login_screen.dart';
import './providers/transactions.dart';
import './providers/config.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Transactions(),
        ),
        ChangeNotifierProvider.value(
          value: Config(),
        ),
      ],
      child: DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
          primarySwatch: Colors.amber,
          primaryColor: Colors.amber.shade900,
          accentColor: Colors.amberAccent.shade700,
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Makerspace Payments',
            theme: theme,
            home: TransactionsScreen(),
            routes: {
              TransactionsScreen.routeName: (_) => TransactionsScreen(),
              ConfigScreen.routeName: (_) => ConfigScreen(),
              NewTransactionScreen.routeName: (_) => NewTransactionScreen(),
              LoginScreen.routeName: (_) => LoginScreen(),
            },
          );
        }
      ),
    );
  }
}

