import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'sonuc.dart';

class MyPlayer extends StatefulWidget {
  const MyPlayer({Key? key}) : super(key: key);

  @override
  State<MyPlayer> createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> with TickerProviderStateMixin {
  final player = AudioPlayer();
  bool isStart = true;
  String soundpath = "";
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String soundBase64 = "";

  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    openFile();
    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isStart = !(state == PlayerState.playing);
      });
    });
    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    player.onPositionChanged.listen((newPosition) {
      setState(() {
        if (position.inSeconds.toDouble().round() !=
            duration.inSeconds.toDouble().round()) {
          position = newPosition;
        }
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
          "Arıza Ses Analizi",
          style: TextStyle(fontFamily: "Permanent"),
        ),
        centerTitle: true,
      ),
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
              spawnMaxRadius: 5, spawnMinSpeed: 30, baseColor: Colors.grey),
        ),
        vsync: this,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(50, 105, 50, 0),
              child: Image.asset("assets/audiophoto.jpg"),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(95, 20, 95, 10),
              child: ListTile(
                minLeadingWidth: 30,
                leading: Icon(
                  Icons.audio_file,
                  color: Colors.purple,
                ),
                title: Text(
                  "İncelenecek Ses",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.purple),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(60, 0, 50, 0),
              child: Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  position = Duration(seconds: value.toInt());
                  await player.seek(position);
                },
              ),
            ), // Slider
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration - position)),
                ],
              ),
            ), // Textler
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: CircleAvatar(
                radius: 35,
                child: IconButton(
                  icon: Icon(isStart ? Icons.play_arrow : Icons.pause),
                  onPressed: () async {
                    setState(() {
                      if (isStart == true) {
                        player.play(DeviceFileSource(soundpath));
                        isStart = false;
                        if (position.inSeconds.toDouble().round() ==
                            duration.inSeconds.toDouble().round()) {
                          position = Duration(seconds: 0);
                        }
                      } else {
                        player.pause();
                        isStart = true;
                        if (position.inSeconds.toDouble().round() ==
                            duration.inSeconds.toDouble().round()) {
                          position = Duration(seconds: 0);
                          ;
                        }
                      }
                    });
                  },
                  iconSize: 50,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(95, 20, 80, 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, padding: EdgeInsets.all(0)),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Sonuc(
                              soundBase64: soundBase64,
                            )),
                  );
                },
                child: ListTile(
                  minLeadingWidth: 30,
                  leading: Icon(
                    Icons.arrow_right_alt,
                    color: Colors.yellow,
                    size: 40,
                  ),
                  title: Text(
                    "Arızayı Tespit Et",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.white),
                  ),
                ),
              ),
            ), // Button
          ],
        ),
      ),
    );
  }

  String formatTime(Duration duration) {
    String? twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [minutes, seconds].join(":");
  }

  Future? openFile() async {
    final file = await pickFile();
    if (file == null) return;
    print('path:${file.path}');
    soundpath = file.path;
    await toConvert(file);
  }

  Future toConvert(File file) async {
    final soundBytes = await file.readAsBytes();
    soundBase64 = base64.encode(soundBytes);
  }

  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return null;
    return File(result.files.first.path!);
  }
}
