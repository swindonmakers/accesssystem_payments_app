

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/transactions.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;

  const TransactionList(this._transactions, {Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _transactions.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(5),
            child: FittedBox(
              child: Text('£${(_transactions[index].amount.abs() / 100).toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: _transactions[index].amount < 0 ? FontWeight.bold : FontWeight.normal,
                  color: _transactions[index].amount < 0 ? Theme.of(context).errorColor : Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          title: Text(_transactions[index].reason),
          subtitle: Text(DateFormat("d/M/y").format(_transactions[index].addedOn), ),
        );
      }
    );
  }
}
