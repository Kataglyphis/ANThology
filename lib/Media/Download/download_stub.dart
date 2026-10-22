import 'package:anthology/Media/Files/file_actions.dart';

Future<void> myPluginDownload(String url) => defaultFileActions.save(url);
