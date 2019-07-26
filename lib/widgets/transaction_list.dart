import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user_exception.dart';
import '../providers/transactions.dart';

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  var _isLoading = false;
  var _hasUser = false;
  var _hasFailed = false;
  var _errorMessage = '';

  Future<void> _refreshTransactions(BuildContext context) async {
    _hasUser = false;
    _hasFailed = false;
    _errorMessage = '';
    setState(() {
        _isLoading = true;
    });

    Provider.of<Transactions>(context, listen:false).fetchAndSetTransactions()
    .then((_) {
        setState(() { _isLoading = false; _hasUser = true; });
    }).catchError((error) {
        setState(() {
            _isLoading = false;
            _hasUser = false;
            _errorMessage = error.toString();
        });
      },
      test: (e) => e is UserException,
    ).catchError((error) {
        setState(() {
            _hasFailed = true;
            _errorMessage = error.toString();
        });
    });
  }

  
  @override
  void initState() {
    _refreshTransactions(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transData = Provider.of<Transactions>(context);
    final transactions = transData.transactions;
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (ctx, index) {
        return RefreshIndicator(
          onRefresh: () => _refreshTransactions(ctx),
          child:
          _isLoading
          ? Center(
            child: CircularProgressIndicator(),
          )
          : !_hasUser
          ? Center(
            child: Text(_errorMessage),
          )
          : _hasFailed
          ?  Center(
            child: Text('Error loading transactions, pull to retry: $_errorMessage')
          )
          : ListTile(
            leading: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Text('£${(transactions[index].amount / 100).toStringAsFixed(2)}'),
              ),
            ),
            title: Text(transactions[index].reason),
            subtitle: Text(DateFormat("d/M/y").format(transactions[index].addedOn), ),
          ),
        );
      }
    );
  }
}
