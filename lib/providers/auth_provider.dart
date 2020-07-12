import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {

  String _localId;
  String _idToken;
  DateTime _expiresIn;
  Timer _authTimer;


  // Untuk idUser
  String get idUser {
    return _localId;
  }



  // Untuk pengecekan apakah sudah/masih auth atau tidak
  bool get isAuth{
    if(_notExpiresToken){
      return true;
    }
    return false;
  }


   // Untuk pengecekan apakah apakah token masih berlaku atau tidak
  bool get _notExpiresToken{
    if(_expiresIn != null && _idToken != null){
      if(DateTime.now().isBefore(_expiresIn)){
        return true;
      }
    }
    return false;
  }


  // Mendapatkan id token
  String get idToken{
    if(_notExpiresToken){
      return _idToken;
    }
    return null;
  }


  // Untuk daftar pengguna baru
  Future<void> singnup(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCjj3zdfJ_-fE9_48AomHK8RI8yLF6npho";

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message'].toString());
      }

    } catch (error) {
      // HttpException adalah custom class exception
      throw error;
    }
  }


  // Untuk Login
  Future<void> login(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCjj3zdfJ_-fE9_48AomHK8RI8yLF6npho";

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final responseData  = json.decode(response.body);

      // jika terjadi error auth
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }

      _idToken = responseData['idToken'];
      _expiresIn = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _localId = responseData['localId'];

      // auto logout jika telah melewati expiresIn
      _autoLogout();
      notifyListeners();


      // menyimpan data login ke shared_prefences
      final shpre = await SharedPreferences.getInstance();
      final dataAuth = json.encode({
        'idToken' : _idToken,
        'localId' : _localId,
        'expiresIn' : _expiresIn.toIso8601String(),
      });
      shpre.setString('dataAuth', dataAuth);

    } catch (error) {
      throw error;
    }
  }



  // funtion untuk keluar login
  Future<void> logout() async {
    _idToken = null;
    _localId = null;
    _expiresIn = null;

    if(_authTimer != null){
      _authTimer.cancel();
      _authTimer = null;
    }

    // mengahapus semua data sharederefences
    final sf = await SharedPreferences.getInstance();
    sf.clear();

    notifyListeners();
  }




  // Untuk auto logout ketika waktu expiresIn telah habis
  void _autoLogout(){

    if(_authTimer != null){
      _authTimer.cancel();
    }

    final timeToExpary = _expiresIn.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpary), ()=> logout() );
  }


  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString('dataAuth') != null){
      final dataAuth = json.decode(prefs.getString('dataAuth')) as Map<String, dynamic>;
      final expiresIn = DateTime.parse(dataAuth['expiresIn']);
      if(DateTime.now().isBefore(expiresIn)){
        _idToken = dataAuth['idToken'];
        _localId = dataAuth['localId'];
        _expiresIn = expiresIn;
        
        notifyListeners();
        return true;
      }
    }
    return false;
  }
}
