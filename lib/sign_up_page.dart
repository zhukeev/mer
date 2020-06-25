import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mer/custom_radio_form.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

enum ScreenMode { SignIn, SignUp }

class _SignUpPageState extends State<SignUpPage> {
  final FocusNode _passwordFocus = FocusNode();

  var _hasInternetConnection = false;

  TextEditingController _signInEmailController = TextEditingController();
  TextEditingController _signInPasswordController = TextEditingController();

  TextEditingController _signUpFirstnameController = TextEditingController();
  TextEditingController _signUpLastnameController = TextEditingController();
  TextEditingController _signUpDOBController = TextEditingController();
  TextEditingController _signUpEmailController = TextEditingController();
  TextEditingController _signUpPasswordController = TextEditingController();

  ScreenMode screenMode = ScreenMode.SignIn;

  TextStyle inactiveSignCaption;
  TextStyle activeSignCaption;

  String gender;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  GoogleSignInAccount _currentUser;

  final signUpFormState = GlobalKey<FormState>();

  changeScreen(ScreenMode mode) {
    print(mode);
    print(screenMode);
    setState(() {
      screenMode = mode;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final bool isDark = NeumorphicTheme.of(context).isUsingDark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));

    inactiveSignCaption = TextStyle(
        color: isDark
            ? NeumorphicTheme.currentTheme(context).shadowLightColorEmboss
            : NeumorphicTheme.currentTheme(context).shadowDarkColorEmboss,
        fontSize: 20,
        fontWeight: FontWeight.bold);
    activeSignCaption = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: Text('Регистрация'),
      ),
      body: buildSignUp(context),
    );
  }

  Widget buildSignUp(BuildContext context) {
    return Form(
      key: signUpFormState,
      child: SingleChildScrollView(
        child: Neumorphic(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.all( 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Neumorphic(
                child: TextFormField(
                  controller: _signUpFirstnameController,
                  validator: (val) => val.isEmpty ? 'Обязательное поле' : null,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline), labelText: "Имя"),
                ),
              ),
              SizedBox(height: 8),
              Neumorphic(
                child: TextFormField(
                  controller: _signUpLastnameController,
                  validator: (val) => val.isEmpty ? 'Обязательное поле' : null,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      labelText: "Фамилия"),
                ),
              ),
              SizedBox(height: 8),
              Neumorphic(
                child: TextFormField(
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(Duration(days: 60 * 365)),
                        lastDate: DateTime.now().add(Duration(days: 1)));

                    if (date != null) {
                      _signUpDOBController.text =
                          DateFormat('dd.MM.yyyy').format(date);
                    }
                  },
                  controller: _signUpDOBController,
                  validator: (val) => val.isEmpty ? 'Обязательное поле' : null,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.today),
                      labelText: "Дата рождения"),
                ),
              ),
              SizedBox(height: 8),
              GenderPickerForm(
                color: inactiveSignCaption.color,
                validator: (gender) => gender == null ? 'Выберите пол' : null,
              ),
              SizedBox(height: 8),
              Neumorphic(
                  child: TextFormField(
                controller: _signUpEmailController,
                validator: (val) => val.isEmpty ? 'Обязательное поле' : null,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.alternate_email),
                    labelText: 'Email'),
              )),
              SizedBox(height: 8),
              Neumorphic(
                  child: TextFormField(
                controller: _signUpPasswordController,
                validator: (val) => val.isEmpty ? 'Обязательное поле' : null,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock), labelText: 'Пароль'),
              )),
              SizedBox(height: 8),
              Neumorphic(
                  child: TextFormField(
                validator: (val) => val != _signUpPasswordController.text
                    ? 'Пароли не совпадают'
                    : null,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Повторите пароль'),
              )),
              SizedBox(height: 8),
              SizedBox(
                width: double.maxFinite,
                height: 56,
                child: NeumorphicButton(
                  child: Center(
                    child:
                        Text('Зарегистрироваться', textAlign: TextAlign.center),
                  ),
                  onPressed: () {
                    signUpFormState.currentState.validate();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


class _GenderField extends StatelessWidget {
  final Gender gender;
  final ValueChanged<Gender> onChanged;

  const _GenderField({
    @required this.gender,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            "Gender",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            SizedBox(width: 12),
            NeumorphicRadio(
              groupValue: this.gender,
              padding: EdgeInsets.all(20),
              style: NeumorphicRadioStyle(
                boxShape: NeumorphicBoxShape.circle(),
              ),
              value: Gender.MALE,
              child: Icon(Icons.account_box),
              onChanged: (value) => this.onChanged(value),
            ),
            SizedBox(width: 12),
            NeumorphicRadio(
              groupValue: this.gender,
              padding: EdgeInsets.all(20),
              style: NeumorphicRadioStyle(
                boxShape: NeumorphicBoxShape.circle(),
              ),
              value: Gender.FEMALE,
              child: Icon(Icons.pregnant_woman),
              onChanged: (value) => this.onChanged(value),
            ),
            SizedBox(width: 12),
            NeumorphicRadio(
              groupValue: this.gender,
              padding: EdgeInsets.all(20),
              style: NeumorphicRadioStyle(
                boxShape: NeumorphicBoxShape.circle(),
              ),
              value: Gender.NON_BINARY,
              child: Icon(Icons.supervised_user_circle),
              onChanged: (value) => this.onChanged(value),
            ),
            SizedBox(
              width: 18,
            )
          ],
        ),
      ],
    );
  }
}
