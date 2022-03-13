import 'dart:async';
import 'dart:convert';
//import 'dart:html';
import 'dart:ui';

import 'package:auto_graph_meeting_room_booking/constant.dart';
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
  final _meetingTitle = TextEditingController();

  String? _roomNoDrop;
  String? _officeNoDrop;
  String? _capacityDrop;
  int _officeID = 0;
  int? _roomID;
  String? finalMeetingDate;
  String? finalStartTime;
  String? finalEndTime;
  String? finalMessage;

  bool _creatorsEmployIDValidate = false;
  bool _chairedByValidate = false;
  bool _bookedByValidate = false;
  bool _agendaValidate = false;
  bool _roomNoValidate = false;
  bool _participantsNoValidate = false;
  bool isLoad = true;
  bool _meetingTitleValidate = false;

  var meeting_date = '';
  var startTime = '';
  var endtTime = '';
  var roomName = '';
  var participantsNo = '';

  late var officeDataJSON;
  var officeNumber = 0;
  //late var roomNumber;

  String chairedby = '';
  String bookedBy = '';
  String agenda = '';
  String _meetingDateController = '';
  String _startTimeController = '';
  String _endTimeController = '';
  String antiPost = '';
  String numberOfParticipants = '';
  String meetingTitle = '';
  String roomID = '';
  String officeID = '';

  var capacity = '0';

  bool gotData = false;

  List<dynamic> roomNameList = [];
  List<dynamic> roomCapacityList = [];
  List<dynamic> officeNameList = [];
  List<dynamic> officeWiseRoomNameList = [];
  List<dynamic> officeWiseRoomCapacity = [];
  List<dynamic> officeWiseRoomID = [];
  List<dynamic> selectedList = [];
  List<dynamic> officeIDList = [];
  List<dynamic> roomIDList = [];
  List<String> capacityNumberList = [];

  // @override
  // initState() {
  //   super.initState();
  //   getRoomData();
  //   print('init');
  // }

  getRoomData() async {
    response = await http.get(
      Uri.parse('http://10.100.10.74/meeting_booking/api/user/booking-create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': Constants.token,
      },
    );
    //print(response.body.toString());
    officeDataJSON = json.decode(response.body)['data']['offices'];
    // print(json.decode(response.body).toString());
    officeNumber = officeDataJSON.length;
    print(officeNumber);
    for (int i = 0; i < officeNumber; i++) {
      officeNameList.add(officeDataJSON[i]['title']);
      officeIDList.add(officeDataJSON[i]['id']);
      print(officeNameList);
      for (int i = 1; i <= 100; i++) {
        capacityNumberList.add(i.toString());
      }
      print(capacityNumberList);
      var len = officeDataJSON[i]['rooms'].length;
      officeWiseRoomID = [];
      officeWiseRoomNameList = [];
      officeWiseRoomCapacity = [];

      for (int j = 0; j < len; j++) {
        officeWiseRoomNameList.add(officeDataJSON[i]['rooms'][j]['title']);
        officeWiseRoomCapacity.add(officeDataJSON[i]['rooms'][j]['capacity']);
        officeWiseRoomID.add(officeDataJSON[i]['rooms'][j]['id']);
        //print(officeDataJSON[i]['rooms'][j]['title']);
      }
      roomNameList.add(officeWiseRoomNameList);
      roomCapacityList.add(officeWiseRoomCapacity);
      roomIDList.add(officeWiseRoomID);
      print(roomIDList);
    }
    print('out');
    setState(() {});

    print(roomCapacityList[0][0]);
  }

  formValidator() {
    String creatorsEmployIDVal = _creatorsEmployID.toString();
    String creatorsPasswordVal = _chairedBy.toString();
    String newEmployIDVal = _bookedBy.toString();
    String newEmployIDPasswordVal = _agenda.toString();
    String reNewEmployIDPasswordVal = _reNewEmployIDPassword.toString();
    String meetingTitleVal = _meetingTitle.toString();

    setState(() {
      if (creatorsEmployIDVal == null || creatorsEmployIDVal.isEmpty) {
        _creatorsEmployIDValidate = true;
      } else {
        _creatorsEmployIDValidate = false;
      }
      if (meetingTitleVal == null || meetingTitleVal.isEmpty) {
        _meetingTitleValidate = true;
      } else {
        _meetingTitleValidate = false;
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
        !_meetingTitleValidate &&
        !_roomNoValidate) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> createAlbum() async {
    var response = await http.post(
        Uri.parse('http://10.100.10.74/meeting_booking/api/user/booking-store'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': Constants.token,
        },
        body: jsonEncode(<String, String>{
          //'new_lead_transaction': jsonEncode(<String, String>{
          'office_id': officeID,
          'room_id': roomID,
          'agenda': agenda,
          'start_time': startTime,
          'end_time': endtTime,
          //'meeting_date': meeting_date,
          'meeting_title': meetingTitle,
          //'booked_by': bookedBy,
          'chaired_with': chairedby,
          'no_of_participants': participantsNo,
        }
            // ),}

            ));
    //print(chairedby.toString());
    print(response.statusCode);
    var responsee = json.decode(response.body)['status'];
    print(response.statusCode);
    print(responsee.toString());
    finalMessage = json.decode(response.body)['message'];
    if (response.statusCode == 200) {
      if (responsee.toString().toLowerCase().trim() == 'fail') {
        return 'Problem With the data';
      } else {
        return json.decode(response.body)['status'].toString();
      }
    } else {
      return 'Server issues';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!gotData) {
      getRoomData();
      gotData = true;
    }
    return Scaffold(
      backgroundColor: Colors.white10,
      // appBar: AppBar(
      //   title: const Text('Change Password'),
      // ),
      body: officeNameList.isNotEmpty
          ? SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 50.0,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Navigator.of(context)
                                      .pushNamed('/checkAvalability');
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
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10.0, right: 10.0),
                                child: Container(
                                  padding: EdgeInsets.only(left: 5.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.lightGreenAccent,
                                        width: 3.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextField(
                                    controller: _meetingTitle,
                                    style: GoogleFonts.mcLaren(
                                        color: Colors.lightGreen[100]),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      errorText: _meetingTitleValidate
                                          ? 'Value Can\'t Be Empty'
                                          : null,
                                      labelText: 'Meeting Title* : ',
                                      labelStyle: GoogleFonts.mcLaren(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightGreen[100]),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10.0, right: 10.0),
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
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          //     onChanged: (date) {
                                          //   print('change $date in time zone ' +
                                          //       date.timeZoneOffset.inHours.toString());
                                          // },
                                          onConfirm: (date) {
                                        print('confirm meating date $date');
                                        finalMeetingDate =
                                            date.toString().split(' ')[0];
                                        meeting_date = date.toString();
                                        print(finalMeetingDate);

                                        var meet_date_day =
                                            date.day.toInt() < 10
                                                ? '0' + date.day.toString()
                                                : date.day.toString();
                                        var meet_date_month =
                                            date.month.toInt() < 10
                                                ? '0' + date.month.toString()
                                                : date.month.toString();

                                        setState(() {
                                          _meetingDateController =
                                              date.year.toString() +
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
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10.0, right: 10.0),
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
                                      DatePicker.showTimePicker(context,
                                          showTitleActions: true,
                                          //     onChanged: (date) {
                                          //   print('change $date in time zone ' +
                                          //       date.timeZoneOffset.inHours.toString());
                                          // },
                                          onConfirm: (date) {
                                        print('confirm Start date $date');
                                        startTime = date.toString();
                                        finalStartTime = date
                                            .toString()
                                            .split(' ')[1]
                                            .split('.')[0];
                                        print(finalStartTime);

                                        var startTimeMinute =
                                            date.minute.toInt() < 10
                                                ? '0' + date.minute.toString()
                                                : date.minute.toString();
                                        var antiPost = date.hour.toInt() < 12
                                            ? 'AM'
                                            : 'PM';
                                        var startTimeHour =
                                            date.hour.toInt() > 12
                                                ? (date.hour - 12).toString()
                                                : date.hour.toString();

                                        setState(() {
                                          _startTimeController =
                                              startTimeHour.toString() +
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
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10.0, right: 10.0),
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
                                      DatePicker.showTimePicker(context,
                                          showTitleActions: true,
                                          //     onChanged: (date) {
                                          //   print('change $date in time zone ' +
                                          //       date.timeZoneOffset.inHours.toString());
                                          // },
                                          onConfirm: (date) {
                                        print('confirm end date $date');
                                        endtTime = date.toString();
                                        finalEndTime = date
                                            .toString()
                                            .split(' ')[1]
                                            .split('.')[0];
                                        print(finalEndTime);

                                        var endTimeMinute =
                                            date.minute.toInt() < 10
                                                ? '0' + date.minute.toString()
                                                : date.minute.toString();
                                        var postAnti = date.hour.toInt() < 12
                                            ? 'AM'
                                            : 'PM';
                                        var endTimeHour = date.hour.toInt() > 12
                                            ? (date.hour - 12).toString()
                                            : date.hour.toString();

                                        setState(() {
                                          _endTimeController =
                                              endTimeHour.toString() +
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
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10.0, right: 10.0),
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
                                        'Select Office* :',
                                        style: GoogleFonts.mcLaren(
                                            color: Colors.lightGreen[100],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      items: officeNameList
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  'Office Name : ' + item,
                                                  style: GoogleFonts.mcLaren(
                                                      color: Colors
                                                          .lightGreen[100],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ))
                                          .toList(),
                                      value: _officeNoDrop,
                                      onChanged: (value) {
                                        setState(() {
                                          _officeNoDrop = value as String;
                                          _officeID = officeNameList
                                              .indexOf(value) as int;
                                          selectedList =
                                              roomNameList[_officeID];
                                          officeID = officeIDList[_officeID]
                                              .toString();
                                          _roomNoDrop = selectedList[0];
                                          _roomID = 0;

                                          print(selectedList);
                                          print(_officeID.toString());
                                        });
                                      },
                                      buttonHeight: 50,
                                      buttonWidth:
                                          MediaQuery.of(context).size.width -
                                              20,
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
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10.0, right: 10.0),
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
                                        'Select Room* :',
                                        style: GoogleFonts.mcLaren(
                                            color: Colors.lightGreen[100],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      items: selectedList
                                          //items: officeNameList
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  'Room Name : ' +
                                                      item.toString(),
                                                  style: GoogleFonts.mcLaren(
                                                      color: Colors
                                                          .lightGreen[100],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ))
                                          .toList(),
                                      value: _roomNoDrop,
                                      onChanged: (value) {
                                        setState(() {
                                          _roomNoDrop = value as String;
                                          _roomID = selectedList.indexOf(value)
                                              as int;
                                          capacity = roomCapacityList[_officeID]
                                              [_roomID];
                                          roomID = roomIDList[_officeID]
                                                  [_roomID]
                                              .toString();
                                          _capacityDrop = capacityNumberList[0];
                                          print(capacity.toString());
                                        });
                                      },
                                      buttonHeight: 50,
                                      buttonWidth:
                                          MediaQuery.of(context).size.width -
                                              20,
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
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10.0, right: 10.0),
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
                                        'Number of People* :',
                                        style: GoogleFonts.mcLaren(
                                            color: Colors.lightGreen[100],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      items: capacityNumberList
                                          .take(int.parse(
                                              capacity)) //items: officeNameList
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  'Number of People : ' +
                                                      item.toString(),
                                                  style: GoogleFonts.mcLaren(
                                                      color: Colors
                                                          .lightGreen[100],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ))
                                          .toList(),
                                      value: _capacityDrop,
                                      onChanged: (value) {
                                        setState(() {
                                          _capacityDrop = value as String;
                                        });
                                      },
                                      buttonHeight: 50,
                                      buttonWidth:
                                          MediaQuery.of(context).size.width -
                                              20,
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
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10.0, right: 10.0),
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
                                    style: GoogleFonts.mcLaren(
                                        color: Colors.lightGreen[100]),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      errorText: _chairedByValidate
                                          ? 'Value Can\'t Be Empty'
                                          : null,
                                      labelText: 'Chaired With* : ',
                                      labelStyle: GoogleFonts.mcLaren(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightGreen[100]),
                                    ),
                                  ),
                                ),
                              ),

                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       top: 10, left: 10.0, right: 10.0),
                              //   child: Container(
                              //     padding: EdgeInsets.only(left: 5.0),
                              //     decoration: BoxDecoration(
                              //         border: Border.all(
                              //           color: Colors.lightGreenAccent,
                              //           width: 3.0,
                              //         ),
                              //         borderRadius: BorderRadius.circular(10)),
                              //     child: TextField(
                              //       controller: _bookedBy,
                              //       style: GoogleFonts.mcLaren(
                              //           color: Colors.lightGreen[100]),
                              //       decoration: InputDecoration(
                              //         border: InputBorder.none,
                              //         errorText: _bookedByValidate
                              //             ? 'Value Can\'t Be Empty'
                              //             : null,
                              //         labelText: 'Booked By* : ',
                              //         labelStyle: GoogleFonts.mcLaren(
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.lightGreen[100]),
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10.0, right: 10.0),
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
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    style: GoogleFonts.mcLaren(
                                        color: Colors.lightGreen[100]),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      errorText: _agendaValidate
                                          ? 'Value Can\'t Be Empty'
                                          : null,
                                      labelText: 'Agenda* : ',
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
                                      isLoad = true;
                                      if (isLoad) {
                                        bool isValid = formValidator();
                                        if (isValid) {
                                          Fluttertoast.showToast(
                                              msg: "Saving Change..",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.TOP,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Colors.lightGreenAccent,
                                              textColor: Colors.white,
                                              fontSize: 16.0);

                                          setState(() {
                                            isLoad = false;
                                          });
                                          meetingTitle =
                                              _meetingTitle.text.toString();
                                          meeting_date =
                                              _meetingDateController.toString();
                                          chairedby =
                                              _chairedBy.text.toString();

                                          bookedBy = _bookedBy.text.toString();
                                          agenda = _agenda.text.toString();
                                          startTime =
                                              '$finalMeetingDate $finalStartTime';

                                          endtTime =
                                              '$finalMeetingDate $finalEndTime';
                                          participantsNo =
                                              _capacityDrop.toString();
                                          //print(
                                          //    '$startTime $endtTime $chairedby $agenda $officeID $roomID $meetingTitle');
                                          var response = await createAlbum();
                                          //print(startTime + '\n' + endtTime);
                                          print(response);
                                          if (response.toLowerCase().trim() ==
                                              'true') {
                                            Fluttertoast.showToast(
                                                msg: finalMessage.toString(),
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.TOP,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            Navigator.of(context)
                                                .pushReplacementNamed('/lobby');
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                    )
                  ]),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
