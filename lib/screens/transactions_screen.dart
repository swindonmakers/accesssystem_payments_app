

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/user_exception.dart';
import '../widgets/app_drawer.dart';
import '../widgets/transaction_list.dart';
import '../screens/new_transaction_screen.dart';
import '../screens/login_screen.dart';
import '../providers/transactions.dart';

class TransactionsScreen extends StatefulWidget {
  static const routeName = '/transactions';

  const TransactionsScreen({Key? key}) : super(key: key);
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

    var client = http.Client();
    Provider.of<Transactions>(context, listen:false).fetchAndSetTransactions(client)
    .then((_) {
        setState(() { _isLoading = false; _hasUser = true; });
        client.close();
    }).catchError((error) {
        setState(() {
            _isLoading = false;
            _hasUser = false;
            _errorMessage = error.toString();
        });
        client.close();
      },
      test: (e) => e is UserException,
    ).catchError((error) {
        setState(() {
            _isLoading = false;
            _hasFailed = true;
            _errorMessage = error.toString();
        });
        client.close();
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
        title: const Text('Your Transactions'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(NewTransactionScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body:  _isLoading
      ? const Center(
        child: CircularProgressIndicator(),
      )
      : !_hasUser
      ? Center(
        child: TextButton(
          child: Text(_errorMessage),
          onPressed: () {
            Navigator.of(context).pushNamed(LoginScreen.routeName);
          },
        ),
      )
      : _hasFailed
      ?  Center(
        child: Text('Error loading transactions, pull to retry: $_errorMessage')
      )
      : RefreshIndicator(
        onRefresh: () => _refreshTransactions(context),
        child: Column(
          children: <Widget> [
            ListTile(
              leading: const Text('Current Balance:'),
              trailing: Text(transData.userBalance.abs().toStringAsFixed(2),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: transData.userBalance < 0 ? Theme.of(context).errorColor : Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            Expanded(
              child: TransactionList(transactions),
            ),
          ],
        ),
      ),
    );
  }
}
