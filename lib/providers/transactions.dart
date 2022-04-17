

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

  Transaction({required this.addedOn, this.amount = 0, this.reason = ''});

}

class Transactions extends ChangeNotifier {
  final Config config = Config();
  List<Transaction> _transactions = [
  ];

  double _userBalance = 0;
  
  List<Transaction> get transactions {
    return [..._transactions];
  }

  double get userBalance {
    return _userBalance;
  }
  
  Future<bool> addTransaction(http.Client http, Transaction newT) async {
    print('Saving a Transaction');
    await config.fetch();
    if(config.userGuid.isEmpty) {
      // throw exception?
      //print('No userGuid set yet!');
      throw UserException('Please enter a user Key in settings');
    }

    try {
      var url = Uri.parse(config.apiUrl + '/transaction');
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
      final extractedResult = json.decode(response.body) as Map<String, dynamic>;
      return extractedResult['success'] == 1;
      
    } catch(error) {
      print(error);
      rethrow;
    }
  }
  
  Future<void> fetchAndSetTransactions(http.Client http) async {
    await config.fetch();
    if(config.userGuid.isEmpty) {
      print('No userGuid set yet!');
      throw UserException('Please Login first');
    }
    try {
      var url = Uri.parse(config.apiUrl + '/get_transactions/10/'+config.hash);
      final response = await http.get(url);
      final extractedData  = json.decode(response.body) as Map<String,dynamic>?;
      if(extractedData == null) {
        return;
      }
      final List<Transaction> loadedTransactions = [];
      extractedData['transactions'].forEach((transaction) {
          loadedTransactions.add(Transaction(
              addedOn: DateTime.parse(transaction['added_on']),
              amount: transaction['amount'],
              reason: transaction['reason'],
          ));
      });
      _userBalance = extractedData['balance'] / 100;
      _transactions = loadedTransactions;
      notifyListeners();
    } catch(error) {
      throw(error);
    }
  }
}
