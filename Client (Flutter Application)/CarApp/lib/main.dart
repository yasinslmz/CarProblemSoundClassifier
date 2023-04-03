import 'package:flutter/material.dart';
import 'dart:async';
import 'filepick.dart';
import 'package:animated_background/animated_background.dart';

void main() {
  runApp(MaterialApp(home: MyApp())); // to run the project
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FilePick(title: "Ses Dosyası")));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: AnimatedBackground(
          child: Center(
            child: Text(
              "  CAR  SOUND  \n   ANALYZER",
              style: TextStyle(
                  fontSize: 57,
                  color: Colors.orange[400],
                  fontFamily: "Permanent"),
            ),
          ),
          behaviour: RandomParticleBehaviour(
            options: ParticleOptions(
                spawnMaxRadius: 5, spawnMinSpeed: 80, baseColor: Colors.grey),
          ),
          vsync: this,
        ),
      ),
    );
  }
}
