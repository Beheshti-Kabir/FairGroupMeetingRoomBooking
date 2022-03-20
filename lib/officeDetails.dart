// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ui';

import 'package:auto_graph_meeting_room_booking/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class OfficeDetails extends StatefulWidget {
  @override
  _officeDetails createState() => _officeDetails();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{},
    );
  }
}

class _officeDetails extends State<OfficeDetails> {
  bool isLoading = false;
  bool gotData = false;

  var startDate = '';
  var endDate = '';

  late dynamic response;

  late var roomBookings;
  late var autoGraph;
  late var headOffice;
  late var corporate;

  late var officeDataJSON;
  late var bookingDataJSON;
  var officeNumber = 0;

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

  @override
  initState() {
    super.initState();
    getData();
  }

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

    //meetingTitleList[1][1].add(1);
    print(roomNameList);
    //print('Value=' + roomNameList[0][autoGraphCode].toString());
    print('meeting count=' + meetingTitleList.toString());
    print('Chaired=' + participantsList.toString());
    setState(() {});

    //print(statusValue[0]['customerName'].toString());
  }

  Widget build(BuildContext context) {
    if (!gotData) {
      getData();
      gotData = true;
    }
    return Scaffold(
      backgroundColor: Colors.white10,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Offices',
                        style: GoogleFonts.mcLaren(
                          fontSize: 35.0,
                          color: Colors.cyan[100],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.center,
                      color: Colors.cyan,
                      height: 120.0,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ]),
              SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              Fluttertoast.showToast(
                                  msg: "Loading..",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Navigator.pushNamed(context, '/dashBoard',
                                  arguments: '0');
                            },
                            child: SizedBox(
                              height: 160.0,
                              //width: 170.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.cyanAccent,
                                color: Colors.cyan[200],
                                elevation: 7.0,
                                child: Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 25.0),
                                      Text(
                                        'Strategic Office',
                                        style: GoogleFonts.mcLaren(
                                          fontSize: 25.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        'Autograph Building, 67 & 68 Kemal Ataturk Ave, Banani, Dhaka 1213',
                                        style: GoogleFonts.mcLaren(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              Fluttertoast.showToast(
                                  msg: "Loading..",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Navigator.pushNamed(context, '/dashBoard',
                                  arguments: '1');
                            },
                            child: SizedBox(
                              height: 160.0,
                              //width: 170.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.cyanAccent,
                                color: Colors.cyan[200],
                                elevation: 7.0,
                                child: Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 25.0),
                                      Text(
                                        'Head Office',
                                        style: GoogleFonts.mcLaren(
                                          fontSize: 25.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),

                                        //textAlign: TextAlign.left,
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        'House-# 76/B, 2nd and 3rd Floor, Khawaja Palace, Road 11, Banani, Dhaka 1213',
                                        style: GoogleFonts.mcLaren(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              Fluttertoast.showToast(
                                  msg: "Loading..",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Navigator.pushNamed(context, '/dashBoard',
                                  arguments: '2');
                            },
                            child: SizedBox(
                              height: 160.0,
                              //width: 170.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.cyanAccent,
                                color: Colors.cyan[200],
                                elevation: 7.0,
                                child: Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 25.0),
                                      Text(
                                        'Corporate Office',
                                        style: GoogleFonts.mcLaren(
                                          fontSize: 25.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        'Lintoo Center (4th Floor), Holding # 82, Block # D,\nRoad # 11, Banani, Dhaka-1213',
                                        style: GoogleFonts.mcLaren(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
