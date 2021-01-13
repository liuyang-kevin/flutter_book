import 'package:flutter/material.dart';

import 'black_circles/page.dart';
import 'blob_field/page.dart';
import 'curved_text/page.dart';
import 'elastic_sidebar/page.dart';
import 'fabric_simulation/page.dart';
import 'snowing/page.dart';

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
      case 'snowing':
        return SnowingDemo();
      case 'blob_field':
        return BlobFieldDemo();
      case 'black_circles':
        return BlackCirclesDemo();
      case 'fabric_simulation':
        return FabricSimulationDemo();
      case 'curved_text':
        return CurvedTextDemo();
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
