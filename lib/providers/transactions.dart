import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './config.dart';
import '../models/user_exception.dart';
import '../models/http_exception.dart';

class Transaction {
  final DateTime addedOn;
  final int amount;
  final String reason;

  Transaction({this.addedOn, @required this.amount, @required this.reason});
}

class Transactions extends ChangeNotifier {
  final Config config = Config();
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

  Future<void> addTransaction(Transaction newT) async {
    print('Saving a Transaction');
    await config.fetch();
    if(config.userGuid.isEmpty) {
      // throw exception?
      print('No userGuid set yet!');
      throw UserException('Please enter a user Key in settings');
    }

    try {
      String url = config.apiUrl + '/transaction';
      final response = await http.post(
        url,
        body: {
          'hash': config.hash,
          'amount': newT.amount.toString(),
          'reason': newT.reason,
        },
      );
      print(response.body);
      if(response.statusCode >= 400) {
        throw HttpException('Error creating transaction');
      }
    } catch(error) {
      print(error);
      throw(error);
    }
  }
  
  Future<void> fetchAndSetTransactions() async {
    await config.fetch();
    if(config.userGuid.isEmpty) {
      // throw exception?
      print('No userGuid set yet!');
      throw UserException('Please enter a user Key in settings');
    }
    try {
      String url = config.apiUrl + '/get_transactions/10/'+config.hash;
      final response = await http.get(url);
      final extractedData  = json.decode(response.body) as List<dynamic>;
      if(extractedData == null) {
        return;
      }
      final List<Transaction> loadedTransactions = [];
      extractedData.forEach((transaction) {
          loadedTransactions.add(Transaction(
              addedOn: DateTime.parse(transaction['added_on']),
              amount: transaction['amount'],
              reason: transaction['reason'],
          ));
      });
      
      _transactions = loadedTransactions;
      notifyListeners();
    } catch(error) {
      throw(error);
    }
  }
}
