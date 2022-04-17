import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/config.dart';
import './config_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final _form = GlobalKey<FormState>();
  var _isLoading = false;

  Future<void> _saveForm() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState!.save();
  }

  Future<void> _loginUser(Config config, String value) async {
    await config.fetch();
    try {
      await config.loginUser(value);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Login'),
          content:
              const Text('You have been sent an email with your login key'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
    } catch (error) {
      print(error);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occured'),
          content: Text(error.toString()),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
        title: const Text('Request Login Key'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    const Text(
                        'Enter your SMXXX reference (the one you use to pay the space). You will be sent an email.'),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'SM Ref',
                      ),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        var smPattern = RegExp(r"(?:SM|sm)?\s*(\d+)");
                        if (value!.isEmpty) {
                          return 'Please enter your SM Reference';
                        }
                        if (value.length <= 2 ||
                            value.length > 6 ||
                            !value.contains(smPattern)) {
                          return 'Please enter a valid member id or SM reference string';
                        }

                        return null;
                      },
                      onSaved: (value) => _loginUser(config, value!),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_form.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                          _form.currentState!.save();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
