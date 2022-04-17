

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import './screens/transactions_screen.dart';
import './screens/config_screen.dart';
import './screens/new_transaction_screen.dart';
import './screens/login_screen.dart';
import './providers/transactions.dart';
import './providers/config.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        defaultThemeMode: ThemeMode.light,
        data: (themeMode) => ThemeData(
          primarySwatch: Colors.amber,
          primaryColor: Colors.amber.shade900,
//          accentColor: Colors.amberAccent.shade700,
          brightness: themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light,
        ),
        themedWidgetBuilder: (_,__, theme) {
          return MaterialApp(
            title: 'Makerspace Payments',
            theme: theme,
            home: const TransactionsScreen(),
            routes: {
              TransactionsScreen.routeName: (_) => const TransactionsScreen(),
              ConfigScreen.routeName: (_) => const ConfigScreen(),
              NewTransactionScreen.routeName: (_) => const NewTransactionScreen(),
              LoginScreen.routeName: (_) => const LoginScreen(),
            },
          );
        }
      ),
    );
  }
}

