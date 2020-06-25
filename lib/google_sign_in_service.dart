import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;

class GoogleSignInService {
  GoogleSignIn _googleSignIn;
  ValueChanged<GoogleSignInAccount> account;

  GoogleSignInAccount _currentUser;

  GoogleSignInService({@required this.account}) {
    _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        "https://www.googleapis.com/auth/userinfo.profile",
        'https://www.googleapis.com/auth/user.gender.read',
        'https://www.googleapis.com/auth/user.birthday.read',
      ],
    );

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      this.account(account);
      _currentUser = account;
    });
    _googleSignIn.signInSilently().then((value) {
      account(value);
    });
  }

  Future<void> handleGSignIn() async {
    try {
      {
        await _googleSignIn.signIn();
        print(_googleSignIn.currentUser.displayName);
        print(_googleSignIn.currentUser.email);
        print(_googleSignIn.currentUser.id);
        print(await getGender());
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> signOut() async {
    try {
      {
        await _googleSignIn.signOut();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<String> getGender() async {
    final headers = await _googleSignIn.currentUser.authHeaders;
    final key = 'AIzaSyCrIztYfy7zgZA8NccV2FtUs8Z-JgzQPfc';
    final gender = await http.get(
        "https://people.googleapis.com/v1/people/me?personFields=genders,birthdays&key=$key",
        headers: {"Authorization": headers["Authorization"]});
    final birthday = await http.get(
        "https://people.googleapis.com/v1/people/me?personFields=birthdays&key=$key",
        headers: {"Authorization": headers["Authorization"]});
    final response = json.decode(gender.body);
    final bresponse = json.decode(birthday.body);
    print(response['birthdays'].length);
    print(response['birthdays'][1]['date']);
//    print(bresponse);
    return response["genders"][0]["formattedValue"];
  }
}
