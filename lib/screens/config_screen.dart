

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import '../providers/config.dart';
import '../widgets/app_drawer.dart';

class ConfigScreen extends StatefulWidget {
  static const routeName = '/config';

  const ConfigScreen({Key? key}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  static final _guid_form = GlobalKey<FormState>();
  static final _url_form = GlobalKey<FormState>();
  static final _theme_form = GlobalKey<FormState>();

  var _isLoading = false;

  @override
  void initState() {
    setState(() => _isLoading = true);
    Provider.of<Config>(context, listen:false).fetch()
    .then((_) {
        setState(() { _isLoading = false; });
    });
    super.initState();
  }

  void _saveGuidForm() {
    print(_guid_form);
    final bool isValid = _guid_form.currentState!.validate();
    if(!isValid) {
      return;
    }
    _guid_form.currentState!.save();
  }

  void _saveUrlForm() {
    final isValid = _url_form.currentState!.validate();
    if(!isValid) {
      return;
    }
    _url_form.currentState!.save();
  }

  
  @override
  Widget build(BuildContext context) {
    Config config = Provider.of<Config>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
      ? const Center(
        child: CircularProgressIndicator(),
      )
      : Column(
        children: <Widget>[
          Form(
            key: _guid_form,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        initialValue: config.userGuid,
                        decoration: const InputDecoration(
                          labelText: 'Key (Use the Login form to get a Key emailed)',
                        ),
                        onFieldSubmitted: (value) {
                          config.userGuid = value;
                          // snackbar?
                        },
                        validator: (value) {
                          // Empty is allowed, to logout
                          if(value!.isNotEmpty  && value.length != 36) {
                            return 'Please enter a 36-character guid';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          config.userGuid = value;
                          config.save();
                        },
                      ), //TextFormField,
                    ),
                  ), // Expanded
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: _saveGuidForm
                  ),
                ],
              ),
            ),
          ), //Form
          Form(
            key: _url_form,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget> [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        initialValue: config.apiUrl,
                        decoration: const InputDecoration(
                          labelText: 'API URL',
                        ),
                        onFieldSubmitted: (value) {
                          config.apiUrl = value;
                          // snackbar?
                        },
                        validator: (value) {
                          if(value!.isEmpty || !value.startsWith('http') ) {
                            return 'Please enter a URL';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          config.apiUrl = value;
                          config.save();
                        },
                      ), //TextFormField
                    ), // Padding
                  ), // Expanded
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: _saveUrlForm
                  ),
                ],
              ),
            ),
          ), //Form
          Form(
            key: _theme_form,
            child: Container(
              child: SwitchListTile(
                title: const Text('Dark Theme'),
                value: Theme.of(context).brightness == Brightness.dark ? true: false,
                onChanged: (bool value) {
                  DynamicTheme.of(context).setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                },
              )
            )
          ),
        ],
      ),
    );
  }
}
