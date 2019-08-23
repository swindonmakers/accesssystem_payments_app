import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';

class NewTransactionScreen extends StatefulWidget {
  static const routeName = '/new-transaction';

  @override
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {

  static final _form = GlobalKey<FormState>();
  final _reasonFocusNode = FocusNode();
  Transaction _newTransaction = Transaction(
    amount: 0,
    reason: '',
  );

  Future<void> _saveForm() async {
    if(!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    try {
      await Provider.of<Transactions>(context, listen: false)
      .addTransaction(_newTransaction);
    } catch(error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occured'),
          content: Text('Something went wrong: $error'),
          actions: <Widget> [
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay for item'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Amount in £',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_reasonFocusNode);
                },
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if(double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if(double.parse(value) <= 0) {
                    return 'Please enter a number greater than 0';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newTransaction = Transaction(
                    reason: _newTransaction.reason,
                    amount: (double.parse(value) * 100).toInt(),
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'For What',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                focusNode: _reasonFocusNode,
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if(value.length < 10) {
                    return 'Description should be at least 10 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newTransaction = Transaction(
                    amount: _newTransaction.amount,
                    reason: value,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
