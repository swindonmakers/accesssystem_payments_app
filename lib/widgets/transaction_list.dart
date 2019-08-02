import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user_exception.dart';
import '../providers/transactions.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;

  TransactionList(this._transactions);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _transactions.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          leading: Padding(
            padding: EdgeInsets.all(5),
            child: FittedBox(
              child: Text('£${(_transactions[index].amount / 100).toStringAsFixed(2)}'),
            ),
          ),
          title: Text(_transactions[index].reason),
          subtitle: Text(DateFormat("d/M/y").format(_transactions[index].addedOn), ),
        );
      }
    );
  }
}
