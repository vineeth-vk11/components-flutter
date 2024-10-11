import 'package:flutter/material.dart' hide ConnectionState;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:livekit_client/livekit_client.dart';

mixin FToastMixin {
  final FToast fToast = FToast();

  void showConnectionStateToast(ConnectionState connectionState) {
    fToast.showToast(
      child: toast(connectionState),
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
      positionedToastBuilder: (context, child) {
        return Positioned(
          top: 24.0,
          right: 0.0,
          left: 0.0,
          child: child,
        );
      },
    );
  }

  Widget toast(ConnectionState state) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: {
              ConnectionState.connected: Colors.green,
              ConnectionState.disconnected: Colors.grey,
              ConnectionState.connecting: Colors.grey,
              ConnectionState.reconnecting: Colors.orangeAccent,
            }[state]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                {
                  ConnectionState.connected: Icons.check,
                  ConnectionState.disconnected: Icons.close,
                  ConnectionState.connecting: Icons.hourglass_top,
                  ConnectionState.reconnecting: Icons.refresh,
                }[state],
                color: Colors.white),
            const SizedBox(width: 12.0),
            Text(
              '${{
                ConnectionState.connected: 'Connected',
                ConnectionState.disconnected: 'Disconnected',
                ConnectionState.connecting: 'Connecting',
                ConnectionState.reconnecting: 'Reconnecting',
              }[state]}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
}
