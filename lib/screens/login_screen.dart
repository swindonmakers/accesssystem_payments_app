import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/config.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final _form = GlobalKey<FormState>();

  void _saveForm() {
    if(!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
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
      body: Padding(
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
                onSaved: (value) async {
                  // do we want to "wait" on this?
                  await config.fetch();
                  config.loginUser(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
