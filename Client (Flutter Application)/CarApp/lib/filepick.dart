import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'medya.dart';

class FilePick extends StatefulWidget {
  const FilePick({super.key, required this.title});
  final String title;

  @override
  State<FilePick> createState() => _FilePickState();
}

class _FilePickState extends State<FilePick> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: "Permanent"),
        ),
        centerTitle: true,
      ),
      body: AnimatedBackground(
        child: Medya(),
        behaviour: RandomParticleBehaviour(
            options: ParticleOptions(
                spawnMaxRadius: 5, spawnMinSpeed: 30, baseColor: Colors.grey)),
        vsync: this,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
