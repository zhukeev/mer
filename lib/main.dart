import 'dart:convert' show json;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'package:location/location.dart';
import 'package:mer/sign_in_page.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: '312',
      themeMode: ThemeMode.light,
      /*
      *  theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.grey,
            backgroundColor: Color(0xfff2f2f2),
            primaryColor: Color(0xfff2f2f2),
            accentColor: Palette.pickledBluewood,
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Palette.pickledBluewood),
            ),
            textTheme: TextTheme(
              bodyText2: TextStyle(color: Palette.pickledBluewood),
            ),
            dialogBackgroundColor: Colors.white,
            inputDecorationTheme: InputDecorationTheme(
              border: const UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey)),
              labelStyle: const TextStyle(color: Colors.black54),
            ),
            primaryTextTheme: TextTheme(
              bodyText2: TextStyle(color: Palette.pickledBluewood),
              headline6: TextStyle(color: Palette.pickledBluewood),
            )),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.deepOrange,
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
            ),
            backgroundColor: Color(0xFF161616),
            primaryColor: Color(0xFF161616),
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(color: Colors.white),
              focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey)),
            ),
            scaffoldBackgroundColor: Color(0xFF161616),
            canvasColor: Color(0xFF161616),
            cardColor: Color(0xFF161616),
            dialogBackgroundColor: Color(0xFF161616),
            unselectedWidgetColor: Colors.grey,
            popupMenuTheme:
                PopupMenuThemeData(textStyle: TextStyle(color: Colors.white)),
            accentColor: Palette.darkAccentColor,
            textTheme: TextTheme(
                bodyText2: TextStyle(color: Colors.white),
                headline6: TextStyle(color: Colors.white),
                subtitle1: TextStyle(color: Colors.white)),
            primaryTextTheme: TextTheme(
                bodyText2: TextStyle(color: Colors.white),
                headline6: TextStyle(color: Colors.white),
                subtitle1: TextStyle(color: Colors.white),
                caption: TextStyle(color: Colors.white))),
      *
      * */

      theme: NeumorphicThemeData(
          baseColor: Color(0xFFFFFFFF),
          lightSource: LightSource.topLeft,
          iconTheme: IconThemeData(color: Colors.grey.shade700),
          textTheme: ThemeData.light().textTheme..subtitle1.apply(color: Colors.red),
          depth: 10),
      darkTheme: NeumorphicThemeData(
          baseColor: Color(0xFF161616),
          lightSource: LightSource.topLeft,
          appBarTheme: NeumorphicAppBarThemeData(
              textStyle: TextStyle(color: Colors.grey.shade300),
              iconTheme: IconThemeData(color: Colors.grey.shade300)),
          textTheme: TextTheme(
              bodyText2: TextStyle(color: Colors.white),
              headline6: TextStyle(color: Colors.white),
              subtitle1: TextStyle(color: Colors.white)),
          depth: 6,
          iconTheme: IconThemeData(color: Colors.grey.shade300),
          shadowLightColor: Colors.grey.shade700),
      home: SignInPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  GoogleSignInAccount _currentUser;

  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Future<void> _location() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: <Widget>[
              SignInWithAppleButton(
                onPressed: () async {
                  final credential = await SignInWithApple.getAppleIDCredential(
                    scopes: [
                      AppleIDAuthorizationScopes.email,
                      AppleIDAuthorizationScopes.fullName,
                    ],
                    webAuthenticationOptions: WebAuthenticationOptions(
                      // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                      clientId: 'com.example.mer',
                      redirectUri: Uri.parse(
                        'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                      ),
                    ),
                    // TODO: Remove these if you have no need for them
                    nonce: 'example-nonce',
                    state: 'example-state',
                  );

                  print(credential);

                  // This is the endpoint that will convert an authorization code obtained
                  // via Sign in with Apple into a session in your system
                  final signInWithAppleEndpoint = Uri(
                    scheme: 'https',
                    host: 'flutter-sign-in-with-apple-example.glitch.me',
                    path: '/sign_in_with_apple',
                    queryParameters: <String, String>{
                      'code': credential.authorizationCode,
                      'firstName': credential.givenName,
                      'lastName': credential.familyName,
                      'useBundleId':
                          Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
                      if (credential.state != null) 'state': credential.state,
                    },
                  );

                  // If we got this far, a session based on the Apple ID credential has been created in your system,
                  // and you can now set this as the app's session
//              print(session);
                },
              ),
              _buildBody()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),
          const Text("Signed in successfully."),
          Text(_contactText ?? ''),
          RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          RaisedButton(
            child: const Text('REFRESH'),
            onPressed: _handleGetContact,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          RaisedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }
}
