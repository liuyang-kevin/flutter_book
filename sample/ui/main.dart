import 'package:flutter/material.dart';

import 'elastic_sidebar/page.dart';

const demoName = String.fromEnvironment("DemoName", defaultValue: "main");

Future main(List<String> args) async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBackbone();
  }
}

class AppBackbone extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppBackboneState();
  }
}

class AppBackboneState extends State<AppBackbone> {
  Widget get _demoPage {
    switch (demoName) {
      case 'elastic_sidebar':
        return ElasticSidebarDemo();
      default:
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "",
      theme: ThemeData(primaryColor: Colors.blue),
      home: _demoPage,
    );
  }
}
