import 'package:material_ui/material_ui.dart';

// The known heights make `estimateMaxScrollOffset` exact instead of an average.
class BuildSlivers extends SliverChildBuilderDelegate {
  BuildSlivers({
    required NullableIndexedWidgetBuilder builder,
    required this.heights,
  }) : super(builder, childCount: heights.length);

  final List<double?> heights;

  @override
  double? estimateMaxScrollOffset(
    int firstIndex,
    int lastIndex,
    double leadingScrollOffset,
    double trailingScrollOffset,
  ) {
    return heights.fold<double?>(
      0.0,
      (sum, height) => (sum ?? 0) + (height ?? 0),
    );
  }
}
