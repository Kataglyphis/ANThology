import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:anthology/Media/Files/file_actions_contract.dart';

FileActions createFileActions() => NativeFileActions();

/// Extracts bundled bytes before handing the file to the operating system.
class NativeFileActions implements FileActions {
  NativeFileActions({
    AssetBundle? bundle,
    Future<Directory> Function()? temporaryDirectory,
    Future<void> Function(File)? openFile,
    Future<void> Function(Uint8List, String, String)? saveFile,
  }) : _bundle = bundle ?? rootBundle,
       _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory,
       _openFile = openFile ?? _openWithSystem,
       _saveFile = saveFile ?? _saveWithSystem;

  final AssetBundle _bundle;
  final Future<Directory> Function() _temporaryDirectory;
  final Future<void> Function(File) _openFile;
  final Future<void> Function(Uint8List, String, String) _saveFile;

  Future<Uint8List> _bytes(String asset) async {
    final data = await _bundle.load(asset);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  @override
  Future<void> open(String asset) async {
    if (asset.startsWith('/') ||
        asset.contains('\\') ||
        asset.split('/').any((part) => part == '..' || part.isEmpty)) {
      throw ArgumentError.value(asset, 'asset', 'Expected a bundle asset key');
    }
    final directory = await _temporaryDirectory();
    final file = File('${directory.path}/anthology/$asset');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(await _bytes(asset), flush: true);
    await _openFile(file);
  }

  static Future<void> _openWithSystem(File file) async {
    if (Platform.isAndroid || Platform.isIOS) {
      final result = await OpenFilex.open(
        file.path,
        type: lookupMimeType(file.path),
      );
      if (result.type != ResultType.done) throw StateError(result.message);
    } else if (!await launchUrl(
      file.uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw StateError('No application opened ${file.path}');
    }
  }

  @override
  Future<void> save(String asset) async {
    final filename = asset.split('/').last;
    await _saveFile(
      await _bytes(asset),
      filename,
      lookupMimeType(asset) ?? 'application/octet-stream',
    );
  }

  static Future<void> _saveWithSystem(
    Uint8List bytes,
    String filename,
    String mime,
  ) async {
    await FileSaver.instance.saveAs(
      name: filename,
      bytes: bytes,
      includeExtension: false,
      mimeType: MimeType.custom,
      customMimeType: mime,
    );
  }
}
