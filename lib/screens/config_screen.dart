import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/config.dart';
import '../widgets/app_drawer.dart';

class ConfigScreen extends StatefulWidget {
  static const routeName = '/config';

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  static final _guid_form = GlobalKey<FormState>();
  static final _url_form = GlobalKey<FormState>();

  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Config>(context, listen:false).fetch()
    .then((_) {
        setState(() { _isLoading = false; });
    });
    super.initState();
  }

  void _saveGuidForm() {
    print(_guid_form);
    final isValid = _guid_form.currentState.validate();
    if(!isValid) {
      return;
    }
    _guid_form.currentState.save();
  }

  void _saveUrlForm() {
    final isValid = _url_form.currentState.validate();
    if(!isValid) {
      return;
    }
    _url_form.currentState.save();
  }

  
  @override
  Widget build(BuildContext context) {
    Config config = Provider.of<Config>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
      ? Center(
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
                        decoration: InputDecoration(
                          labelText: 'Key',
                        ),
                        onFieldSubmitted: (value) {
                          config.userGuid = value;
                          // snackbar?
                        },
                        validator: (value) {
                          // Empty is allowed, to logout
                          if(value.length > 0  && value.length != 36) {
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
                    icon: Icon(Icons.save),
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
                        decoration: InputDecoration(
                          labelText: 'API URL',
                        ),
                        onFieldSubmitted: (value) {
                          config.apiUrl = value;
                          // snackbar?
                        },
                        validator: (value) {
                          if(value.isEmpty || !value.startsWith('http') ) {
                            return 'Please enter a URL';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          config.apiUrl = value;
                          config.save();
                        },
                      ), //TextFormField
                    ), // Expanded
                  ),
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: _saveUrlForm
                  ),
                ],
              ),
            ),
          ), //Form
        ],
      ),
    );
  }
}
