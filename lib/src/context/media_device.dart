import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:livekit_client/livekit_client.dart';

import '../ui/debug/logger.dart';

mixin MediaDeviceContextMixin on ChangeNotifier {
  Room? _room;

  CameraPosition position = CameraPosition.front;

  List<MediaDevice>? _audioInputs;
  List<MediaDevice>? _audioOutputs;
  List<MediaDevice>? _videoInputs;

  List<MediaDevice>? get audioInputs => _audioInputs;
  List<MediaDevice>? get audioOutputs => _audioOutputs;
  List<MediaDevice>? get videoInputs => _videoInputs;

  String? selectedVideoInputDeviceId;

  String? selectedAudioInputDeviceId;

  String? selectedAudioOutputDeviceId;

  Future<void> loadDevices() async {
    _loadDevices(await Hardware.instance.enumerateDevices());
    Hardware.instance.onDeviceChange.stream.listen(_loadDevices);
  }

  _loadDevices(List<MediaDevice> devices) {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _audioOutputs = devices.where((d) => d.kind == 'audiooutput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();

    selectedAudioInputDeviceId ??= _audioInputs?.first.deviceId;
    selectedVideoInputDeviceId ??= _videoInputs?.first.deviceId;
    selectedAudioOutputDeviceId ??= _audioOutputs?.first.deviceId;
    notifyListeners();
  }

  void setRoom(Room? room) {
    _room = room;
  }

  LocalVideoTrack? _localVideoTrack;

  LocalVideoTrack? get localVideoTrack => _localVideoTrack;

  bool get cameraOpened =>
      _room != null ? isCameraEnabled : _localVideoTrack != null;

  Future<void> resetLocalTracks() async {
    _localAudioTrack = null;
    _localVideoTrack = null;
    notifyListeners();
  }

  LocalAudioTrack? _localAudioTrack;

  LocalAudioTrack? get localAudioTrack => _localAudioTrack;

  bool get microphoneOpened =>
      _room != null ? isMicrophoneEnabled : _localAudioTrack != null;

  void selectAudioInput(MediaDevice device) async {
    selectedAudioInputDeviceId = device.deviceId;
    if (_room != null) {
      await _room!.setAudioInputDevice(device);
    } else {
      await _localAudioTrack?.dispose();
      _localAudioTrack = await LocalAudioTrack.create(
        AudioCaptureOptions(
          deviceId: selectedAudioInputDeviceId,
        ),
      );
    }
    notifyListeners();
  }

  void selectAudioOutput(MediaDevice device) async {
    selectedAudioOutputDeviceId = device.deviceId;
    if (_room != null) {
      await _room!.setAudioOutputDevice(device);
    }
    notifyListeners();
  }

  Future<void> selectVideoInput(MediaDevice device) async {
    selectedVideoInputDeviceId = device.deviceId;
    if (_room != null) {
      await _room!.setVideoInputDevice(device);
    } else {
      await _localVideoTrack?.dispose();
      _localVideoTrack = await LocalVideoTrack.createCameraTrack(
        CameraCaptureOptions(
          cameraPosition: position,
          deviceId: device.deviceId,
        ),
      );
    }
    notifyListeners();
  }

  bool get isMicrophoneEnabled =>
      _room?.localParticipant?.isMicrophoneEnabled() ?? false;

  void enableMicrophone() async {
    if (microphoneOpened) {
      return;
    }
    if (_room?.localParticipant != null) {
      await _room?.localParticipant?.setMicrophoneEnabled(true);
    } else {
      _localAudioTrack ??= await LocalAudioTrack.create(
        AudioCaptureOptions(
          deviceId: selectedAudioInputDeviceId,
        ),
      );
    }
    notifyListeners();
  }

  void disableMicrophone() async {
    if (!microphoneOpened) {
      return;
    }
    if (_room != null) {
      await _room?.localParticipant?.setMicrophoneEnabled(false);
    } else {
      await _localAudioTrack?.dispose();
      _localAudioTrack = null;
    }
    notifyListeners();
  }

  bool get isCameraEnabled =>
      _room?.localParticipant?.isCameraEnabled() ?? false;

  void enableCamera() async {
    if (cameraOpened) {
      return;
    }
    if (_room != null) {
      await _room?.localParticipant?.setCameraEnabled(true,
          cameraCaptureOptions: CameraCaptureOptions(
            deviceId: selectedVideoInputDeviceId,
          ));
    } else {
      _localVideoTrack ??= await LocalVideoTrack.createCameraTrack(
        CameraCaptureOptions(
          cameraPosition: position,
          deviceId: selectedVideoInputDeviceId,
        ),
      );
    }

    notifyListeners();
  }

  void disableCamera() async {
    if (!cameraOpened) {
      return;
    }
    if (_room != null) {
      await _room?.localParticipant?.setCameraEnabled(false);
    } else {
      await _localVideoTrack?.dispose();
      _localVideoTrack = null;
    }
    notifyListeners();
  }

  bool get isScreenShareEnabled =>
      _room?.localParticipant?.isScreenShareEnabled() ?? false;

  Future<void> enableScreenShare(context) async {
    if (lkPlatformIsDesktop()) {
      try {
        final source = await showDialog<rtc.DesktopCapturerSource>(
          context: context,
          builder: (context) => ScreenSelectDialog(),
        );
        if (source == null) {
          Debug.log('cancelled screenshare');
          return;
        }
        Debug.log('DesktopCapturerSource: ${source.id}');
        var track = await LocalVideoTrack.createScreenShareTrack(
          ScreenShareCaptureOptions(
            sourceId: source.id,
            maxFrameRate: 15.0,
          ),
        );
        await _room?.localParticipant?.publishVideoTrack(track);
      } catch (e) {
        Debug.log('could not publish video: $e');
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
          Debug.log('could not publish video: $e');
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
      await _room?.localParticipant?.publishVideoTrack(track);
      return;
    }

    if (lkPlatformIsWebMobile()) {
      await context
          .showErrorDialog('Screen share is not supported on mobile web');
      return;
    }

    await _room?.localParticipant
        ?.setScreenShareEnabled(true, captureScreenAudio: true);
    notifyListeners();
  }

  Future<void> disableScreenShare() async {
    await _room?.localParticipant?.setScreenShareEnabled(false);
    notifyListeners();
  }
}
