import 'package:flutter/foundation.dart';

class Transaction {
  final DateTime addedOn;
  final int amount;
  final String reason;

  Transaction({this.addedOn, this.amount, this.reason});
}

class Transactions extends ChangeNotifier {
  List<Transaction> _transactions = [
    Transaction(
      addedOn: DateTime.now(),
      amount: 1250,
      reason: 'Membership payment',
    ),
  ];

  List<Transaction> get transactions {
    return [..._transactions];
  }
}
