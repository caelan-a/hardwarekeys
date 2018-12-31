import 'dart:async';
import 'package:flutter/services.dart';

const EventChannel _hardwareKeyEventChannel =
    EventChannel('github.caelana.hardwarekeys');

class HardwareKeyEvent {
  HardwareKeyEvent(this.type);

  String type;

  @override
  String toString() => '[KeyEvent (type: $type)]';
}


Stream<HardwareKeyEvent> _hardwareKeyEvents;

/// A broadcast stream of events from the device accelerometer.
Stream<HardwareKeyEvent> get hardwareKeyEvents {
  if (_hardwareKeyEvents == null) {
    _hardwareKeyEvents = _hardwareKeyEventChannel
        .receiveBroadcastStream()
        .map(
            (dynamic event) => HardwareKeyEvent(event));
  }
  return _hardwareKeyEvents;
}
