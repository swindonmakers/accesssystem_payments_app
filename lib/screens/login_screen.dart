import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/config.dart';
import './config_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final _form = GlobalKey<FormState>();
  var _isLoading = false;

  Future<void> _saveForm() async {
    if(!_form.currentState.validate()) {
      return;
    }
    setState(() { _isLoading = true; });
    _form.currentState.save();
  }

  Future<void> _loginUser(Config config, String value) async {
    await config.fetch();
    try {
      await config.loginUser(value);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Login'),
          content: Text('You have been sent an email with your login key'),
          actions: <Widget> [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                    _isLoading = false;
                });
                Navigator.of(ctx).pop();
                Navigator.of(context).pushNamed(ConfigScreen.routeName);
              },
            ),
          ],
        ),
      );
    } catch(error) {
      print(error);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occured'),
          content: Text(error.toString()),
          actions: <Widget> [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                    _isLoading = false;
                });
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    var config = Provider.of<Config>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Login Key'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
      ? Center(
        child: CircularProgressIndicator(),
      )
      : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              Text('Enter your SMXXX reference (the one you use to pay the space). You will be sent an email.'),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'SM Ref',
                ),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  var smPattern = RegExp(r"(?:SM|sm)?\s*(\d+)");
                  if(value.isEmpty) {
                    return 'Please enter your SM Reference';
                  }
                  if(value.length <= 2 || value.length > 6 || !value.contains(smPattern)) {
                    return 'Please enter a valid member id or SM reference string';
                  }

                  return null;
                },
                onSaved: (value) => _loginUser(config, value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
