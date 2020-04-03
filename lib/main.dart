import 'package:flutter/material.dart';
import 'package:api/peoplelist.dart';
import 'package:api/peopleupsert.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue,),
      initialRoute: '/peopleList',
      routes: <String,WidgetBuilder>{
        '/peopleList': (BuildContext ctx) => PeopleList(),
        '/peopleUpsert': (BuildContext ctx) => PeopleUpsert(),
      },
    );
  }
}