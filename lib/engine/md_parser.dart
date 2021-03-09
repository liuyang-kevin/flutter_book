import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown/markdown.dart' as md;

///
/// http://jasonm23.github.io/markdown-css-themes/
/// https://github.com/jasonm23/markdown-css-themes/blob/gh-pages/markdown8.css
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

//<editor-fold desc="md 节点转换流程">
  /// 文本类型节点，转换文字内容到[TextSpan]
  TextSpan _createText(md.Element pElement, md.Text t, TextStyle superStyle, {List<String> superTags = const []}) {
    var style = _createTextStyle(pElement, superStyle, superTags: superTags);
    return TextSpan(
        text: t.textContent.replaceAll('\n', ' '),
        style: style,
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            //这里做点击事件
            print('MarkdownParser._createText ${pElement.attributes}');
          });
  }

  ///
  TextStyle _createTextStyle(md.Element element, TextStyle superStyle, {List<String> superTags = const []}) {
    //   font-family: "Helvetica Neue", Helvetica, "Hiragino Sans GB", Arial, sans-serif;
    switch (element.tag) {
      case 'h1':
        return TextStyle(
          fontSize: 30,
          height: 36 / 30,
          fontWeight: FontWeight.w900,
          color: Color(0xff404040),
          fontFamily: 'sans-serif',
        ).merge(superStyle);
      case 'h2':
        return TextStyle(fontSize: 24, height: 36 / 24, fontWeight: FontWeight.w900, color: Color(0xff404040))
            .merge(superStyle);
      case 'h3':
        return TextStyle(fontSize: 18, height: 36 / 18, fontWeight: FontWeight.w900, color: Color(0xff404040))
            .merge(superStyle);
      case 'h4':
        return TextStyle(fontSize: 16, height: 36 / 16, fontWeight: FontWeight.w900, color: Color(0xff404040))
            .merge(superStyle);
      case 'h5':
        return TextStyle(fontSize: 14, height: 36 / 14, fontWeight: FontWeight.w500, color: Color(0xff404040))
            .merge(superStyle);
      case 'h6':
        return TextStyle(
          fontSize: 13,
          height: 36 / 13,
          fontWeight: FontWeight.w500,
          color: Color(0xff404040),
          fontFamily: 'Hiragino Sans GB',
          textBaseline: TextBaseline.alphabetic,
        ).merge(superStyle);
      case 'a':
        return TextStyle(color: Colors.red.shade500).merge(superStyle);
      case 'p':
        return TextStyle(
          fontSize: 13,
          height: 18 / 13,
          color: Color(0xff737373),
          fontFamily: 'Helvetica Neue',
        ).merge(superStyle);
      case 'blockquote':
        return TextStyle(fontStyle: FontStyle.italic).merge(superStyle);
      case 'em':
        return TextStyle(fontStyle: FontStyle.italic).merge(superStyle);
      default:
        return TextStyle(fontSize: 14, color: Color(0xff737373)).merge(superStyle);
    }
  }

  /// md 文本节点专程Widget
  Widget _convertTextWidget(
    md.Element element,
    md.Text childNode,
    TextStyle style, {
    List<String> superTags = const [],
  }) {
    return Container(
      child: Text.rich(
        _createText(element, childNode, style, superTags: superTags),
        overflow: TextOverflow.visible,
        textAlign: TextAlign.left,
        // softWrap: false,
        softWrap: true,
      ),
    );
  }

  /// [md.Element] md元素节点转换成显示的Widget; level 是本层深度用于缩进
  List<Widget> _convertElementWidget(md.Element element, List<Widget> children, int level) {
    var res;
    // 封包本层元素到不同样式widget
    switch (element.tag) {
      case 'h1':
        res = Container(margin: EdgeInsets.only(bottom: 18), child: Wrap(children: children, spacing: 0.0));
        break;
      case 'h2':
        res = Container(margin: EdgeInsets.only(bottom: 12), child: Wrap(children: children, spacing: 0.0));
        break;
      case 'h3':
        res = Container(margin: EdgeInsets.only(bottom: 6), child: Wrap(children: children, spacing: 0.0));
        break;
      case 'h4':
        res = Container(margin: EdgeInsets.only(bottom: 4), child: Wrap(children: children, spacing: 0.0));
        break;
      case 'h5':
        res = Container(margin: EdgeInsets.only(bottom: 2), child: Wrap(children: children, spacing: 0.0));
        break;
      case 'h6':
        res = Container(margin: EdgeInsets.only(bottom: 1), child: Wrap(children: children, spacing: 0.0));
        break;
      case 'p':
        res = Container(
            margin: EdgeInsets.only(bottom: 9),
            child: Wrap(
              children: children,
              spacing: .0,
            ));
        break;
      case 'blockquote':
        res = Container(
          padding: EdgeInsets.fromLTRB(13, 13, 21, 15),
          margin: EdgeInsets.only(bottom: 18),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  transform: Matrix4.translationValues(-10.0, -6.0, 0.0),
                  alignment: AlignmentDirectional.topStart,
                  height: 20,
                  child: Text(
                    '\u201C',
                    style: TextStyle(color: Color(0xffeeeeee), fontSize: 40, fontFamily: 'georgia'),
                  ),
                ),
                ...children
              ]),
        );
        break;
      case 'li':
        res = Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ));
        break;
      case 'a':
        return children;
      case 'ol':
        res = Container(
          margin: EdgeInsets.only(left: level * 8.0),
          padding: EdgeInsets.all(4),
          child: Column(
            children: children
                .map(
                  (e) => Container(
                    padding: EdgeInsets.all(4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('${children.indexOf(e) + 1}. '), Expanded(child: e)],
                    ),
                  ),
                )
                .toList(),
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          color: Colors.black12,
        );
        break;
      case 'ul':
        res = Container(
          margin: EdgeInsets.only(left: level * 8.0),
          padding: EdgeInsets.all(4),
          child: Column(
            children: children
                .map(
                  (e) => Container(
                    padding: EdgeInsets.all(4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('• '), Expanded(child: e)],
                    ),
                  ),
                )
                .toList(),
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          // color: Colors.indigo.shade50,
        );
        break;
      case 'hr':
        res = Container(
          margin: EdgeInsets.only(top: 19.0, bottom: 19.0),
          color: Color(0xffcccccc),
          height: 1.0,
        );
        break;
      case 'table':
        res = _MTable(children);
        break;
      case 'tr':
        return [Row(children: children)];
      case 'thead':
        return [_MTHead(children: children)];
      case 'th':
        res = Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10), child: Wrap(children: children, spacing: 0.0));
        break;
      case 'tbody':
        return [_MTBody(children: children)];
      case 'td':
        res = Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10), child: Wrap(children: children, spacing: 0.0));
        break;
      case 'em':
        res = Container(child: Wrap(children: children, spacing: 0.0));
        break;
      default:
    }
    if (res != null) {
      return [res];
    } else {
      return [];
    }
  }

  /// 递归整个元素[md.Element]节点, level 为当前深度，父节点字体样式superStyle
  ///
  /// superTag 标记元素链
  List<Widget> _createWidget(md.Element element, int level, TextStyle superStyle, {List<String> superTags}) {
    print(
        'MarkdownParser._createWidget $level ${superTags} ${element.tag} ${element.textContent.replaceAll('\n', '\\n')} ');
    var depth = level + 1;
    var children = <Widget>[];
    var style = _createTextStyle(element, superStyle); // 根据父节点，创建本层节点字体样式
    // print(element);
    // print(element.children);
    // print(element.attributes);
    // print(element.textContent);
    // print(element.tag);
    // if (element.children == null) {
    //   return [];
    // }

    // 递归子元素：文本类型封包/元素类型递归
    element.children?.forEach((childNode) {
      if (childNode is md.Text) {
        // 文本类型封包
        children.add(_convertTextWidget(element, childNode, style, superTags: (superTags ?? [])..add(element.tag)));
      } else if (childNode is md.Element) {
        // 元素类型递归
        children.addAll(_createWidget(childNode, depth, style, superTags: (superTags ?? [])..add(element.tag)));
      }
      superTags?.removeLast();
    });
    return _convertElementWidget(element, children, level);
  }

//</editor-fold>

//<editor-fold desc="解析md文件">
  static Future<String> readMarkdown(String filePath) async {
    var markdownContent = await rootBundle.loadString(filePath);
    return markdownContent;
  }

  static Future<void> parserMarkdown(String filePath, [MarkdownParser parser]) async {
    var markdownContent = await rootBundle.loadString(filePath);
    Future.delayed(Duration.zero, () async {
      var lines = markdownContent.split('\n');
      var document = md.Document(encodeHtml: false, extensionSet: md.ExtensionSet.gitHubFlavored);
      for (var node in document.parseLines(lines)) {
        node.accept(parser);
      }
    });
  }
//</editor-fold>
}

abstract class MarkdownElementCreator {
  List<Widget> createWidget();
}

class _MTable extends StatelessWidget {
  final List<Widget> children;

  _MTable(this.children);

  @override
  Widget build(BuildContext context) {
    var thead = children[0] as _MTHead;
    var tbody = children[1] as _MTBody;

    var trHead = thead.children
        .map(
          (e) => TableRow(
            decoration: BoxDecoration(color: Colors.grey[200]),
            children: (e as Row).children,
          ),
        )
        .toList();
    var trBody = tbody.children.map((e) => TableRow(children: (e as Row).children)).toList();
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
      child: Table(
        border: TableBorder.all(color: Color(0xffdddddd), width: 1.0, style: BorderStyle.solid),
        children: [...trHead, ...trBody],
      ),
    );
  }
}

class _MTHead extends StatelessWidget {
  final List<Widget> children;

  _MTHead({Key key, this.children}) : super(key: key) {}

  @override
  Widget build(BuildContext context) => Container();
}

class _MTBody extends StatelessWidget {
  final List<Widget> children;

  _MTBody({Key key, this.children}) : super(key: key) {}

  @override
  Widget build(BuildContext context) => Container();
}

class AAA {
  vvvv() {
    return Container(
      width: 186.0,
      height: 44.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.0),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment(1.03, 0.16),
          colors: [
            const Color(0xFF6294A2),
            const Color(0xFF58C3DD),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.11),
            offset: Offset(0, 3.0),
            blurRadius: 10.0,
          ),
        ],
      ),
    );
  }
}
