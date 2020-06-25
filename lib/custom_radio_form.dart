import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Gender { FEMALE, MALE,NON_BINARY }

class GenderPickerForm extends FormField<Gender> {
  GenderPickerForm({
    FormFieldValidator<Gender> validator,
    Color color,
    Gender initialValue,
  }) : super(
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<Gender> state) {
//              final gen = state.value;
              return Neumorphic(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.venusMars,
                            color: Colors.grey),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              NeumorphicRadio(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.venus,
                                          color: color),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text('Ж'),
                                      SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                onChanged: (val) {
                                  state.didChange(val);
                                  state.validate();
                                },
                                value: Gender.FEMALE,
                                groupValue: state.value,
                              ),
                              SizedBox(width: 16),
                              NeumorphicRadio(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.mars, color: color),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text('M'),
                                      SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                onChanged: (val) {
                                  state.didChange(val);
                                  state.validate();
                                },
                                value: Gender.MALE,
                                groupValue: state.value,
                              ),
                            ],
                          ),
                          state.hasError
                              ? Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      state.errorText,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  height: 8,
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
}
