import 'dart:convert' show json;
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'package:mer/google_sign_in_service.dart';
import 'package:mer/home_page.dart';
import 'package:mer/sign_up_page.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'menu_main_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FocusNode _passwordFocus = FocusNode();

  var _hasInternetConnection = false;

  TextEditingController _signInEmailController = TextEditingController();

  TextEditingController _signInPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  GoogleSignInService _googleSignInService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _googleSignInService = GoogleSignInService(account: (account) {
      if (account != null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => MainMenuPage()));
      }
    });


  }

  @override
  void didChangeDependencies() {
    final bool isDark = NeumorphicTheme.of(context).isUsingDark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  NeumorphicTheme.baseColor(context),
      body: Stack(
        children: <Widget>[
          buildLogo(),
          buildInputs(context),
          buildLoginWith(context)
        ],
      ),
    );
  }

  Align buildInputs(BuildContext context) {
    return Align(
        key: ValueKey(0),
        alignment: const Alignment(0.0, 0.3),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Neumorphic(
                  child: TextFormField(
                    controller: _signInEmailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                        val.isEmpty ? 'Обязательное поле' : null,
                    onFieldSubmitted: (str) =>
                        FocusScope.of(context).requestFocus(_passwordFocus),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.alternate_email),
                      labelText: 'Email',
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Neumorphic(
                  child: TextFormField(
                    validator: (val) =>
                        val.isEmpty ? 'Обязательное поле' : null,
                    obscureText: true,
                    controller: _signInPasswordController,
                    focusNode: _passwordFocus,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock), labelText: "Пароль"),
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {},
                          child: Text(
                            'Забыли пароль?',
                            style: TextStyle(decoration: TextDecoration.underline),
                          )),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(builder: (_) => MainMenuPage()));
                          },
                          child: Text(
                            'Войти анонимно',
                            style: TextStyle(decoration: TextDecoration.underline),
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.maxFinite,
                  height: 56,
                  child: NeumorphicButton(
                    child: Center(
                      child: Text('Войти', textAlign: TextAlign.center),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Align buildLogo() {
    return Align(
        alignment: const Alignment(0, -0.75),
        child: Hero(
          tag: 'assets/images/bishkek.svg',
          child: SvgPicture.asset('assets/images/bishkek.svg',
              allowDrawingOutsideViewBox: true, height: 120),
        ));
  }

  Positioned buildLoginWith(BuildContext context) {
    return Positioned(
        right: 0,
        left: 0,
        top: MediaQuery.of(context).size.height * .8,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: Divider()),
                  SizedBox(width: 8),
                  Text('Войти через'),
                  SizedBox(width: 8),
                  Expanded(child: Divider()),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  NeumorphicButton(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.circle(),
                    ),
                    child: Icon(
                      FontAwesomeIcons.google,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                    onPressed: _googleSignInService.handleGSignIn,
                  ),
                  NeumorphicButton(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.circle(),
                    ),
                    child: Icon(
                      FontAwesomeIcons.apple,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                    onPressed: _handleAppleSignIn,
                  ),
                ],
              ),
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Не зарегистрированы ? ',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color)),
              TextSpan(
                  text: 'Зарегистрируйтесь',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) => SignUpPage())),
                  style: TextStyle(color: Colors.blueAccent)),
            ]))
          ],
        ));
  }


  Future<void> _handleAppleSignIn() async {
    try {
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
          'useBundleId': Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
          if (credential.state != null) 'state': credential.state,
        },
      );

      // If we got this far, a session based on the Apple ID credential has been created in your system,
      // and you can now set this as the app's session
//              print(session);
    } catch (error) {
      print(error);
    }
  }
}
