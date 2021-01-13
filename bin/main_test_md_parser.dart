import 'package:book_demos/engine/md_parser.dart';
import 'package:markdown/markdown.dart' as md;

main(List<String> args) {
  // MarkdownParser p = MarkdownParser();
  // parse(p, """
  // #markdownContent
  // * adsfas
  // * bbbbb
  // > sakjfdklajsdlkf
  // 1. sadfas
  // 2. dfsdf
  // """);
}

void parse(md.NodeVisitor v, String markdownContent) {
  List<String> lines = markdownContent.split('\n');
  md.Document document = md.Document(encodeHtml: false);
  for (md.Node node in document.parseLines(lines)) {
    node.accept(v);
  }
}
