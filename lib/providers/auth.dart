import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shopapp/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userID;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  Map<String, String> get getToken {
    if (token != null) {
      return {'token': _token.toString(), 'userID': _userID};
    } else {
      return null;
    }
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> auth(String type, String email, String password) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$type?key=AIzaSyBdX23EC9nTODV7PI6JTa1I-QOq0PCvssM";
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData['error']["message"]);
      } else {
        _token = responseData['idToken'];
        _userID = responseData['localId'];
        _expiryDate = DateTime.now().add(Duration(
          seconds: int.parse(responseData['expiresIn']),
        ));
      }
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userID": _userID,
        "expiryDate": _expiryDate.toIso8601String(),
      });
      prefs.setString("userData", userData);
    } catch (err) {
      throw err;
    }
  }

  void logOut() async {
    _token = null;
    _expiryDate = null;
    _userID = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    _authTimer = Timer(
        Duration(seconds: _expiryDate.difference(DateTime.now()).inSeconds),
        () {
      logOut();
    });
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString("userData"));
    final expDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _expiryDate = expDate;
    _userID = extractedUserData['userID'];
    notifyListeners();
    _autoLogout();
    return true;
  }
}
