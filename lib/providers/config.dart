import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/login_exception.dart';

class Config extends ChangeNotifier {
  final String _api_key = 'access_system_api_url';
  final String _guid_key = 'access_system_guid';
  final String _defaultUrl = 'https://inside.swindon-makerspace.org';
  String _apiUrl = '';
  String _userGuid = '';

//  Config({this.api_url, this.user_guid});

  String get apiUrl {
    return _apiUrl;
  }

  set apiUrl(value) {
    _apiUrl = value;
  }

  String get userGuid {
    return _userGuid;
  }

  set userGuid(value) {
    _userGuid = value;
  }

  String get hash {
    var bytes = utf8.encode(DateFormat('yyyy-MM-dd').format(DateTime.now()) + _userGuid);
   // print(DateFormat('yyyy-MM-dd').format(DateTime.now()));
   // print(bytes);
    return md5.convert(bytes).toString();
  }

  Future<void> save() async {
    print('Saving: ${_userGuid} ${_apiUrl}');
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_api_key, _apiUrl);
      prefs.setString(_guid_key, _userGuid);
    } catch(error) {
      print('Save failed! $error');
    }
  }

  Future<void> fetch() async {
    print('Loading...');
    try {
      final prefs = await SharedPreferences.getInstance();
      _apiUrl = prefs.getString(_api_key) ?? _defaultUrl;
      _userGuid = prefs.getString(_guid_key) ?? '';
      print('Loaded: ${_userGuid} ${_apiUrl}');
    } catch (error) {
      print('Load failed! $error');
    }
  }

  Future<void> loginUser(String ref) async {
    print('login user $ref');
    String url = apiUrl + '/user_guid_request?userid=$ref';
    try {
      final response = await http.get(url);
      print(response.body);
      if(response.statusCode >= 400) {
        throw HttpException('Error sending login email: ${response.body}');
      }
      var result = json.decode(response.body) as Map<String, dynamic>;
      if(result['success'] == 0) {
        throw LoginException(result['error']);
      }
    } catch(error) {
      print(error);
      throw(error);
    }
  }
}
