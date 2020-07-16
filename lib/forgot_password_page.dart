import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:mer/model/stat.dart';
import 'package:mp_chart/mp/chart/bar_chart.dart';
import 'package:mp_chart/mp/controller/bar_chart_controller.dart';
import 'package:mp_chart/mp/core/data/bar_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/bar_entry.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/image_loader.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailTEC = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text('Забыл пароль', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: emailTEC,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val.isEmpty ? 'Обязательное поле' : null,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.maxFinite,
              height: 56,
              child: OutlineButton(
                onPressed: () {
                  if (formKey.currentState.validate())
                    Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Text('Отправить', textAlign: TextAlign.center),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
