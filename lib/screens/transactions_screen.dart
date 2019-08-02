import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_exception.dart';
import '../widgets/app_drawer.dart';
import '../widgets/transaction_list.dart';
import '../screens/new_transaction_screen.dart';
import '../providers/transactions.dart';

class TransactionsScreen extends StatefulWidget {
  static const routeName = '/transactions';
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
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
            _isLoading = false;
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
      body:  _isLoading
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
      : Column(
        children: <Widget> [
          ListTile(
            leading: Text('Current Balance:'),
            trailing: Text(transData.userBalance.toStringAsFixed(2)),
          ),
          Expanded(
            child: TransactionList(transactions),
          ),
        ],
        // Add balance display at top of screen?
      ),
    );
  }
}
