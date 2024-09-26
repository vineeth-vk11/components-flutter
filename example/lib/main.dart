import 'package:flutter/material.dart';
import 'package:livekit_components/livekit_components.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  final format = DateFormat('HH:mm:ss');
  // configure logs for debugging
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((record) {
    //print('${format.format(record.time)}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      builder: FToastBuilder(),
      home: const MyApp(),
      navigatorKey: fToastNavigatorKey,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: LiveKitTheme().buildThemeData(context),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LivekitRoom(
      roomContext: RoomContext(
        url: 'ws://192.168.2.141:7880',
        token:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3Mjc5MjM2MjIsImlzcyI6IkFQSXJramtRYVZRSjVERSIsIm5hbWUiOiJmZiIsIm5iZiI6MTcyNjEyMzYyMiwic3ViIjoiZmYiLCJ2aWRlbyI6eyJyb29tIjoibGl2ZSIsInJvb21Kb2luIjp0cnVlfX0.dFzRZA88EeVIgb99f304NxcjsfL-16W9dbf05V6rOvQ',
      ),
      builder: (context) {
        return Consumer<RoomContext>(
            builder: (context, roomCtx, child) => Scaffold(
                  appBar: AppBar(
                    title: Selector<RoomContext, String>(
                      selector: (context, roomCtx) => roomCtx.roomName ?? '',
                      builder: (context, roomName, child) => Text(
                        'Room: $roomName Connected: ${roomCtx.connectState}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ParticipantListBuilder(
                            builder: (context, participants) => GridView(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, childAspectRatio: 1.5),
                              children: participants.map(
                                (p) {
                                  var ctx = ParticipantContext(p);
                                  return ChangeNotifierProvider(
                                    create: (_) => ctx,
                                    child: const Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: ParticipantWidget(),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                        const ControlBar(),
                      ],
                    ),
                  ),
                ));
      },
    );
  }
}
