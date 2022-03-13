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

class RoomDetails extends StatefulWidget {
  @override
  _roomDetails createState() => _roomDetails();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class _roomDetails extends State<RoomDetails> {
  bool isLoading = false;
  bool gotData = false;

  var startDate = '';
  var endDate = '';

  late dynamic response;
  late var dataJSON;
  late String stepType = '';
  List<dynamic> meetingTitleList = [];
  List<dynamic> agendaList = [];
  List<dynamic> chairedWithList = [];
  List<dynamic> participantsList = [];
  List<dynamic> meetingDateList = [];
  List<dynamic> startTimeList = [];
  List<dynamic> endTimeList = [];

  String _startDateController = '';
  String _endDateController = '';
  String URL = '';
  String roomName = '';
  String officeName = '';
  late int dataCount;
  bool isLoadingData = false;
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

  getStepType() async {
    // setState(() {
    //   isLoading = true;
    //   print("isLoading");
    //   //print(json.decode(response.body)['totalLead']);
    //   //result = json.decode(response.body);
    //   //print("lead=" + json.decode(response.body)['totalLead']);
    //   // result['leadInfo'];
    // });
    print('inside steptype');

    response = await http.get(
      Uri.parse(URL),
      headers: <String, String>{
        'Authorization': Constants.token,
        'Accept': 'application/json'
      },
    );

    dataJSON = jsonDecode(response.body)['data'];
    dataCount = dataJSON.length;
    print(dataCount.toString());
    roomName = dataJSON[0]['room']['title'];
    officeName = dataJSON[0]['office']['title'];

    print('data is here');

    for (int i = 0; i < dataCount; i++) {
      meetingTitleList.add(dataJSON[i]['meeting_title']);
      agendaList.add(dataJSON[i]['agenda']);
      chairedWithList.add(dataJSON[i]['chaired_with']);
      participantsList.add(dataJSON[i]['no_of_participants']);
      meetingDateList.add(dataJSON[i]['start_time'].split(' ')[0]);
      var start_time = ampm(dataJSON[i]['start_time'].split(' ')[1]);
      startTimeList.add(start_time);
      var end_time = ampm(dataJSON[i]['end_time'].split(' ')[1]);
      endTimeList.add(end_time);
      print(endTimeList.toString());
    }
    print('outside loop');
    setState(() {});
    isLoadingData = true;
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments as int;
    String basicURL =
        'http://10.100.10.74/meeting_booking/api/user/room-details/';
    String arguments = argument.toString();
    URL = '$basicURL$arguments';
    print(URL.toString());
    if (!gotData) {
      getStepType();
      gotData = true;
    }

    return Scaffold(
      backgroundColor: Colors.white10,
      body: isLoadingData
          ? SingleChildScrollView(
              child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      roomName.toString(),
                      style: GoogleFonts.mcLaren(
                        fontSize: 35.0,
                        color: Colors.cyan[100],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.center,
                    color: Colors.cyan,
                    height: 80.0,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    child: Text(
                      officeName.toString(),
                      style: GoogleFonts.mcLaren(
                        fontSize: 20.0,
                        color: Colors.cyan[100],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.center,
                    color: Colors.cyan,
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  //if (room1.isNotEmpty)
                  Column(
                    children: <Widget>[
                      ListView.builder(
                          itemCount: meetingTitleList.length,
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index2) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 4.0, bottom: 10.0, right: 4.0),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.cyan,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Table(
                                  defaultColumnWidth: FixedColumnWidth(180.0),
                                  border: null,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    TableRow(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          'Meeting Title:',
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.cyanAccent),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          meetingTitleList[index2].toString(),
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.cyanAccent),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          'Agenda:',
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.cyanAccent),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          agendaList[index2].toString(),
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.cyanAccent),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            'Chaired With:',
                                            style: GoogleFonts.mcLaren(
                                                color: Colors.cyanAccent),
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          chairedWithList[index2].toString(),
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.cyanAccent),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          'Total Participants:',
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.cyanAccent),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          participantsList[index2].toString(),
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.cyanAccent),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          'Meeting Date:',
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.cyanAccent),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          meetingDateList[index2].toString(),
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.cyanAccent),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          'Start Time:',
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.cyanAccent),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          startTimeList[index2].toString(),
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.cyanAccent),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          'End Time:',
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.cyanAccent),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          endTimeList[index2].toString(),
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.cyanAccent),
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            );
                          })
                    ],
                  ),

                  Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 40.0,
                          width: 150.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.cyan,
                            color: Colors.cyan,
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                "Day Long Plan",
                                style: GoogleFonts.mcLaren(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

//}
