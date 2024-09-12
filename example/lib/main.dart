import 'package:flutter/material.dart';
import 'package:livekit_components/livekit_components.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

void main() {
  final format = DateFormat('HH:mm:ss');
  // configure logs for debugging
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((record) {
    print('${format.format(record.time)}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
        url: 'ws://192.168.0.141:7880',
        token:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3Mjc5MjM2MjIsImlzcyI6IkFQSXJramtRYVZRSjVERSIsIm5hbWUiOiJmZiIsIm5iZiI6MTcyNjEyMzYyMiwic3ViIjoiZmYiLCJ2aWRlbyI6eyJyb29tIjoibGl2ZSIsInJvb21Kb2luIjp0cnVlfX0.dFzRZA88EeVIgb99f304NxcjsfL-16W9dbf05V6rOvQ',
      ),
      builder: (context) {
        return Consumer<RoomContext>(
            builder: (context, roomCtx, child) => Scaffold(
                  appBar: AppBar(
                    title: Text(
                        'Room State:  ${roomCtx.connected.toString()} [${roomCtx.roomName ?? ''}] '),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const CameraPreview(),
                        Text(
                          'Connected: ${roomCtx.connected}',
                        ),
                        Text(
                          'Room Name: ${roomCtx.roomName ?? ''}',
                        ),
                        Text(
                          'Participants: ${roomCtx.participants.length}',
                        ),
                        Text(
                          'Local Tracks: ${roomCtx.localTracks.length}',
                        ),
                        Text(
                          'Remote Tracks: ${roomCtx.remoteTracks.length}',
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      roomCtx.connected
                          ? roomCtx.disconnect()
                          : roomCtx.connect();
                    },
                    tooltip: roomCtx.connected ? 'Disconnect' : 'Connect',
                    child: const Icon(Icons.login),
                  ), // This trailing comma makes auto-formatting nicer for build methods.
                ));
      },
    );
  }
}
