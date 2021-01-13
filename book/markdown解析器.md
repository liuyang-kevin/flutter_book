# 解析 MARKDOWN
```yaml
dependencies:
  markdown: ^3.0.0
```
flutter使用直接显示markdown，也是有专用的库的，这里关注的是自己解析问题
# Parsing
解析器结构上的几个概念:

* md.Document – Markdown文档上下文
* md.NodeVisitor – 定义一个接口，该接口将在解析期间识别抽象语法树（AST）的元素时被调用。LAST描述了Markdown文档的组件和结构。例如，Text是Markdown文档AST中的元素，当在解析文档时遇到Text时，将调用visitText方法。该界面遵循访客模式。
* md.Node – 基础AST节点, 是 md.Element 或者 md.Text.
* md.Element – 一个节点，包含一个或者更多个节点 【Element = [Element*n]】
* md.Text – 纯文本元素。

## 调用解析器demo
```dart
import 'package:markdown/markdown.dart' as md;

class MarkdownParser implement md.NodeVisitor {

  /// parse all lines as Markdown
  void parse( String markdownContent ) {
    List<String> lines = markdownContent.split('\n');
    md.Document document = md.Document(encodeHtml: false);
    for (md.Node node in document.parseLines(lines)) {
      node.accept(this);
    }
  }

  // NodeVisitor implementation
  @override
  void visitElementAfter(md.Element element) {
    print('vea: ${element.tag}');
  }

  @override
  bool visitElementBefore(md.Element element) {
    print('veb: ${element.tag}');
    return true;
  }

  @override
  void visitText(md.Text text) {
    print('vet: ${text.textContent}');
  }
}
```
## 解析对应的一些块元素
```dart
const _blockTags = [
  'blockquote',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'hr',
  'li',
  'ol',
  'p',
  'pre',
  'ul',
];
```
# Links
https://csdcorp.com/blog/coding/markdown-parsing-in-dart/