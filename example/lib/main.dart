import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:livekit_components/livekit_components.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'src/prejoin.dart';
import 'src/utils.dart';

void main() {
  final format = DateFormat('HH:mm:ss');
  // configure logs for debugging
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${format.format(record.time)}: ${record.message}');
    }
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

  void _onJoinPressed(RoomContext roomCtx, String name, String roomName) async {
    if (kDebugMode) {
      print('Joining room $roomName as $name');
    }
    try {
      final details = await fetchConnectionDetails(name, roomName);
      await roomCtx.connect(
          url: details.serverUrl, token: details.participantToken);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to join room: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LivekitRoom(
      roomContext: RoomContext(),
      builder: (context) {
        return Consumer<RoomContext>(
          builder: (context, roomCtx, child) => Scaffold(
            body: !roomCtx.connected
                ? Prejoin(
                    onJoinPressed: (name, roomName) =>
                        _onJoinPressed(roomCtx, name, roomName),
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: ParticipantListBuilder(
                                builder: (context, participants) => GridView(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 1.5),
                                  children: participants
                                      .map(
                                        (p) => ParticipantBuilder(
                                          participant: p,
                                          builder: (context) => const Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: ParticipantWidget(),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            const ControlBar(),
                          ],
                        ),
                      ),
                      Selector<RoomContext, bool>(
                          selector: (context, enabled) => roomCtx.isChatEnabled,
                          builder: (context, enabled, child) => enabled
                              ? const Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    width: 400,
                                    child: Chat(),
                                  ),
                                )
                              : const SizedBox(width: 0, height: 0)),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
