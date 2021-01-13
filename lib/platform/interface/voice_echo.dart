import 'package:flutter/widgets.dart';

abstract class IVoiceEcho {
  Widget get visualMFCC;
  void start();

  void stop();
}
