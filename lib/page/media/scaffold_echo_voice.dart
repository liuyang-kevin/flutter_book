import 'package:app_lib/app_lib.dart';
import 'package:book_demos/platform/service.dart';
import 'package:flutter/material.dart';

class ScaffoldEchoVoice extends StatefulWidget {
  @override
  _ScaffoldEchoVoiceState createState() => _ScaffoldEchoVoiceState();
}

class _ScaffoldEchoVoiceState extends State<ScaffoldEchoVoice> {
  AppPlatformService aps = AppPlatformService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<String>(
                future: AppLib.platformVersion,
                builder: (_, snap) {
                  print(snap.data);
                  return Text(snap.data ?? '');
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(child: Text('录'), onPressed: () => aps.start()),
                RaisedButton(child: Text('停'), onPressed: () => aps.stop()),
                SizedBox(width: 20),
                RaisedButton(child: Text('录'), onPressed: () => aps.start()),
                RaisedButton(child: Text('停'), onPressed: () => aps.stop()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
