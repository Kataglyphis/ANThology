import 'package:anthology/Media/DataTable/table_data.dart';

/// A single blog/data entry (title, date, comment) in the overview table.
class BlockEntry extends TableData {
  /// Creates a block entry with the required fields.
  BlockEntry({required this.title, required this.date, required this.comment});

  /// The title of the entry.
  final String title;

  /// The date associated with the entry.
  final String date;

  /// Additional comment or description.
  final String comment;

  @override
  List<String> getCells() => [title, date, comment];
}
