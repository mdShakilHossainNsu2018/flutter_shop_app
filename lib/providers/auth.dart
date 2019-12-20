import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_shop_app/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _logOutVar;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyAIzneENj2sMATpfbER43dpaNT-JCWLf7w';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];

      _userId = responseData['localId'];

      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      _autoLogOut();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();

      final authData = json.encode({
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String(),
        'userId': userId
      });

      prefs.setString('userData', authData);
    } catch (error) {
      throw error;
    }
  }

//  Future<void> signUp(String email, String password) async {
//    const url =
//        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyAIzneENj2sMATpfbER43dpaNT-JCWLf7w';
//    await http.post(
//      url,
//      body: json.encode(
//        {
//          'email': email,
//          'password': password,
//          'returnSecureToken': true,
//        },
//      ),
//    );
////    print(json.decode(response.body));
//  }
//
//  Future<void> signIn(String email, String password) async {
//    const url =
//        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAIzneENj2sMATpfbER43dpaNT-JCWLf7w';
//    await http.post(
//      url,
//      body: json.encode(
//        {
//          'email': email,
//          'password': password,
//          'returnSecureToken': true,
//        },
//      ),
//    );

//    final responseData = json.decode(response.body);
//    print(responseData['error']['message']);
//    print(json.decode(response.body['message'].toString()));
//  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    _expiryDate = null;
    if (_logOutVar != null) {
      _logOutVar.cancel();
      _logOutVar = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogOut() {
    if (_logOutVar != null) {
      _logOutVar.cancel();
    }

    final _logOutTime = _expiryDate.difference(DateTime.now()).inSeconds;

    _logOutVar = Timer(Duration(seconds: _logOutTime), logout);
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    final _expiryDateh = DateTime.parse(extractedData['expiryDate']);

    if (_expiryDateh.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedData['token'];
    _expiryDate = _expiryDateh;
    _userId = extractedData['userId'];
    _autoLogOut();
    notifyListeners();
    return true;
  }
}
