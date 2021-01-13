import 'dart:async';

import 'package:book_demos/engine/md_parser.dart';
import 'package:book_demos/widget/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framework/framework.dart';
import 'package:markdown/markdown.dart' as md;

class MdViewerPage extends StatefulPage {
  final filePath;

  MdViewerPage(this.filePath);

  @override
  ReduxState<Object, StatefulWidget> createState() => _MdViewerState();
}

class _MdViewerState extends ReduxState<int, MdViewerPage> {
  @override
  Widget get debugWidget {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            FutureBuilder(
              future: future,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) => Text(
                snapshot.data ?? "",
                overflow: TextOverflow.visible,
              ),
            )
          ],
        ),
      ],
    );
  }

  final _mdWidgets = <Widget>[];
  var renderNodeCtl = StreamController<int>();
  var parser;
  var future;

  @override
  void initState() {
    super.initState();
    parser = MarkdownParser(_mdWidgets, (){
      renderNodeCtl.add(1);
    });
    future = readMarkdown();
  }

  @override
  void dispose() {
    renderNodeCtl.close();

    super.dispose();
  }

  @override
  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<int>(
          stream: renderNodeCtl.stream,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _mdWidgets,
            );
          },
        ),
      ),
    );
  }

  @override
  int initViewModel() => 0;

  Future<String> readMarkdown() async {
    String markdownContent = await rootBundle.loadString(widget.filePath);
    Future.delayed(Duration.zero, () async {
      await Future.delayed(Duration(milliseconds: 200));
      List<String> lines = markdownContent.split('\n');
      md.Document document = md.Document(encodeHtml: false);
      for (md.Node node in document.parseLines(lines)) {
        node.accept(parser);
      }
    });
    return markdownContent;
  }
}
