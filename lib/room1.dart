// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ui';

import 'package:auto_graph_meeting_room_booking/lobby.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class MeetingRoom1 extends StatefulWidget {
  @override
  _meetingRoom1 createState() => _meetingRoom1();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class _meetingRoom1 extends State<MeetingRoom1> {
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
                'Meeting Room 1',
                style: GoogleFonts.mcLaren(
                  fontSize: 35.0,
                  color: Colors.pink[100],
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
              color: Colors.pink,
              height: 100.0,
              width: MediaQuery.of(context).size.width,
            ),
            

            //if (room1.isNotEmpty) 
             Column(children: <Widget>[
               Container(
                 padding: EdgeInsets.only(left: 10.0, top: 30.0),
                child:  Text (
                'Current Meeting',
                style: GoogleFonts.mcLaren( color: Colors.pink, fontSize: 20.0,fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.topLeft,
            ),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.pinkAccent,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                child: Table(
                  
                  defaultColumnWidth: FixedColumnWidth((MediaQuery.of(context).size.width)*0.5),
                  // border: TableBorder.all(color: Colors.white,
                  //                     style: BorderStyle.solid,
                  //                     width: 0),
                  children: [
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        
                        child: Text('Date',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('20/20/2022',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        
                      ]
                    ),
                    
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Start Time',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('3:10 pm',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        
                      ]
                    ),
                    
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('End Time',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('3:40 pm',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        
                      ]
                    ),
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Chaired By',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Chairman Sir',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        
                      ]
                    ),
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Booked By',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Shetu Bhai',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        
                      ]
                    ),
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Agenda',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Paperless Office',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        
                      ]
                    ),
                  ],
                ),
              ),
            )
            ],),
           
            SizedBox(
              height: 20.0,
            ),

            //if (room1.isNotEmpty) 
            Column(children: <Widget>[
               Container(
                 padding: EdgeInsets.only(left: 10.0),
                child:  Text (
                'Next Meeting',
                style: GoogleFonts.mcLaren( color: Colors.pink, fontSize: 20.0,fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.topLeft,
            ),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.pinkAccent,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                    child: Table(
                  
                  defaultColumnWidth: FixedColumnWidth((MediaQuery.of(context).size.width)*0.5),
                  // border: TableBorder.all(color: Colors.white,
                  //                     style: BorderStyle.solid,
                  //                     width: 0),
                  children: [
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        
                        child: Text('Date',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('20/20/2022',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        
                      ]
                    ),
                    
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Start Time',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('3:10 pm',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        
                      ]
                    ),
                    
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('End Time',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('3:40 pm',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        
                      ]
                    ),
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Chaired By',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Chairman Sir',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        
                      ]
                    ),
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Booked By',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Shetu Bhai',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        
                      ]
                    ),
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Agenda',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        Padding(padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Paperless Office',style: GoogleFonts.mcLaren(color:Colors.pinkAccent,fontSize: 20),),),
                        
                      ]
                    ),
                  ],
                ),
                ),
            )
            ],),
           
            SizedBox(
              height: 20.0,
            ),

            
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
                        shadowColor: Colors.pink,
                        color: Colors.pink,
                        elevation: 7.0,
                        child: Center(
                          child: Text(
                            "Day Long Plan",
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
