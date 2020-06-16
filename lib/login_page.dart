import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neumorphic/neumorphic.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _passwordFocus = FocusNode();

  var _hasInternetConnection = false;

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
              alignment: const Alignment(0, -0.8),
              child: SvgPicture.asset(
                "Assets.login_logo",
                color: Theme.of(context).accentColor,
              )),
          Align(
              alignment: const Alignment(0.0, 0.3),
              child: NeuCard(
                  curveType: CurveType.flat,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: NeumorphicDecoration(
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 16),
                      Center(
                          child: const Text('Авторизация',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          onSubmitted: (str) => FocusScope.of(context)
                              .requestFocus(_passwordFocus),
                          decoration: InputDecoration(
                            errorText: null,
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          obscureText: true,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          decoration: InputDecoration(
                              errorText: null, labelText: "Пароль"),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(boxShadow: [
                              const BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 5),
                                  blurRadius: 8)
                            ], borderRadius: BorderRadius.circular(5)),
                            child: NeuButton(
                              child: Text('Авторизоваться'),
                              onPressed: () {},
                            )),
                      ),
                      SizedBox(height: 16),
                    ],
                  ))),
        ],
      ),
    );
  }
}
