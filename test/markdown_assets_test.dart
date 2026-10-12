// A tab or a fifth column of indent turns a line into a code block, which markdown_widget draws as a grey box: the privacy policy's titles were.
@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart' as m;

/// The first line of every code block whose `<code>` names no language, which only an indented block lacks.
List<String> _unlabelledCodeBlocks(String source) {
  final List<String> found = <String>[];
  void walk(List<m.Node>? nodes) {
    for (final m.Node node in nodes ?? const <m.Node>[]) {
      if (node is! m.Element) continue;
      if (node.tag == 'pre') {
        final m.Node? code = node.children?.firstOrNull;
        if (code is! m.Element || code.attributes['class'] == null) {
          found.add(node.textContent.trim().split('\n').first);
        }
      }
      walk(node.children);
    }
  }

  walk(
    m.Document(
      extensionSet: m.ExtensionSet.gitHubFlavored,
    ).parseLines(source.split('\n')),
  );
  return found;
}

void main() {
  final List<File> pages =
      Directory('assets/documents')
          .listSync(recursive: true)
          .whereType<File>()
          .where((File f) => f.path.endsWith('.md'))
          .toList()
        ..sort((File a, File b) => a.path.compareTo(b.path));

  test('the shipped pages are found', () {
    expect(pages.length, greaterThanOrEqualTo(12));
  });

  for (final File page in pages) {
    test('${page.path} has no accidental code block', () {
      expect(_unlabelledCodeBlocks(page.readAsStringSync()), isEmpty);
    });
  }
}
