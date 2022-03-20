// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ui';

import 'package:auto_graph_meeting_room_booking/constant.dart';
import 'package:auto_graph_meeting_room_booking/homePage.dart';
import 'package:auto_graph_meeting_room_booking/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class LobbyPage extends StatefulWidget {
  @override
  _lobbyPage createState() => _lobbyPage();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{},
    );
  }

  void setState(Null Function() param0) {}
}

class _lobbyPage extends State<LobbyPage> {
  @override
  double buttonWidth = 300;
  double buttonHeight = 50;
  double textSize = 20;
  String name = Constants.userName;

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,

        // appBar: AppBar(
        //   backgroundColor: Colors.amber[400],
        //   title: Text('Lobby'),
        //   titleTextStyle:GoogleFonts.mcLaren(
        //     fontSize: 21,
        //     color: Colors.amberAccent[100],
        //     fontWeight: FontWeight.bold,
        //   ) ,

        // ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Lobby',
                        style: GoogleFonts.mcLaren(
                          fontSize: 35.0,
                          color: Colors.amberAccent[200],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.center,
                      color: Colors.amber[700],
                      height: 100.0,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ]),
              Container(
                //alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                ),
                child: Text(
                  'Hi, $name ',
                  style: GoogleFonts.mcLaren(
                    fontSize: textSize,
                    color: Colors.amber[200],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 70),
                    // padding: EdgeInsets.fromLTRB(
                    //     (MediaQuery.of(context).size.width * 0.45) -
                    //         (buttonWidth / 2),
                    //     (MediaQuery.of(context).size.height * 0.15),
                    //     20.0,
                    //     0.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/booking');
                      },
                      child: Container(
                        height: buttonHeight,
                        width: buttonWidth,
                        child: Material(
                          borderRadius: BorderRadius.circular(35.0),
                          shadowColor: Colors.amberAccent,
                          color: Colors.amberAccent[700],
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              'Book A Meeting',
                              style: GoogleFonts.mcLaren(
                                fontSize: textSize,
                                color: Colors.amber[50],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(
                  //       (MediaQuery.of(context).size.width * 0.45) -
                  //           (buttonWidth / 2),
                  //       40.0,
                  //       20.0,
                  //       0.0),
                  //   child: Stack(
                  //     children: <Widget>[
                  //       GestureDetector(
                  //         onTap: () {
                  //           Navigator.of(context).pushNamed('/room1');
                  //         },
                  //         child: SizedBox(
                  //           height: buttonHeight,
                  //           width: buttonWidth,
                  //           child: Material(
                  //             borderRadius: BorderRadius.circular(35.0),
                  //             shadowColor: Colors.amberAccent,
                  //             color: Colors.amberAccent[400],
                  //             elevation: 7.0,
                  //             child: Center(
                  //               child: Text(
                  //                 'Meeting Room 1',
                  //                 style: GoogleFonts.mcLaren(
                  //                   fontSize: textSize,
                  //                   color: Colors.yellow[100],
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(
                  //       (MediaQuery.of(context).size.width * 0.45) -
                  //           (buttonWidth * 0.5),
                  //       20.0,
                  //       20.0,
                  //       0.0),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Navigator.of(context).pushNamed('/room2');
                  //     },
                  //     child: Container(
                  //       height: buttonHeight,
                  //       width: buttonWidth,
                  //       child: Material(
                  //         borderRadius: BorderRadius.circular(35.0),
                  //         shadowColor: Colors.amberAccent,
                  //         color: Colors.amberAccent[400],
                  //         elevation: 7.0,
                  //         child: Center(
                  //           child: Text(
                  //             'Meeting Room 2',
                  //             style: GoogleFonts.mcLaren(
                  //               fontSize: textSize,
                  //               color: Colors.yellow[100],
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(
                  //       (MediaQuery.of(context).size.width * 0.45) -
                  //           (buttonWidth / 2),
                  //       20.0,
                  //       20.0,
                  //       0.0),
                  //   child: Stack(
                  //     children: <Widget>[
                  //       GestureDetector(
                  //         onTap: () {
                  //           Navigator.of(context).pushNamed('/room3');
                  //         },
                  //         child: SizedBox(
                  //           height: buttonHeight,
                  //           width: buttonWidth,
                  //           child: Material(
                  //             borderRadius: BorderRadius.circular(35.0),
                  //             shadowColor: Colors.amberAccent,
                  //             color: Colors.amberAccent[400],
                  //             elevation: 7.0,
                  //             child: Center(
                  //               child: Text(
                  //                 'Meeting Room 3',
                  //                 style: GoogleFonts.mcLaren(
                  //                   fontSize: textSize,
                  //                   color: Colors.yellow[100],
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.only(top: 40),
                    // padding: EdgeInsets.fromLTRB(
                    //     (MediaQuery.of(context).size.width * 0.45) -
                    //         (buttonWidth / 2),
                    //     20.0,
                    //     20.0,
                    //     0.0),
                    child: Stack(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/officeDetails');
                          },
                          child: SizedBox(
                            height: buttonHeight,
                            width: buttonWidth,
                            child: Material(
                              borderRadius: BorderRadius.circular(35.0),
                              shadowColor: Colors.amberAccent,
                              color: Colors.amberAccent[400],
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'Offices',
                                  style: GoogleFonts.mcLaren(
                                    fontSize: textSize,
                                    color: Colors.yellow[100],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 40),
                    // padding: EdgeInsets.fromLTRB(
                    //     (MediaQuery.of(context).size.width * 0.45) -
                    //         (buttonWidth * 0.5),
                    //     40.0,
                    //     20.0,
                    //     0.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/createNewUser');
                      },
                      child: Container(
                        height: buttonHeight,
                        width: buttonWidth,
                        child: Material(
                          borderRadius: BorderRadius.circular(35.0),
                          shadowColor: Colors.amberAccent,
                          color: Colors.amberAccent,
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              'Create New User',
                              style: GoogleFonts.mcLaren(
                                fontSize: textSize,
                                color: Colors.amber[50],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    // padding: EdgeInsets.fromLTRB(
                    //     (MediaQuery.of(context).size.width * 0.45) -
                    //         (buttonWidth * 0.5),
                    //     20.0,
                    //     20.0,
                    //     0.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/changePassword');
                      },
                      child: Container(
                        height: buttonHeight,
                        width: buttonWidth,
                        child: Material(
                          borderRadius: BorderRadius.circular(35.0),
                          shadowColor: Colors.amberAccent,
                          color: Colors.amberAccent,
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              'Change Password',
                              style: GoogleFonts.mcLaren(
                                fontSize: textSize,
                                color: Colors.amber[50],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 60),
                    // padding: EdgeInsets.fromLTRB(
                    //     (MediaQuery.of(context).size.width * 0.45) -
                    //         (buttonWidth * 0.5),
                    //     20.0,
                    //     20.0,
                    //     0.0),
                    child: GestureDetector(
                      onTap: () {
                        Constants.token = '';
                        Constants.userName = '';
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => new MyHomePage()),
                            (Route<dynamic> route) => false);
                      },
                      child: Container(
                        height: buttonHeight,
                        width: buttonWidth,
                        child: Material(
                          borderRadius: BorderRadius.circular(35.0),
                          shadowColor: Colors.amberAccent,
                          color: Colors.amberAccent[100],
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              'Log Out',
                              style: GoogleFonts.mcLaren(
                                fontSize: textSize,
                                color: Colors.amber[50],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
