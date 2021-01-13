import 'dart:async';

import 'package:book_demos/engine/md_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown/markdown.dart' as md;

class ScaffoldMdViewer extends StatefulWidget {
  final filePath;

  ScaffoldMdViewer(this.filePath);
  @override
  State createState() => _MdViewerState();
}

class _MdViewerState extends State<ScaffoldMdViewer> {
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
  Scaffold build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Flexible(
              child: FutureBuilder(
                future: future,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) => Text(
                  snapshot.data ?? "",
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
          Container(
            child: Flexible(
              fit: FlexFit.loose,
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
          )
        ],
      ),
    );
  }

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

// class MdNodeWidget extends State

// Widget wrapperWidget(md.Element element, List<Widget> children) {
//   return GestureDetector(
//     onTap: () => print("${element.tag}"),
//     child: Container(
//       margin: EdgeInsets.only(left: 8.0),
//       color: Colors.black26,
//       child: children.length > 1
//           ? Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: children,
//             )
//           : children.first,
//     ),
//   );
// }

// class NodeConvert {
//   final String tag;
//   final Widget Function(List<Widget>) wrapper;

//   NodeConvert(this.tag, this.wrapper);
//   @override
//   String toString() => "nc:$tag";
// }
