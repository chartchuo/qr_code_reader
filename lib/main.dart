import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:share/share.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final items = List<String>.generate(3, (i) => "Item ${i + 1}");
  final title = 'QR Code Reader';

  Future<String> _barcodeString;

  final topAppBar = AppBar(
    elevation: 0.1,
    backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
    title: Text('QR Reader'),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.list),
        onPressed: () {},
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
      home: Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: topAppBar,
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            // final item = index;
            return Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  onTap: () {
                    Share.share('$item');
                  },
                  onLongPress: () {
                    setState(() {
                      items.removeAt(index);
                    });
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.white24))),
                    child: StringIcon('$item'),
                  ),
                  title: Text(
                    "$item",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          onPressed: () {
            _barcodeString = QRCodeReader()
                .setAutoFocusIntervalInMs(200)
                .setForceAutoFocus(true)
                .setTorchEnabled(true)
                .setHandlePermissions(true)
                .setExecuteAfterPermissionGranted(true)
                .scan();
            _barcodeString.then((String str) {
              if (str == null) return;
              setState(() {
                items.add(str);
              });
            });
          },
          tooltip: 'Reader the QRCode',
          child: Icon(Icons.add_a_photo, color: Colors.white,),
        ),
      ),
    );
  }
}

class StringIcon extends StatelessWidget {
  final String str;
  final RegExp httpRegExp = new RegExp(
    r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$",
    caseSensitive: false,
    multiLine: false,
  );
  final RegExp numRegExp = new RegExp(
    r"^[-+]?\d+$",
    caseSensitive: false,
    multiLine: false,
  );

  StringIcon(this.str);

  @override
  Widget build(BuildContext context) {
    if (httpRegExp.hasMatch(str)) {
      return Icon(Icons.http, color: Colors.white);
    }
    if (numRegExp.hasMatch(str)) {
      return Icon(Icons.format_list_numbered, color: Colors.white);
    }
    return Icon(Icons.text_fields, color: Colors.white);
  }
}
