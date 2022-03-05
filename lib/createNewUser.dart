import 'dart:convert';
import 'dart:ui';

import 'package:auto_graph_meeting_room_booking/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CreateNewUserPage extends StatefulWidget {
  @override
  _createNewUser createState() {
    return _createNewUser();
  }
}

class _createNewUser extends State<CreateNewUserPage> {
  //@override
  final _creatorsEmployID = TextEditingController();
  final _creatorsPassword = TextEditingController();
  final _newEmployID = TextEditingController();
  final _newEmployIDPassword = TextEditingController();
  final _reNewEmployIDPassword = TextEditingController();

  bool _creatorsEmployIDValidate = false;
  bool _creatorsPasswordValidate = false;
  bool _newEmployIDValidate = false;
  bool _newEmployIDPasswordValidate = false;
  bool _reNewEmployIDPasswordValidate = false;

  bool isLoad = true;

  String creatorsEmployID = '';
  String creatorsPassword = '';
  String newEmployID = '';
  String newEmployIDPassword = '';
  String reNewEmployIDPassword = '';

  formValidator() {
    String creatorsEmployIDVal = _creatorsEmployID.toString();
    String creatorsPasswordVal = _creatorsPassword.toString();
    String newEmployIDVal = _newEmployID.toString();
    String newEmployIDPasswordVal = _newEmployIDPassword.toString();
    String reNewEmployIDPasswordVal = _reNewEmployIDPassword.toString();
    setState(() {
      if (creatorsEmployIDVal == null || creatorsEmployIDVal.isEmpty) {
        _creatorsEmployIDValidate = true;
      } else {
        _creatorsEmployIDValidate = false;
      }
      if (creatorsPasswordVal == null || creatorsPasswordVal.isEmpty) {
        _creatorsPasswordValidate = true;
      } else {
        _creatorsPasswordValidate = false;
      }
      if (newEmployIDVal == null || newEmployIDVal.isEmpty) {
        _newEmployIDValidate = true;
      } else {
        _newEmployIDValidate = false;
      }
      if (newEmployIDPasswordVal == null || newEmployIDPasswordVal.isEmpty) {
        _newEmployIDPasswordValidate = true;
      } else {
        _newEmployIDPasswordValidate = false;
      }
      if (reNewEmployIDPasswordVal == null ||
          reNewEmployIDPasswordVal.isEmpty) {
        _reNewEmployIDPasswordValidate = true;
      } else {
        _reNewEmployIDPasswordValidate = false;
      }
      // if (meetDate == null || meet_date.isEmpty) {
      //   _meetDateVaidate = true;
      // } else {
      //   _meetDateVaidate = false;
      // }
    });
    if (!_creatorsEmployIDValidate &&
        !_creatorsPasswordValidate &&
        !_newEmployIDValidate &&
        !_newEmployIDPasswordValidate &&
        !_reNewEmployIDPasswordValidate) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> createAlbum() async {
    var response = await http.post(
        Uri.parse('http://202.84.44.234:9085/rbd/leadInfoApi/changePwd'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          //'new_lead_transaction': jsonEncode(<String, String>{
          'username': creatorsEmployID,
          'creatorsPassword': creatorsPassword,
          //'newPassword': newPassword
        }
            // ),}

            ));
    var responsee = json.decode(response.body)['result'];
    if (response.statusCode == 200) {
      if (responsee.toString().toLowerCase().trim() == 'fail') {
        return 'Creator\'s EmployID & Password Don\'t Match';
      } else {
        return json.decode(response.body)['result'];
      }
    } else {
      return 'Server issues';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      // appBar: AppBar(
      //   title: const Text('Change Password'),
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(children: <Widget>[
            Container(
              child: Text(
                'Create New User',
                style: GoogleFonts.mcLaren(
                  fontSize: 35.0,
                  color: Colors.lightBlue[100],
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
              color: Colors.lightBlue,
              height: 100.0,
              width: MediaQuery.of(context).size.width,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 100, left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlueAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _creatorsEmployID,
                  style: GoogleFonts.mcLaren(color: Colors.lightBlue[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: _creatorsEmployIDValidate
                        ? 'Value Can\'t Be Empty'
                        : null,
                    labelText: 'Creator\'s EmployID* : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold, color: Colors.lightBlue[100]),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlueAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _creatorsPassword,
                  style: GoogleFonts.mcLaren(color: Colors.lightBlue[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: _creatorsPasswordValidate
                        ? 'Value Can\'t Be Empty'
                        : null,
                    labelText: 'Creator\'s Password* : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold, color: Colors.lightBlue[100]),
                  ),
                  obscureText: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlueAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _newEmployID,
                  style: GoogleFonts.mcLaren(color: Colors.lightBlue[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText:
                        _newEmployIDValidate ? 'Value Can\'t Be Empty' : null,
                    labelText: 'New EmployID* : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold, color: Colors.lightBlue[100]),
                  ),
                  obscureText: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlueAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _newEmployIDPassword,
                  style: GoogleFonts.mcLaren(color: Colors.lightBlue[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: _newEmployIDPasswordValidate
                        ? 'Value Can\'t Be Empty'
                        : null,
                    labelText: 'New Employ Password* : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold, color: Colors.lightBlue[100]),
                  ),
                  obscureText: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlueAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _reNewEmployIDPassword,
                  style: GoogleFonts.mcLaren(color: Colors.lightBlue[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: _reNewEmployIDPasswordValidate
                        ? 'Value Can\'t Be Empty'
                        : null,
                    labelText: 'Re-type New Employ Password* : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold, color: Colors.lightBlue[100]),
                  ),
                  obscureText: true,
                ),
              ),
            ),

            SizedBox(height: 40.0),
            // save
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    if (isLoad) {
                      bool isValid = formValidator();
                      if (isValid) {
                        Fluttertoast.showToast(
                            msg: "Saving Change..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.lightBlueAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        setState(() {
                          isLoad = false;
                        });

                        if (_newEmployID.toString() != _newEmployIDPassword.toString()) {
                          Fluttertoast.showToast(
                              msg: "Typed Password Don't Match",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.lightBlueAccent,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          setState(
                            () {
                              isLoad = true;
                            },
                          );
                        } else {
                          creatorsEmployID = _creatorsEmployID.toString();
                          creatorsPassword = _creatorsPassword.toString();
                          newEmployID = _newEmployID.toString();
                          newEmployIDPassword = _newEmployIDPassword.toString();
                          reNewEmployIDPassword = _reNewEmployIDPassword.toString();

                          var response = await createAlbum();

                          if (response.toLowerCase().trim() == 'success') {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => new MyHomePage()),
                                (Route<dynamic> route) => false);
                          } else {
                            setState(
                              () {
                                isLoad = true;
                              },
                            );
                            Fluttertoast.showToast(
                                msg: response,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }

                          print('MyResponse=>$response');
                        }
                      }
                    }
                  },
                  child: Container(
                    height: 40.0,
                    width: 150.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.lightBlue[600],
                      color: Colors.blue[800],
                      elevation: 7.0,
                      child: Center(
                        child: Text(
                          "Create",
                          style: GoogleFonts.mcLaren(
                              color: Colors.lightBlue[100],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            )
          ]),
        ),
      ),
    );
  }
}
