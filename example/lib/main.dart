import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:livekit_components/livekit_components.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'src/utils.dart';

void main() {
  final format = DateFormat('HH:mm:ss');
  // configure logs for debugging
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      //print('${format.format(record.time)}: ${record.message}');
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

  final url = 'ws://192.168.2.141:7880';
  final token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzEzNjkzNjgsImlzcyI6IkFQSXJramtRYVZRSjVERSIsIm5hbWUiOiJmbHQiLCJuYmYiOjE3Mjk1NjkzNjgsInN1YiI6ImZsdCIsInZpZGVvIjp7InJvb20iOiJsaXZlIiwicm9vbUpvaW4iOnRydWV9fQ.HVjMK_t00FlF24xIn-IZot1ROeb6JjV8QstRf2577yw';

  /// handle join button pressed, fetch connection details and connect to room.
  void _onJoinPressed(RoomContext roomCtx, String name, String roomName) async {
    if (kDebugMode) {
      print('Joining room: name=$name, roomName=$roomName');
    }
    try {
      final details = await fetchConnectionDetails(name, roomName);
      await roomCtx.connect(
          url: details.serverUrl, token: details.participantToken);
      await roomCtx.connect(
        url: url,
        token: token,
      );
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
        var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
        return Consumer<RoomContext>(
          builder: (context, roomCtx, child) => Scaffold(
            body: !roomCtx.connected && !roomCtx.connecting

                /// show prejoin screen if not connected
                ? Prejoin(
                    token: token,
                    url: url,
                    //onJoinPressed: _onJoinPressed,
                  )
                :

                /// show room screen if connected
                Row(
                    children: [
                      /// show chat widget on mobile
                      (deviceScreenType == DeviceScreenType.mobile &&
                              roomCtx.isChatEnabled)
                          ? const Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: ChatWidget(),
                              ),
                            )
                          : Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    /// show participant loop
                                    child: ParticipantLoop(
                                      showAudioTracks: false,
                                      showVideoTracks: true,

                                      /// layout builder
                                      layoutBuilder:
                                          roomCtx.focusedTrackSid != null
                                              ? const CarouselLayoutBuilder()
                                              : const GridLayoutBuilder(),

                                      /// participant builder
                                      participantBuilder: (context) {
                                        // build participant widget for each Track
                                        return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: IsSpeakingIndicator(
                                            builder: (BuildContext context) =>
                                                const Stack(
                                              children: [
                                                /// video track widget in the background
                                                VideoTrackWidget(),

                                                /// TODO: Add AudioTrackWidget or AgentVisualizerWidget later

                                                /// focus toggle button at the top right
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: FocusToggle(),
                                                ),

                                                /// track stats at the bottom right
                                                Positioned(
                                                  bottom: 30,
                                                  right: 0,
                                                  child: TrackStatsWidget(),
                                                ),

                                                /// status bar at the bottom
                                                ParticipantStatusBar(),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  /// show control bar at the bottom
                                  const ControlBar(),
                                ],
                              ),
                            ),

                      /// show chat widget on desktop
                      (deviceScreenType != DeviceScreenType.mobile &&
                              roomCtx.isChatEnabled)
                          ? const Expanded(
                              flex: 2,
                              child: SizedBox(
                                width: 400,
                                child: ChatWidget(),
                              ),
                            )
                          : const SizedBox(width: 0, height: 0),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
