// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ui';

import 'package:auto_graph_meeting_room_booking/constant.dart';
import 'package:auto_graph_meeting_room_booking/lobby.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _dashBoardPage createState() => _dashBoardPage();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class _dashBoardPage extends State<DashBoardPage> {
  bool isLoading = false;
  bool gotData = false;

  var startDate = '';
  var endDate = '';

  late dynamic response;
  late int officeID;

  late var roomBookings;
  late var autoGraph;
  late var headOffice;
  late var corporate;

  late var officeDataJSON;
  late var bookingDataJSON;
  var officeNumber = 0;
  late int dataCount;

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
  List<dynamic> meetingTitleList = [];
  List<dynamic> agendaList = [];
  List<dynamic> chairedWithList = [];
  List<dynamic> startTimeList = [];
  List<dynamic> endTimeList = [];
  List<dynamic> participantsList = [];
  List<dynamic> meetingDateList = [];
  List<dynamic> officeWiseMeetingDateList = [];
  List<dynamic> officeWiseMeetingTitleList = [];
  List<dynamic> officeWiseAgendaList = [];
  List<dynamic> officeWiseChaireWithList = [];
  List<dynamic> officeWiseStartTimeList = [];
  List<dynamic> officeWiseEndTimeList = [];
  List<dynamic> officeWiseParticipantList = [];

  String _startDateController = '';
  String _endDateController = '';

  // @override
  // initState() {
  //   super.initState();
  //   print('init');
  // }

  ampm(var time) {
    String minute = time.toString().split(':')[1];
    String hour = time.toString().split(':')[0];
    String antiPost = '';
    String finalHourString = '';
    if (int.parse(hour) > 12) {
      antiPost = 'PM';
      int finalHour = int.parse(hour);
      finalHour = finalHour - 12;
      finalHourString = finalHour.toString();
    } else {
      antiPost = 'AM';
      finalHourString = hour;
    }
    String finalAnswer = '$finalHourString:$minute $antiPost';
    return finalAnswer;
  }

  getData() async {
    // setState(() {
    //   isLoading = true;
    //   print("isLoading");
    //   //print(json.decode(response.body)['totalLead']);
    //   //result = json.decode(response.body);
    //   //print("lead=" + json.decode(response.body)['totalLead']);
    //   // result['leadInfo'];
    // });
    print('inside getData');
    response = await http.get(
      Uri.parse('http://10.100.10.74/meeting_booking/api/user/room-show'),
      headers: <String, String>{
        'Authorization': Constants.token,
        'Accept': 'application/json'
      },
    );

    officeDataJSON = json.decode(response.body)['data']['offices'];
    // print(json.decode(response.body).toString());

    officeNumber = officeDataJSON.length;
    for (int i = 1; i <= 100; i++) {
      capacityNumberList.add(i.toString());
    }
    print(officeNumber);
    for (int i = 0; i < officeNumber; i++) {
      officeNameList.add(officeDataJSON[i]['title']);
      officeIDList.add(officeDataJSON[i]['id']);
      //print(officeNameList);

      //print(capacityNumberList);
      var len = officeDataJSON[i]['rooms'].length;
      officeWiseRoomID = [];
      officeWiseRoomNameList = [];
      officeWiseMeetingTitleList = [];
      officeWiseAgendaList = [];
      officeWiseChaireWithList = [];
      officeWiseEndTimeList = [];
      officeWiseParticipantList = [];
      officeWiseStartTimeList = [];
      officeWiseMeetingDateList = [];

      for (int j = 0; j < len; j++) {
        officeWiseRoomNameList.add(officeDataJSON[i]['rooms'][j]['title']);
        officeWiseRoomID.add(officeDataJSON[i]['rooms'][j]['id']);
        officeWiseMeetingTitleList.add([]);
        officeWiseAgendaList.add([]);
        officeWiseChaireWithList.add([]);
        officeWiseEndTimeList.add([]);
        officeWiseParticipantList.add([]);
        officeWiseStartTimeList.add([]);
        officeWiseMeetingDateList.add([]);
        //print('sami $j');
        //print(officeDataJSON[i]['rooms'][j]['title']);
      }
      //print(officeWiseMeetingTitleList);
      roomNameList.add(officeWiseRoomNameList);
      roomIDList.add(officeWiseRoomID);
      meetingTitleList.add(officeWiseMeetingTitleList);
      agendaList.add(officeWiseAgendaList);
      startTimeList.add(officeWiseStartTimeList);
      endTimeList.add(officeWiseEndTimeList);
      participantsList.add(officeWiseParticipantList);
      chairedWithList.add(officeWiseChaireWithList);
      meetingDateList.add(officeWiseMeetingDateList);
    }
    print('out of office');
    print('in booking office');

    bookingDataJSON = json.decode(response.body)['data']['booking'];

    //meetingTitleList[0][0].add(1);
    //print(meetingTitleList[0][0]);
    for (int p = 0; p < bookingDataJSON.length; p++) {
      int first_para = int.parse(bookingDataJSON[p]['office_id'].toString());
      first_para = first_para - 1;
      int second_para = int.parse(bookingDataJSON[p]['room_id'].toString());
      if (second_para > meetingTitleList[first_para].length) {
        second_para = second_para - 1;
        second_para = second_para -
            int.parse(meetingTitleList[first_para].length.toString());
      } else {
        second_para = second_para - 1;
      }

      print("object $first_para $second_para");
      meetingTitleList[first_para][second_para]
          .add(bookingDataJSON[p]['meeting_title']);
      agendaList[first_para][second_para].add(bookingDataJSON[p]['agenda']);
      meetingDateList[first_para][second_para]
          .add(bookingDataJSON[p]['start_time'].split(' ')[0]);
      var start_time = ampm(bookingDataJSON[p]['start_time'].split(' ')[1]);
      startTimeList[first_para][second_para].add(start_time);
      var end_time = ampm(bookingDataJSON[p]['end_time'].split(' ')[1]);
      endTimeList[first_para][second_para].add(end_time);
      chairedWithList[first_para][second_para]
          .add(bookingDataJSON[p]['chaired_with']);
      participantsList[first_para][second_para]
          .add(bookingDataJSON[p]['no_of_participants']);
      print(meetingDateList.toString());
      //print(bookingDataJSON[p]['meeting_title']);
    }
    dataCount = meetingTitleList[officeID].length;

    //meetingTitleList[1][1].add(1);
    print(roomNameList);
    print('meeting count=' + meetingTitleList.toString());
    print('Chaired=' + participantsList.toString());
    setState(() {});

    //print(statusValue[0]['customerName'].toString());
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments as String;
    officeID = int.parse(argument);

    if (!gotData) {
      getData();
      gotData = true;
    }

    return Scaffold(
      backgroundColor: Colors.white10,
      body: officeIDList.isNotEmpty
          ? SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Dash Board',
                        style: GoogleFonts.mcLaren(
                          fontSize: 35.0,
                          color: Colors.cyan[100],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.center,
                      color: Colors.cyan,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Container(
                      child: Text(
                        officeNameList[officeID].toString(),
                        style: GoogleFonts.mcLaren(
                          fontSize: 20.0,
                          color: Colors.cyan[100],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.center,
                      color: Colors.cyan[300],
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        ListView.builder(
                            itemCount: roomNameList[officeID].length,
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    print(
                                        roomIDList[officeID][index].toString());
                                    Fluttertoast.showToast(
                                        msg: "Loading..",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    meetingTitleList[officeID][index].length ==
                                            0
                                        ? Fluttertoast.showToast(
                                            msg: "No Meeting",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0)
                                        : Navigator.pushNamed(
                                            context, '/roomDetails',
                                            arguments: roomIDList[officeID]
                                                [index]);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 10.0,
                                        right: 10.0,
                                        bottom: 10.0),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.cyan,
                                            width: 3.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        roomNameList[officeID][index],
                                        style: GoogleFonts.mcLaren(
                                            color: Colors.cyan,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ListView.builder(
                                    itemCount: meetingTitleList[officeID][index]
                                        .length,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index2) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4.0,
                                            bottom: 10.0,
                                            right: 4.0),
                                        child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.cyan,
                                                width: 3.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Table(
                                            defaultColumnWidth:
                                                FixedColumnWidth(180.0),
                                            border: null,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              TableRow(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    'Meeting Title:',
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.cyanAccent),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    meetingTitleList[officeID]
                                                            [index][index2]
                                                        .toString(),
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.cyanAccent),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    'Agenda:',
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.cyanAccent),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    agendaList[officeID][index]
                                                            [index2]
                                                        .toString(),
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.cyanAccent),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0),
                                                    child: Text(
                                                      'Chaired With:',
                                                      style:
                                                          GoogleFonts.mcLaren(
                                                              color: Colors
                                                                  .cyanAccent),
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    chairedWithList[officeID]
                                                            [index][index2]
                                                        .toString(),
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.cyanAccent),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    'Total Participants:',
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.cyanAccent),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    participantsList[officeID]
                                                            [index][index2]
                                                        .toString(),
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.cyanAccent),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    'Meeting Date:',
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.cyanAccent),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    meetingDateList[officeID]
                                                            [index][index2]
                                                        .toString(),
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.cyanAccent),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    'Start Time:',
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.cyanAccent),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    startTimeList[officeID]
                                                            [index][index2]
                                                        .toString(),
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.cyanAccent),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    'End Time:',
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.cyanAccent),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    endTimeList[officeID][index]
                                                            [index2]
                                                        .toString(),
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.cyanAccent),
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                              ]);
                            })
                      ],
                    ))
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
