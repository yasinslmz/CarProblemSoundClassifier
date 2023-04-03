import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Album {
  String label = "";
  String urlPhoto = "";
  Album({this.label = "", this.urlPhoto = ""});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(label: json["label"], urlPhoto: json["resim"]);
  }
}

class Sonuc extends StatefulWidget {
  String soundBase64;
  Sonuc({this.soundBase64 = ""});

  @override
  State<Sonuc> createState() => _SonucState(soundBase64: soundBase64);
}

class _SonucState extends State<Sonuc> with TickerProviderStateMixin {
  var response;
  _SonucState({this.soundBase64 = ""});
  Future<Album>? myobj;
  String soundBase64 = "";

  @override
  void initState() {
    super.initState();
    (response = sendData(soundBase64)).then((value) {
      setState(() {
        myobj = toObject(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        title: Text(
          "Arıza Sonucu",
          style: TextStyle(fontFamily: "Permanent"),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }),
      ),
      body: Center(
          child: Container(
        color: Colors.grey[200],
        child: FutureBuilder<Album>(
          future: myobj,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                  child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 27),
                    child: Text(
                      snapshot.data!.label,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ), //
                  Container(
                      margin: EdgeInsets.fromLTRB(32, 0, 30, 20),
                      child: Image.asset(
                          'assets/sound${snapshot.data!.urlPhoto}.jpg')),

                  Container(
                    margin: EdgeInsets.fromLTRB(32, 20, 30, 20),
                    child: Text(
                      "Ball bearings are the most common type of wheel bearings used today (along with roller bearings—though the latter don’t have the versatility of the ball ones). Other types include tapered roller bearings, mainly used for trucks, and precision ball bearings, designed for intense radial loads. Regardless of the type your vehicle has, the warning signs are the same, specifically a bad wheel bearing sound.",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

// By default, show a loading spinner.
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Ses analiz ediliyor.. Lütfen bekleyiniz.")
                ],
              ),
            );
          },
        ),
      )),
    );
  }

  Future sendData(String soundBase64) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.103:9999'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'soundBase64': soundBase64,
      }),
    );
    if (response.statusCode == 200) {
      // print(response.body);
      print("Obje yaratıldı serverda");
      return response;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  Future<Album> toObject(value) async {
    try {
      return Album.fromJson(jsonDecode(value.body));
    } catch (e) {
      throw Exception(
        "Bir hata meydana geldi :$e",
      );
    }
  }
}
