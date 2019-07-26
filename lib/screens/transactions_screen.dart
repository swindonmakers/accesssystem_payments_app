import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../widgets/transaction_list.dart';
import '../screens/new_transaction_screen.dart';
import '../providers/transactions.dart';

class TransactionsScreen extends StatelessWidget {
  static const routeName = '/transactions';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AccessSystem Payments'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(NewTransactionScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: TransactionList(),
      // Add balance display at top of screen?
    );
  }
}
