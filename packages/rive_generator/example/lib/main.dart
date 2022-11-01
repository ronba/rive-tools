import 'package:example/rive/samples/liquid_download.rive.dart' as l;
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

const addProgressKey = Key('Add Progress');
const startKey = ValueKey('Start');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Rive Asset Generation - Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  l.Liquid_download? liquid;
  l.ArtboardDownloadStateMachine? liquidController;

  @override
  Widget build(BuildContext context) {
    final rocket = liquid;
    return ListView(
      children: [
        const SizedBox.square(
          dimension: 200,
          child: l.ArtboardRive(),
        ),
        const SizedBox.square(
          dimension: 200,
          child: l.ArtboardRive(
            animations: [
              l.ArtboardAnimations.complete,
            ],
          ),
        ),
        SizedBox.square(
          dimension: 200,
          child: l.ArtboardRive(
            controllers: [
              l.ArtboardAnimations.demo.makeSimpleAnimation(),
              l.ArtboardAnimations.complete.makeOneShotAnimation(),
            ],
          ),
        ),
        if (rocket != null) ...[
          SizedBox.square(
            dimension: 200,
            child: Rive(
              artboard: liquid!.artboard.artboard,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                key: startKey,
                onPressed: () {
                  liquidController!.download.fire();
                },
                child: const Text('Start'),
              ),
              MaterialButton(
                key: addProgressKey,
                onPressed: () {
                  liquidController!.progress.value += 10;
                },
                child: const Text('Add Progress!'),
              ),
            ],
          )
        ]
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    l.Liquid_download.load().then((r) async {
      setState(() {
        liquid = r;
        liquidController = r.artboard.getArtboardDownloadStateMachine();
        r.artboard.artboard.addController(liquidController!.controller);
      });
    });
  }
}
