// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:auto_graph_meeting_room_booking/booking.dart';
import 'package:auto_graph_meeting_room_booking/changePassword.dart';
import 'package:auto_graph_meeting_room_booking/checkAvalability.dart';
import 'package:auto_graph_meeting_room_booking/createNewUser.dart';
import 'package:auto_graph_meeting_room_booking/homePage.dart';
import 'package:auto_graph_meeting_room_booking/lobby.dart';
import 'package:auto_graph_meeting_room_booking/room1.dart';
import 'package:auto_graph_meeting_room_booking/room2.dart';
import 'package:auto_graph_meeting_room_booking/room3.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/lobby': (BuildContext context) => LobbyPage(),
        '/changePassword': (BuildContext context) => ChangePasswordPage(),
        '/createNewUser': (BuildContext context) => CreateNewUserPage(),
        '/room1': (BuildContext context) => MeetingRoom1(),
        '/room2': (BuildContext context) => MeetingRoom2(),
        '/room3': (BuildContext context) => MeetingRoom3(),
        '/booking': (BuildContext context) => BookingPage(),
        '/checkAvalability': (BuildContext context) => CheckAvailabilityPage(),
        '/homePage': (BuildContext context) => HomePage(),
        // '/summery': (BuildContext context) => SummeryPage(),
        // '/newlead': (BuildContext context) => NewLead(),
        // '/newleadtransaction': (BuildContext context) => NewLeadTransaction(),
        // '/itemdetails': (BuildContext context) => ItemDetails(),
      },
      home: MyHomePage(),
    );
  }
}

late dynamic response;
late String email;
late String password;

Future<dynamic> getAuth() async {
  response = await http.post(
      Uri.parse('http://10.100.17.45/fair_meeting/api/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }));
    if ((response.statusCode == 200)) {
      return json.decode(response.body);
    } else {
      return 'Network Issue';
      //  throw Exception("Failed to load Data");
    }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _emailValidate = false;
  bool _passwordValidate = false;
  //logInValidator(){}

  bool formValidator() {
    String email = _emailController.text;
    String password = _passwordController.text;
    setState(() {
      if (email == null || email.isEmpty) {
        _emailValidate = true;
      } else {
        _emailValidate = false;
      }
      if (password == null || password.isEmpty) {
        _passwordValidate = true;
      } else {
        _passwordValidate = false;
      }
    });
    if (!_emailValidate && !_passwordValidate) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 150.0, 0.0, 0.0),
                    child: Text(
                      'AutoGraph',
                      style: GoogleFonts.mcLaren(
                          color: Colors.green[600],
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(15.0, 175.0, 0.0, 0.0),
                  //   child: Text(
                  //     'Graph',
                  //     style: GoogleFonts.mcLaren(
                  //         color: Colors.blue[800],
                  //         fontSize: 80,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),

                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 270.0, 0.0, 0.0),
                    child: Text(
                      'Meeting',
                      style: GoogleFonts.mcLaren(
                          color: Colors.green[200],
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 310.0, 0.0, 0.0),
                    child: Text(
                      'Room',
                      style: GoogleFonts.mcLaren(
                          color: Colors.green[200],
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 350.0, 0.0, 0.0),
                    child: Text(
                      'Booking',
                      style: GoogleFonts.mcLaren(
                          color: Colors.green[200],
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 105,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                  padding: EdgeInsets.only(left: 5.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 135, 230, 138),
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _emailController,
                    style: GoogleFonts.mcLaren(color: Colors.green[100]),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorText:
                          _emailValidate ? 'Value Can\'t Be Empty' : null,

                      // hintText: "email",
                      // hintStyle: GoogleFonts.mcLaren(color: Colors.green[100]),
                      labelText: 'Email ID :',
                      labelStyle: GoogleFonts.mcLaren(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[100]),
                    ),
                  )),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _passwordController,
                  style: GoogleFonts.mcLaren(color: Colors.green[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText:
                        _passwordValidate ? 'Value Can\'t Be Empty' : null,
                    labelText: 'Password : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold, color: Colors.green[100]),
                  ),
                  obscureText: true,
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    Fluttertoast.showToast(
                        msg: "Loging In..",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.green[100],
                        fontSize: 16.0);
                    Navigator.of(context).pushNamed('/homePage');
                    bool isValid = formValidator();
                    print(_emailController.text);
                    print(_passwordController.text);

                    if (isValid) {
                      if (EmailValidator.validate(_emailController.text)) {
                        email = _emailController.text;
                        password = _passwordController.text;
                        var result  = await getAuth();
                        print('result= '+result['status'].toString());
                        if (result['status']) {
                          // if (_emailController.toString() == 'room1') {
                          //   Fluttertoast.showToast(
                          //     msg: "Logging In To Meeting Room 1",
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.TOP,
                          //     timeInSecForIosWeb: 1,
                          //     backgroundColor: Colors.red,
                          //     textColor: Colors.green[100],
                          //     fontSize: 16.0);
                          //   Navigator.of(context).pushNamed('/room1');
                          // } else if (_emailController.toString() == 'room2') {
                          //   Fluttertoast.showToast(
                          //     msg: "Logging In To Meeting Room 2",
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.TOP,
                          //     timeInSecForIosWeb: 1,
                          //     backgroundColor: Colors.red,
                          //     textColor: Colors.green[100],
                          //     fontSize: 16.0);
                          //   Navigator.of(context).pushNamed('/room2');
                          // } else if (_emailController.toString() == 'room3') {
                          //   Fluttertoast.showToast(
                          //     msg: "Logging In To Meeting Room 3",
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.TOP,
                          //     timeInSecForIosWeb: 1,
                          //     backgroundColor: Colors.red,
                          //     textColor: Colors.green[100],
                          //     fontSize: 16.0);
                          //   Navigator.of(context).pushNamed('/room3');
                          // } else {
                          Navigator.of(context).pushNamed('/lobby');
                          //}

                        } else {
                          Fluttertoast.showToast(
                              msg: "Wrong UserID or Password",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.green[100],
                              fontSize: 16.0);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Type Actual Email ID.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.green[100],
                            fontSize: 16.0);
                      }
                    }
                  },
                  child: Container(
                    height: 40.0,
                    width: 150.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      //shadowColor: Colors.lightGreenAccent,
                      color: Colors.green[900],
                      elevation: 7.0,
                      child: Center(
                        child: Text(
                          "Log In",
                          style: GoogleFonts.mcLaren(
                              color: Colors.green[100],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
