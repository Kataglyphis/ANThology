import 'package:flutter/material.dart';
import 'package:anthology/Layout/Widgets/Scrolling/render_cache_height.dart';

// Caches item heights (valid only for unchanging content) so the scrollbar thumb stays fixed once all items are seen.
class CacheHeight extends SingleChildRenderObjectWidget {
  const CacheHeight({
    super.key,
    super.child,
    required this.heights,
    required this.index,
  });

  final List<double?> heights;
  final int index;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCacheHeight(heights: heights, index: index);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderCacheHeight renderObject,
  ) {
    renderObject
      ..heights = heights
      ..index = index;
  }
}
