import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'audioplayer.dart';

class Medya extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(55, 105, 55, 0),
          child: Image.asset("assets/mainphoto.jpg"),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Ses Analizi Yapılacak Dosyayı Açınız",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15),
                backgroundColor: Colors.orange[400]),
            child: Text(
              "DOSYA AÇ",
              style: TextStyle(fontSize: 23),
            ),
            onPressed: () async {
              await Permission.audio.request();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPlayer()),
              );
            },
          ),
        ),
      ],
    );
  }
}

// API KULLANILARAK ALINAN MEDYA WİDGET İ
