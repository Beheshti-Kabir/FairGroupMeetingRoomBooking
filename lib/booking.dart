import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:auto_graph_meeting_room_booking/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

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

class BookingPage extends StatefulWidget {
  @override
  _roomBooking createState() {
    return _roomBooking();
  }
}

class _roomBooking extends State<BookingPage> {
  //@override
  final _creatorsEmployID = TextEditingController();
  final _chairedBy = TextEditingController();
  final _bookedBy = TextEditingController();
  final _agenda = TextEditingController();
  final _participantsNo = TextEditingController();
  final _reNewEmployIDPassword = TextEditingController();
  final _roomNo = TextEditingController();

  String? _roomNoDrop;

  bool _creatorsEmployIDValidate = false;
  bool _chairedByValidate = false;
  bool _bookedByValidate = false;
  bool _agendaValidate = false;
  bool _roomNoValidate = false;
  bool _participantsNoValidate = false;
  bool isLoad = true;

  var meeting_date = '';
  var startTime = '';
  var endtTime = '';
  var roomName = '';
  var participantsNo = '';

  late var officeDataJSON;
  late var officeNumber;
  //late var roomNumber;

  String chairedby = '';
  String bookedBy = '';
  String agenda = '';
  String _meetingDateController = '';
  String _startTimeController = '';
  String _endTimeController = '';
  String antiPost = '';

  List<dynamic> roomNameList = [];
  List<dynamic> roomCapacityList = [];
  List<dynamic> officeNameList = [];
  List<dynamic> officeWiseRoomNameList = [];
  List<dynamic> officeWiseRoomCapacity = [];

  @override
  initState() {
    super.initState();
    getRoomData();
    print('init');
  }

  getRoomData() async {
    response = await http.get(
      Uri.parse('http://192.168.0.125/fair_meeting/api/user/booking-create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xOTIuMTY4LjAuMTI1XC9mYWlyX21lZXRpbmdcL2FwaVwvdXNlclwvbG9naW4iLCJpYXQiOjE2NDYxMDg3MTMsIm5iZiI6MTY0NjEwODcxMywianRpIjoiQURkRmJqbUlPSGE5TVFxUCIsInN1YiI6MSwicHJ2IjoiZGY4ODNkYjk3YmQwNWVmOGZmODUwODJkNjg2YzQ1ZTgzMmU1OTNhOSJ9.EjFtJ7mqk9X57wU6M2JvkAz4Tj-efkUp-35D6dTjKxs'
      },
    );
    //print(response.body.toString());
    officeDataJSON = json.decode(response.body)['data']['offices'];
    // print(json.decode(response.body).toString());
    officeNumber = officeDataJSON.length;
    print(officeNumber);
    for (int i = 0; i < officeNumber; i++) {
      officeNameList.add(officeDataJSON[i]['title']);
      print(officeNameList);
      var len = officeDataJSON[i]['rooms'].length;
      officeWiseRoomNameList = [];
      officeWiseRoomCapacity = [];
      for (int j = 0; j < len; j++) {
        officeWiseRoomNameList.add(officeDataJSON[i]['rooms'][j]['title']);
        officeWiseRoomCapacity.add(officeDataJSON[i]['rooms'][j]['capacity']);
        //print(officeDataJSON[i]['rooms'][j]['title']);
      }
      roomNameList.add(officeWiseRoomNameList);
      roomCapacityList.add(officeWiseRoomCapacity);
      print(roomCapacityList);
    }
    print('out');
    //print(officeNameList);
  }

  formValidator() {
    String creatorsEmployIDVal = _creatorsEmployID.toString();
    String creatorsPasswordVal = _chairedBy.toString();
    String newEmployIDVal = _bookedBy.toString();
    String newEmployIDPasswordVal = _agenda.toString();
    String reNewEmployIDPasswordVal = _reNewEmployIDPassword.toString();

    setState(() {
      if (creatorsEmployIDVal == null || creatorsEmployIDVal.isEmpty) {
        _creatorsEmployIDValidate = true;
      } else {
        _creatorsEmployIDValidate = false;
      }
      if (creatorsPasswordVal == null || creatorsPasswordVal.isEmpty) {
        _chairedByValidate = true;
      } else {
        _chairedByValidate = false;
      }
      if (newEmployIDVal == null || newEmployIDVal.isEmpty) {
        _bookedByValidate = true;
      } else {
        _bookedByValidate = false;
      }
      if (newEmployIDPasswordVal == null || newEmployIDPasswordVal.isEmpty) {
        _agendaValidate = true;
      } else {
        _agendaValidate = false;
      }
      // if (reNewEmployIDPasswordVal == null ||
      //     reNewEmployIDPasswordVal.isEmpty) {
      //   _reNewEmployIDPasswordValidate = true;
      // } else {
      //   _reNewEmployIDPasswordValidate = false;
      // }
      // if (meetDate == null || meet_date.isEmpty) {
      //   _meetDateVaidate = true;
      // } else {
      //   _meetDateVaidate = false;
      // }
    });
    if (!_creatorsEmployIDValidate &&
        !_chairedByValidate &&
        !_bookedByValidate &&
        !_agendaValidate &&
        !_roomNoValidate) {
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
          'meetingDate': meeting_date,
          'startTime': startTime,
          'endTime': endtTime,
          'meetingRoomNo': roomName,
          'chairedBy': chairedby,
          'bookedBy': bookedBy,
          'agenda': agenda,
          'participantNo': participantsNo,
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Container(
              child: Text(
                'Room Booking',
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
            SizedBox(
              height: 50.0,
            ),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pushNamed('/checkAvalability');
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Text(
                    'Check Meeting Scedule',
                    style: GoogleFonts.mcLaren(
                      fontSize: 20.0,
                      color: Colors.lightGreen[100],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  alignment: Alignment.center,
                  color: Colors.lightGreen,
                  height: 50.0,
                  width: MediaQuery.of(context).size.width - 20,
                ),
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
                      meeting_date = date.toString();

                      var meet_date_day = date.day.toInt() < 10
                          ? '0' + date.day.toString()
                          : date.day.toString();
                      var meet_date_month = date.month.toInt() < 10
                          ? '0' + date.month.toString()
                          : date.month.toString();

                      setState(() {
                        _meetingDateController = date.year.toString() +
                            '-' +
                            meet_date_month.toString() +
                            '-' +
                            meet_date_day.toString();
                      });
                    }, currentTime: DateTime.now());
                  },
                  child: Text(
                    "Meeting Date* : $_meetingDateController",
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
                    DatePicker.showTimePicker(context, showTitleActions: true,
                        //     onChanged: (date) {
                        //   print('change $date in time zone ' +
                        //       date.timeZoneOffset.inHours.toString());
                        // },
                        onConfirm: (date) {
                      print('confirm meating date $date');
                      startTime = date.toString();

                      var startTimeMinute = date.minute.toInt() < 10
                          ? '0' + date.minute.toString()
                          : date.minute.toString();
                      var antiPost = date.hour.toInt() < 12 ? 'AM' : 'PM';
                      var startTimeHour = date.hour.toInt() > 12
                          ? (date.hour - 12).toString()
                          : date.hour.toString();

                      setState(() {
                        _startTimeController = startTimeHour.toString() +
                            ':' +
                            startTimeMinute.toString() +
                            ' ' +
                            antiPost;
                      });
                    }, currentTime: DateTime.now());
                  },
                  child: Text(
                    "Start Time* : $_startTimeController",
                    style: GoogleFonts.mcLaren(
                        fontSize: 17,
                        color: Colors.lightGreen[100],
                        fontWeight: FontWeight.bold),
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
                    DatePicker.showTimePicker(context, showTitleActions: true,
                        //     onChanged: (date) {
                        //   print('change $date in time zone ' +
                        //       date.timeZoneOffset.inHours.toString());
                        // },
                        onConfirm: (date) {
                      print('confirm meating date $date');
                      endtTime = date.toString();

                      var endTimeMinute = date.minute.toInt() < 10
                          ? '0' + date.minute.toString()
                          : date.minute.toString();
                      var postAnti = date.hour.toInt() < 12 ? 'AM' : 'PM';
                      var endTimeHour = date.hour.toInt() > 12
                          ? (date.hour - 12).toString()
                          : date.hour.toString();

                      setState(() {
                        _endTimeController = endTimeHour.toString() +
                            ':' +
                            endTimeMinute.toString() +
                            ' ' +
                            postAnti;
                      });
                    }, currentTime: DateTime.now());
                  },
                  child: Text(
                    "End Time* : $_endTimeController",
                    style: GoogleFonts.mcLaren(
                        fontSize: 17,
                        color: Colors.lightGreen[100],
                        fontWeight: FontWeight.bold),
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightGreenAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: Text(
                      'Meeting Room No* :',
                      style: GoogleFonts.mcLaren(
                          color: Colors.lightGreen[100],
                          fontWeight: FontWeight.bold),
                    ),
                    items: officeNameList
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: GoogleFonts.mcLaren(
                                    color: Colors.lightGreen[100],
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                        .toList(),
                    value: _roomNoDrop,
                    onChanged: (value) {
                      setState(() {
                        _roomNoDrop = value as String;
                      });
                    },
                    buttonHeight: 50,
                    buttonWidth: MediaQuery.of(context).size.width - 20,
                    itemHeight: 50,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightGreen,
                    ),
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
                      color: Colors.lightGreenAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _chairedBy,
                  style: GoogleFonts.mcLaren(color: Colors.lightGreen[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText:
                        _chairedByValidate ? 'Value Can\'t Be Empty' : null,
                    labelText: 'Chaired With* : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen[100]),
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
                      color: Colors.lightGreenAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _bookedBy,
                  style: GoogleFonts.mcLaren(color: Colors.lightGreen[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText:
                        _bookedByValidate ? 'Value Can\'t Be Empty' : null,
                    labelText: 'Booked By* : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen[100]),
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
                      color: Colors.lightGreenAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _agenda,
                  style: GoogleFonts.mcLaren(color: Colors.lightGreen[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: _agendaValidate ? 'Value Can\'t Be Empty' : null,
                    labelText: 'Agenda* : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen[100]),
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
                      color: Colors.lightGreenAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _agenda,
                  style: GoogleFonts.mcLaren(color: Colors.lightGreen[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: _participantsNoValidate
                        ? 'Value Can\'t Be Empty'
                        : null,
                    labelText: 'Number of Participants* : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen[100]),
                  ),
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
                            backgroundColor: Colors.lightGreenAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        setState(() {
                          isLoad = false;
                        });

                        meeting_date = _meetingDateController.toString();
                        chairedby = _chairedBy.toString();
                        bookedBy = _bookedBy.toString();
                        agenda = _agenda.toString();
                        startTime = _startTimeController.toString();
                        endtTime = _endTimeController.toString();
                        roomName = _roomNoDrop.toString();
                        participantsNo = _participantsNo.toString();

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
                          "Create",
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
            )
          ]),
        ),
      ),
    );
  }
}
