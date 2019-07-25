import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/transactions.dart';

class TransactionsScreen extends StatelessWidget {
  static const routeName = '/transactions';
  @override
  Widget build(BuildContext context) {
    final transData = Provider.of<Transactions>(context);
    final transactions = transData.transactions;
    return Scaffold(
      appBar: AppBar(
        title: Text('AccessSystem Payments'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            leading: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Text('£${(transactions[index].amount / 100).toStringAsFixed(2)}'),
              ),
            ),
            title: Text(transactions[index].reason),
            subtitle: Text(DateFormat("d/M/y").format(transactions[index].addedOn), ),
          );
        }
      ),
    );
  }
}
