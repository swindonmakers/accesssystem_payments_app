

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/transactions.dart';

class NewTransactionScreen extends StatefulWidget {
  static const routeName = '/new-transaction';

  const NewTransactionScreen({Key? key}) : super(key: key);

  @override
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {

  static final _form = GlobalKey<FormState>();
  final _reasonFocusNode = FocusNode();
  Transaction _newTransaction = Transaction(
    addedOn: DateTime.now(),
    amount: 0,
    reason: '',
  );

  Future<void> _saveForm() async {
    if(!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    var client = http.Client();
    try {
      await Provider.of<Transactions>(context, listen: false)
      .addTransaction(client, _newTransaction);
    } catch(error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occured'),
          content: Text('Something went wrong: $error'),
          actions: <Widget> [
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    } finally {
      client.close();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay for item'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
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
                decoration: const InputDecoration(
                  labelText: 'Amount in £',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_reasonFocusNode);
                },
                validator: (value) {
                  if(value!.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if(double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if(double.parse(value) <= 0) {
                    return 'Please enter an amount in £';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newTransaction = Transaction(
                    addedOn: DateTime.now(),
                    reason: _newTransaction.reason,
                    amount: (double.parse(value!) * 100).toInt(),
                  );
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'For What',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                focusNode: _reasonFocusNode,
                validator: (value) {
                  if(value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  if(value.length < 2) {
                    return 'Description should be at least 2 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newTransaction = Transaction(
                    addedOn: DateTime.now(),
                    amount: _newTransaction.amount,
                    reason: value!,
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
