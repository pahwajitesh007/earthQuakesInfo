import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _quakesMap;
List mQuakesList;

void main() async {
  _quakesMap = await getQuakes();
  mQuakesList = _quakesMap['features'];
  // print(_quakesMap);
  runApp(MaterialApp(
    title: "Quakes",
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quakes"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white30,
        alignment: Alignment.center,
        child: ListView.builder(
          itemCount: mQuakesList.length,
          itemBuilder: (BuildContext context, int postion) {
            if (postion.isOdd) return new Divider();
            //formating the date and time in
            //"https://pub.dartlang.org/packages/intl" install this package to get the DateFormat class
            var format = new DateFormat("yMEd").add_jm();
            //converting microseconds into human readable text
            var date = format.format(DateTime.fromMicrosecondsSinceEpoch(
                mQuakesList[postion]['properties']['time'] * 1000,
                isUtc: true));
            return ListTile(
              title: Text("At : $date"),
              subtitle: Text("${mQuakesList[postion]['properties']['title']}"),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  "${mQuakesList[postion]['properties']['mag']}",
                  style: TextStyle(fontSize: 15.00, color: Colors.white),
                ),
              ),
              onTap: () {
                openDailog(
                    context, "${mQuakesList[postion]['properties']['place']}");
              },
            );
          },
        ),
      ),
    );
  }

  void openDailog(BuildContext context, String msg) {
    var alert = AlertDialog(
      title: Text("Quake!"),
      content: Text(
        msg,
        style: TextStyle(color: Colors.black, fontSize: 20.00),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"))
      ],
    );
    showDialog(context: context, child: alert);
  }
}

Future<Map> getQuakes() async {
  String apiUrl =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}
