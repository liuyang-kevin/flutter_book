import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown/markdown.dart' as md;

class MarkdownParser implements md.NodeVisitor {
  final List<Widget> _list;
  final Function _callback;

  MarkdownParser(this._list, this._callback);

  List contentWidgets = [];

  @override
  void visitElementAfter(md.Element element) {
    _callback();
  }

  @override
  bool visitElementBefore(md.Element element) {
    _list.addAll(_createWidget(element, 0, TextStyle()));
    _callback();
    return false;
  }

  @override
  void visitText(md.Text text) {
    print('vet: ${text.textContent}');
  }

  TextSpan _createText(md.Element pElement, md.Text t, TextStyle superStyle) {
    TextStyle style = _createTextStyle(pElement, superStyle);
    return TextSpan(
        text: t.textContent.trim(),
        style: style,
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            //这里做点击事件
            print('MarkdownParser._createText ${pElement.attributes}');
//                        String url = 'http://www.baidu.com';
//                        if (await canlaunch(url)){
//                          await launch(url);
//                        }
          });
  }

  TextStyle _createTextStyle(md.Element element, TextStyle superStyle) {
    switch (element.tag) {
      case 'h1':
        return TextStyle(fontSize: 32, fontWeight: FontWeight.bold).merge(superStyle);
      case 'h2':
        return TextStyle(fontSize: 24, fontWeight: FontWeight.bold).merge(superStyle);
      case 'a':
        return TextStyle(color: Colors.red.shade500).merge(superStyle);
      default:
        return TextStyle().merge(superStyle);
    }
  }

  List<Widget> _createWidget(md.Element element, int level, TextStyle superStyle) {
    var depth = level + 1;
    var res;
    List<Widget> children = [];
    // print("${"  " * depth}${element.tag}｜${element.children}|${element.attributes}|");
    var style = _createTextStyle(element, superStyle);
    element.children.forEach((childNode) {
      if (childNode is md.Text) {
        // children.add(Flexible(child: Text.rich(_createText(element, childNode, style))));
        children.add(Container(
          child: Text.rich(
            _createText(element, childNode, style),
            overflow: TextOverflow.visible,
          ),
        ));
      } else if (childNode is md.Element) {
        children.addAll(_createWidget(childNode, depth, style));
      }
    });
    switch (element.tag) {
      case 'h1':
      case 'h2':
      case 'p':
        res = Container(child: Wrap(children: children, spacing: 0.0));
        break;
      case 'li':
        res = Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        );
        break;
      case 'a':
        return children;
      case 'blockquote':
        res = Container(
          child: Column(children: children),
          color: Colors.pink.shade50,
        );
        break;
      case 'ol':
        res = Container(
          margin: EdgeInsets.only(left: (depth - 1) * 8.0),
          child: Column(
            children: children,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          color: Colors.black12,
        );
        break;
      case 'ul':
        res = Container(
          margin: EdgeInsets.only(left: (depth - 1) * 8.0),
          child: Column(
            children: children,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          color: Colors.blue.shade50,
        );
        break;
      default:
    }
    if (res != null) {
      return [res];
    } else {
      return [];
    }
  }

  static Future<String> readMarkdown(String filePath) async {
    String markdownContent = await rootBundle.loadString(filePath);
    return markdownContent;
  }

  static Future<void> parserMarkdown(String filePath, [MarkdownParser parser]) async {
    String markdownContent = await rootBundle.loadString(filePath);
    Future.delayed(Duration.zero, () async {
      List<String> lines = markdownContent.split('\n');
      md.Document document = md.Document(encodeHtml: false);
      for (md.Node node in document.parseLines(lines)) {
        node.accept(parser);
      }
    });
  }
}
