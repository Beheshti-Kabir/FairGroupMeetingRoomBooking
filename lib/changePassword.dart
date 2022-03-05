import 'dart:convert';
import 'dart:ui';

import 'package:auto_graph_meeting_room_booking/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;


class ChangePasswordPage extends StatefulWidget {
  @override
  _changePassword createState() {
    return _changePassword();
  }
}

class _changePassword extends State<ChangePasswordPage> {
  //@override
  final _employID = TextEditingController();
  final _oldPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _reNewPassword = TextEditingController();

  bool _employIDValidate = false;
  bool _oldPasswordValidate = false;
  bool _newPasswordValidate = false;
  bool _reNewPasswordValidate = false;

  bool isLoad = true;

  String employID = '';
  String oldPassword = '';
  String newPassword = '';
  String reNewPassword = '';

  formValidator() {
    String employIDVal = _employID.toString();
    //String meetDate = _meetDateController.text;
    String oldPasswordVal = _oldPassword.toString();
    String newPasswordVal = _newPassword.toString();
    String reNewpasswordVal = _reNewPassword.toString();
    setState(() {
      if (employIDVal == null || employIDVal.isEmpty) {
        _employIDValidate = true;
      } else {
        _employIDValidate = false;
      }
      if (oldPasswordVal == null || oldPasswordVal.isEmpty) {
        _oldPasswordValidate = true;
      } else {
        _oldPasswordValidate = false;
      }
      if (newPasswordVal == null || newPasswordVal.isEmpty) {
        _newPasswordValidate = true;
      } else {
        _newPasswordValidate = false;
      }
      if (reNewpasswordVal == null || reNewpasswordVal.isEmpty) {
        _reNewPasswordValidate = true;
      } else {
        _reNewPasswordValidate = false;
      }
      // if (meetDate == null || meet_date.isEmpty) {
      //   _meetDateVaidate = true;
      // } else {
      //   _meetDateVaidate = false;
      // }
    });
    if (!_employIDValidate &&
        !_oldPasswordValidate &&
        !_newPasswordValidate &&
        !_reNewPasswordValidate) {
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
          'username': employID,
          'oldPassword': oldPassword,
          'newPassword': newPassword
        }
            // ),}

            ));
    var responsee = json.decode(response.body)['result'];
    if (response.statusCode == 200) {
      if (responsee.toString().toLowerCase().trim()=='fail') {
        return 'EmployID & Password Don\'t Match';
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
                  child: Text('Change Password',
                  style: GoogleFonts.mcLaren(
                    
                    fontSize: 35.0,
                    color: Colors.red[100],
                    fontWeight: FontWeight.bold,
                  ),),
                  alignment: Alignment.center,
                  color: Colors.red[600],
                  height: 100.0,
                  width: MediaQuery.of(context).size.width,
                ),
            
            Padding(
                padding: const EdgeInsets.only(top:100, left: 10.0,right: 10.0),
                child: Container(
                  padding: EdgeInsets.only(left:5.0),
                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.redAccent,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                    child:
                      TextField(
                        controller: _employID,
                        style: GoogleFonts.mcLaren(color: Colors.red[100]),
                        decoration: InputDecoration(
                           border: InputBorder.none,
                          errorText:
                              _employIDValidate ? 'Value Can\'t Be Empty' : null,
                          labelText: 'EmployID* : ',
                          labelStyle: GoogleFonts.mcLaren(
                              fontWeight: FontWeight.bold, color: Colors.red[100]),
                          
                        ),
                        
                      )
                    ,),
                  
                
              ),
      
              Padding(
                padding: const EdgeInsets.only(top:10, left: 10.0,right: 10.0),
                child: Container(
                  padding: EdgeInsets.only(left:5.0),
                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.redAccent,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                    child:
                      TextField(
                        controller: _oldPassword,
                        style: GoogleFonts.mcLaren(color: Colors.red[100]),
                        decoration: InputDecoration(
                           border: InputBorder.none,
                          errorText:
                              _oldPasswordValidate ? 'Value Can\'t Be Empty' : null,
                          labelText: 'Old Password* : ',
                          labelStyle: GoogleFonts.mcLaren(
                              fontWeight: FontWeight.bold, color: Colors.red[100]),
                          
                        ),
                        obscureText: true,
                      )
                    ,),
                  
                
              ),
              Padding(
                padding: const EdgeInsets.only(top:10, left: 10.0,right: 10.0),
                child: Container(
                  padding: EdgeInsets.only(left:5.0),
                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.redAccent,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                    child:
                      TextField(
                        controller: _newPassword,
                        style: GoogleFonts.mcLaren(color: Colors.red[100]),
                        decoration: InputDecoration(
                           border: InputBorder.none,
                          errorText:
                              _newPasswordValidate ? 'Value Can\'t Be Empty' : null,
                          labelText: 'New Password* : ',
                          labelStyle: GoogleFonts.mcLaren(
                              fontWeight: FontWeight.bold, color: Colors.red[100]),
                          
                        ),
                        obscureText: true,
                      )
                    ,),
                  
                
              ),
              Padding(
                padding: const EdgeInsets.only(top:10, left: 10.0,right: 10.0),
                child: Container(
                  padding: EdgeInsets.only(left:5.0),
                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.redAccent,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                    child:
                      TextField(
                        controller: _reNewPassword,
                        style: GoogleFonts.mcLaren(color: Colors.red[100]),
                        decoration: InputDecoration(
                           border: InputBorder.none,
                          errorText:
                              _reNewPasswordValidate ? 'Value Can\'t Be Empty' : null,
                          labelText: 'Re-type New Password* : ',
                          labelStyle: GoogleFonts.mcLaren(
                              fontWeight: FontWeight.bold, color: Colors.red[100]),
                          
                        ),
                        obscureText: true,
                      )
                    ,),
                  
                
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
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);
        
                        setState(() {
                          isLoad = false;
                        });
        
                        if (_newPassword.text != _reNewPassword.text) {
                          Fluttertoast.showToast(
                              msg: "Typed Password Don't Match",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0);
                              setState(
                              () {
                                isLoad = true;
                              },
                            );
                        } else {
                          employID = _employID.text;
                          oldPassword = _oldPassword.text;
                          newPassword = _newPassword.text;
                          reNewPassword = _reNewPassword.text;
        
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
                                backgroundColor: Colors.redAccent,
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
                      shadowColor: Colors.red[600],
                      color: Colors.red[600],
                      elevation: 7.0,
                      child: Center(
                        child: Text(
                          "Save Change",
                          style: TextStyle(
                              color: Colors.red[100], fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,)
          ]),
        ),
      ),
    );
  }
}
