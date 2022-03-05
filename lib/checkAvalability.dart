// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ui';

import 'package:auto_graph_meeting_room_booking/lobby.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}

class CheckAvailabilityPage extends StatefulWidget {
  @override
  _checkAvailability createState() => _checkAvailability();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class _checkAvailability extends State<CheckAvailabilityPage> {
  bool isLoading = false;
  bool gotData = false;

  var startDate = '';
  var endDate = '';

  late dynamic response;
  late var totalInvoice = '';
  late var totalPna = '';
  late var totalFollowUp = '';
  late var totalLead = '';
  late var totalCancel = '';
  late var totalInProgress = '';
  late var totalNoAnswer = '';
  late String stepType = '';
  List<dynamic> room1 = [];
  List<dynamic> room2 = [];
  List<dynamic> room3 = [];

  String _startDateController = '';
  String _endDateController = '';

  // @override
  // initState() {
  //   super.initState();
  //   print('init');
  // }

  getStepType() async {
    // setState(() {
    //   isLoading = true;
    //   print("isLoading");
    //   //print(json.decode(response.body)['totalLead']);
    //   //result = json.decode(response.body);
    //   //print("lead=" + json.decode(response.body)['totalLead']);
    //   // result['leadInfo'];
    // });

    response = await http.post(
        Uri.parse('http://202.84.44.234:9085/rbd/leadInfoApi/getDataByStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          // 'userID': Constants.employeeId,
          'stepType': stepType,
        }));

    room1 = jsonDecode(response.body)['room1'];
    room2 = jsonDecode(response.body)['room2'];
    room3 = jsonDecode(response.body)['room3'];
    //print(statusValue[0]['customerName'].toString());
  }

  @override
  Widget build(BuildContext context) {
    if (!gotData) {
      getStepType();
      gotData = true;
    }

    return Scaffold(
      backgroundColor: Colors.white10,
      body: SingleChildScrollView(
          child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                'Room Schedule',
                style: GoogleFonts.mcLaren(
                  fontSize: 35.0,
                  color: Colors.lightGreen[100],
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
              color: Colors.green,
              height: 100.0,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightGreenAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context, showTitleActions: true,
                        //     onChanged: (date) {
                        //   print('change $date in time zone ' +
                        //       date.timeZoneOffset.inHours.toString());
                        // },
                        onConfirm: (date) {
                      print('confirm meating date $date');
                      startDate = date.toString();

                      var startDateDay = date.day.toInt() < 10
                          ? '0' + date.day.toString()
                          : date.day.toString();
                      var startDateMonth = date.month.toInt() < 10
                          ? '0' + date.month.toString()
                          : date.month.toString();

                      setState(() {
                        _startDateController = date.year.toString() +
                            '-' +
                            startDateMonth.toString() +
                            '-' +
                            startDateDay.toString();
                      });
                    }, currentTime: DateTime.now());
                  },
                  child: Text(
                    "Start Date* : $_startDateController",
                    style: GoogleFonts.mcLaren(
                        fontSize: 17,
                        color: Colors.lightGreen[100],
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightGreenAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context, showTitleActions: true,
                        //     onChanged: (date) {
                        //   print('change $date in time zone ' +
                        //       date.timeZoneOffset.inHours.toString());
                        // },
                        onConfirm: (date) {
                      print('confirm meating date $date');
                      endDate = date.toString();

                      var endDateDay = date.day.toInt() < 10
                          ? '0' + date.day.toString()
                          : date.day.toString();
                      var endDateMonth = date.month.toInt() < 10
                          ? '0' + date.month.toString()
                          : date.month.toString();

                      setState(() {
                        _endDateController = date.year.toString() +
                            '-' +
                            endDateMonth.toString() +
                            '-' +
                            endDateDay.toString();
                      });
                    }, currentTime: DateTime.now());
                  },
                  child: Text(
                    "End Date* : $_endDateController",
                    style: GoogleFonts.mcLaren(
                        fontSize: 17,
                        color: Colors.lightGreen[100],
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    getStepType();
                  },
                  child: Container(
                    height: 40.0,
                    width: 150.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.lightGreen[600],
                      color: Colors.green[800],
                      elevation: 7.0,
                      child: Center(
                        child: Text(
                          "Search",
                          style: GoogleFonts.mcLaren(
                              color: Colors.lightGreen[100],
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
            ),

            //if (room1.isNotEmpty) 
            SingleChildScrollView(
             child: Column(children: <Widget>[
               Container(
                 padding: EdgeInsets.only(left: 10.0),
                child:  Text (
                'Meeting Room 1',
                style: GoogleFonts.mcLaren( color: Colors.green, fontSize: 20.0,fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.topLeft,
            ),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.greenAccent,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                child: Table(
                  
                  defaultColumnWidth: FixedColumnWidth((MediaQuery.of(context).size.width)*0.30),
                  // border: TableBorder.all(color: Colors.white,
                  //                     style: BorderStyle.solid,
                  //                     width: 0),
                  children: [
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        
                        child: Text('Date',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent,fontWeight: FontWeight.bold),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Time',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent,fontWeight: FontWeight.bold),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Chaired By',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent,fontWeight: FontWeight.bold),),)
                      ]
                    ),
                    
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('10/10/2022',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('3:10 pm - 3:45 pm',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('ChairmanChairman Chairman',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),)
                      ]
                    ),
                    
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('10/10/2022',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('3:10 pm - 3:45 pm',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('ChairmanChairman Chairman',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),)
                      ]
                    ),
                  ],
                ),
              ),
            )
            ],)
            ) ,
            SizedBox(
              height: 20.0,
            ),

            //if (room1.isNotEmpty) 
            SingleChildScrollView(
             child: Column(children: <Widget>[
               Container(
                 padding: EdgeInsets.only(left: 10.0),
                child:  Text (
                'Meeting Room 2',
                style: GoogleFonts.mcLaren( color: Colors.green, fontSize: 20.0,fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.topLeft,
            ),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.greenAccent,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                child: Table(
                  
                  defaultColumnWidth: FixedColumnWidth((MediaQuery.of(context).size.width)*0.30),
                  // border: TableBorder.all(color: Colors.white,
                  //                     style: BorderStyle.solid,
                  //                     width: 2),
                  children: [
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Date',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent,fontWeight: FontWeight.bold),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Time',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent,fontWeight: FontWeight.bold),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Chaired By',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent,fontWeight: FontWeight.bold),),)
                      ]
                    ),
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('10/10/2022',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('3:10 pm - 3:45 pm',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('ChairmanChairman Chairman',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent,),),)
                      ]
                    ),
                  ],
                ),
              ),
            )
            ],)
            ) ,
            SizedBox(
              height: 20.0,
            ),

            //if (room1.isNotEmpty) 
            SingleChildScrollView(
             child: Column(children: <Widget>[
               Container(
                 padding: EdgeInsets.only(left: 10.0),
                child:  Text (
                'Meeting Room 3',
                style: GoogleFonts.mcLaren( color: Colors.green, fontSize: 20.0,fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.topLeft,
            ),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                 decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.greenAccent,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                child: Table(
                  
                  defaultColumnWidth: FixedColumnWidth((MediaQuery.of(context).size.width)*0.30),
                  // border: TableBorder.all(color: Colors.white,
                  //                     style: BorderStyle.solid,
                  //                     width: 2),
                  children: [
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Date',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent,fontWeight: FontWeight.bold),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Time',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent,fontWeight: FontWeight.bold),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Chaired By',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent,fontWeight: FontWeight.bold),),)
                      ]
                    ),
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('10/10/2022',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('3:10 pm - 3:45 pm',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('ChairmanChairman Chairman',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),)
                      ]
                    ),
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('10/10/2022',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('3:10 pm - 3:45 pm',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('ChairmanChairman Chairman',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),)
                      ]
                    ),
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('10/10/2022',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('3:10 pm - 3:45 pm',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('ChairmanChairman Chairman',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent),),)
                      ]
                    ),
                  ],
                ),
              ),
            )
            ],)
            ) ,
            SizedBox(height: 20.0,),
            Container(
              alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 40.0,
                    width: 150.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.green,
                        color: Colors.green,
                        elevation: 7.0,
                        child: Center(
                          child: Text(
                            "Booking Page",
                            style:
                                GoogleFonts.mcLaren(color: Colors.white,),
                          ),
                        ),
                      ),
                    ),)),
                    SizedBox(height: 20.0,),

          ],
        ),
      )),
    );
  }
}
