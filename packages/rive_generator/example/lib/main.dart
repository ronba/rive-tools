import 'package:example/rive/samples/rocket.rive.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rive Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Rocket? rocket;
  NewArtboardButtonStateMachine? rocketController;

  @override
  void initState() {
    super.initState();
    Rocket.load().then((r) async {
      setState(() {
        rocket = r;
        rocketController = r.newArtboard.getNewArtboardButtonStateMachine();
        r.newArtboard.artboard.addController(rocketController!.controller);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final rocket = this.rocket;
    return ListView(
      children: [
        SizedBox.square(
          dimension: 200,
          child: RiveAnimation.asset(
            Rocket.assetPath,
            animations: [const NewArtboardAnimations().press],
          ),
        ),
        if (rocket != null) ...[
          SizedBox.square(
            dimension: 200,
            child: Rive(
              artboard: rocket.newArtboard.artboard,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  rocketController?.hover.value = true;
                },
                child: const Text('hover!'),
              ),
              MaterialButton(
                onPressed: () {
                  rocketController?.press.value = true;
                },
                child: const Text('press!'),
              ),
            ],
          )
        ]
      ],
    );
  }
}
