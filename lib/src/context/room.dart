import 'package:flutter/material.dart' hide ConnectionState;
import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:flutter_background/flutter_background.dart';

class RoomContext extends ChangeNotifier {
  RoomContext({
    required String url,
    required String token,
    RoomOptions roomOptions = const RoomOptions(),
    ConnectOptions? connectOptions,
  })  : _url = url,
        _token = token,
        _connectOptions = connectOptions {
    _room = Room(roomOptions: roomOptions);
    _listener = _room.createListener();
    _listener
      ..on<RoomConnectedEvent>((event) {
        notifyListeners();
      })
      ..on<RoomDisconnectedEvent>((event) {
        notifyListeners();
      })
      ..on<ParticipantConnectedEvent>((event) {
        notifyListeners();
      })
      ..on<ParticipantDisconnectedEvent>((event) {
        notifyListeners();
      })
      ..on<LocalTrackPublishedEvent>((event) {
        notifyListeners();
      })
      ..on<TrackPublishedEvent>((event) {
        notifyListeners();
      })
      ..on<TrackUnpublishedEvent>((event) {
        notifyListeners();
      });

    connect();
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  Future<void> connect() async {
    await _room.connect(
      _url,
      _token,
      fastConnectOptions: _fastConnectOptions,
      connectOptions: _connectOptions,
    );
    notifyListeners();
  }

  Future<void> disconnect() async {
    await _room.disconnect();
    _localVideoTrack = null;
    notifyListeners();
  }

  final ConnectOptions? _connectOptions;

  FastConnectOptions? _fastConnectOptions;

  FastConnectOptions? get fastConnectOptions => _fastConnectOptions;

  set fastConnectOptions(FastConnectOptions? value) {
    _fastConnectOptions = value;
    notifyListeners();
  }

  late EventsListener<RoomEvent> _listener;

  final String _url;

  final String _token;

  Room get room => _room;

  late Room _room;

  bool get isMicrophoneEnabled =>
      _room.localParticipant?.isMicrophoneEnabled() ?? false;

  String? get roomName => _room.name;

  String? get roomMetadata => _room.metadata;

  int get participantCount => participants.length;

  List<Participant> get participants => [
        ..._room.remoteParticipants.values,
      ];

  ConnectionState get connectState => _room.connectionState;

  bool get connected => _room.connectionState == ConnectionState.connected;

  VideoTrack? _localVideoTrack;
  VideoTrack? get localVideoTrack => _localVideoTrack;

  bool get isCameraEnabled =>
      _room.localParticipant?.isCameraEnabled() ?? false;

  void enableCamera() async {
    var pub = await _room.localParticipant?.setCameraEnabled(true);
    if (pub != null) {
      _localVideoTrack = pub.track as VideoTrack;
    }
    notifyListeners();
  }

  void disableCamera() async {
    await _room.localParticipant?.setCameraEnabled(false);
    _localVideoTrack = null;
    notifyListeners();
  }

  void enableMicrophone() async {
    await _room.localParticipant?.setMicrophoneEnabled(true);
    notifyListeners();
  }

  void disableMicrophone() async {
    await _room.localParticipant?.setMicrophoneEnabled(false);
    notifyListeners();
  }

  bool get isScreenShareEnabled =>
      _room.localParticipant?.isScreenShareEnabled() ?? false;

  Future<void> enableScreenShare(context) async {
    if (lkPlatformIsDesktop()) {
      try {
        final source = await showDialog<rtc.DesktopCapturerSource>(
          context: context,
          builder: (context) => ScreenSelectDialog(),
        );
        if (source == null) {
          print('cancelled screenshare');
          return;
        }
        print('DesktopCapturerSource: ${source.id}');
        var track = await LocalVideoTrack.createScreenShareTrack(
          ScreenShareCaptureOptions(
            sourceId: source.id,
            maxFrameRate: 15.0,
          ),
        );
        await _room.localParticipant?.publishVideoTrack(track);
      } catch (e) {
        print('could not publish video: $e');
      }
      return;
    }
    if (lkPlatformIs(PlatformType.android)) {
      // Android specific
      bool hasCapturePermission = await rtc.Helper.requestCapturePermission();
      if (!hasCapturePermission) {
        return;
      }

      requestBackgroundPermission([bool isRetry = false]) async {
        // Required for android screenshare.
        try {
          bool hasPermissions = await FlutterBackground.hasPermissions;
          if (!isRetry) {
            const androidConfig = FlutterBackgroundAndroidConfig(
              notificationTitle: 'Screen Sharing',
              notificationText: 'LiveKit Example is sharing the screen.',
              notificationImportance: AndroidNotificationImportance.normal,
              notificationIcon: AndroidResource(
                  name: 'livekit_ic_launcher', defType: 'mipmap'),
            );
            hasPermissions = await FlutterBackground.initialize(
                androidConfig: androidConfig);
          }
          if (hasPermissions &&
              !FlutterBackground.isBackgroundExecutionEnabled) {
            await FlutterBackground.enableBackgroundExecution();
          }
        } catch (e) {
          if (!isRetry) {
            return await Future<void>.delayed(const Duration(seconds: 1),
                () => requestBackgroundPermission(true));
          }
          print('could not publish video: $e');
        }
      }

      await requestBackgroundPermission();
    }
    if (lkPlatformIs(PlatformType.iOS)) {
      var track = await LocalVideoTrack.createScreenShareTrack(
        const ScreenShareCaptureOptions(
          useiOSBroadcastExtension: true,
          maxFrameRate: 15.0,
        ),
      );
      await _room.localParticipant?.publishVideoTrack(track);
      return;
    }

    if (lkPlatformIsWebMobile()) {
      await context
          .showErrorDialog('Screen share is not supported on mobile web');
      return;
    }

    await _room.localParticipant
        ?.setScreenShareEnabled(true, captureScreenAudio: true);
    notifyListeners();
  }

  Future<void> disableScreenShare() async {
    await _room.localParticipant?.setScreenShareEnabled(false);
    notifyListeners();
  }
}
