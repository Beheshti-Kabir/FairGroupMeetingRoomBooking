// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ui';

import 'package:auto_graph_meeting_room_booking/lobby.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class HomePage extends StatefulWidget {
  @override
  _homePage createState() => _homePage();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class _homePage extends State<HomePage> {
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


  String filterType = "autoGraph";
  String _startDateController = '';
  String _endDateController = '';

  // @override
  // initState() {
  //   super.initState();
  //   print('init');
  // }
  changeFilter(String filter)
  {
    filterType = filter;
    setState(() {

    });
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                'Summary',
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
                  height: 70,
                  color: Colors.cyan,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: (){changeFilter("autoGraph");},
                            child: Text("Auto\nGraph", style: GoogleFonts.mcLaren(
                                color: Colors.white,
                                fontSize: 18
                            ),),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 4,
                            width: 120,
                            color: (filterType== "autoGraph")?Colors.white:Colors.transparent,
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: (){changeFilter("HO");},
                            child: Text("Head\nOffice", style: GoogleFonts.mcLaren(
                                color: Colors.white,
                                fontSize: 18
                            ),),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 4,
                            width: 120,
                            color: (filterType == "HO")?Colors.white:Colors.transparent,
                          )
                        ],
                      ),Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: (){changeFilter("CO");
                            Navigator.of(context).pushNamed('/lobby');},
                            child: Text("Corporate\nOffice", style: GoogleFonts.mcLaren(
                                color: Colors.white,
                                fontSize: 18
                            ),),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 4,
                            width: 120,
                            color: (filterType == "CO")?Colors.white:Colors.transparent,
                          )
                        ],
                      )
                    ],
                  ),
                ),
            
            if (filterType == 'autoGraph') SingleChildScrollView(
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
                        child: Text('ChairmanChairman Chairman',style: GoogleFonts.mcLaren(color:Colors.lightGreenAccent,),),),
                        
                      ]
                    ),
                  ],
                ),
              ),
            )
            ],)
            ) else SingleChildScrollView(
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
           
          ],
        ),
      ),
    );
  }
}
