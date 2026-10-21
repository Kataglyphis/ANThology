import 'package:anthology/Media/Markdown/markdown_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Set<String> assets = <String>{
    'packages/anthology/assets/images/aiBlog/Worley.png',
    'packages/anthology/assets/images/aiBlog/Coffee.png',
    'assets/documents/books/cover.png',
  };
  String? resolve(
    String src, {
    String dir = 'packages/anthology/assets/images/aiBlog',
  }) => resolveMarkdownImage(
    src,
    markdownPath: 'packages/anthology/assets/documents/blog/post.md',
    imageDirectory: dir,
    assets: assets,
  );

  group('resolveMarkdownImage', () {
    test('a path relative to the Markdown file', () {
      expect(
        resolve('../../images/aiBlog/Worley.png'),
        'packages/anthology/assets/images/aiBlog/Worley.png',
      );
    });

    test(
      'a bare name under the image directory, with or without its slash',
      () {
        expect(
          resolve('Coffee.png'),
          'packages/anthology/assets/images/aiBlog/Coffee.png',
        );
        expect(
          resolve(
            'Coffee.png',
            dir: 'packages/anthology/assets/images/aiBlog/',
          ),
          'packages/anthology/assets/images/aiBlog/Coffee.png',
        );
      },
    );

    test('an asset key as written', () {
      expect(
        resolve('assets/documents/books/cover.png'),
        'assets/documents/books/cover.png',
      );
    });

    test('nothing for an image the bundle lacks, a URL or a data URI', () {
      expect(resolve('Missing.png'), isNull);
      expect(resolve('https://example.org/Worley.png'), isNull);
      expect(resolve('data:image/png;base64,AAAA'), isNull);
    });
  });

  group('withResolvedImages', () {
    String? upper(String src) => src == 'a.png' ? 'A.png' : null;

    test('rewrites each resolved image, keeps the alt text and the title', () {
      expect(
        withResolvedImages('![x](a.png "t") and ![y](b.png)', upper),
        '![x](A.png "t") and ![y](b.png)',
      );
    });

    test('leaves links and fenced code as written', () {
      const String fenced = '```md\n![x](a.png)\n```';
      expect(
        withResolvedImages('[x](a.png)\n$fenced\n![x](a.png)', upper),
        '[x](a.png)\n$fenced\n![x](A.png)',
      );
    });
  });
}
