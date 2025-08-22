import 'package:flutter/material.dart';

class PaginationController {
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool isLoadingMore;
  ScrollController? _scrollController;
  bool _isExternalController = false;

  PaginationController({
    required this.onLoadMore,
    required this.hasMore,
    required this.isLoadingMore,
    ScrollController? scrollController,
  }) {
    if (scrollController != null) {
      _scrollController = scrollController;
      _isExternalController = true;
    } else {
      _scrollController = ScrollController();
      _isExternalController = false;
    }

    _scrollController!.addListener(_onScroll);
  }

  void updateScrollController(ScrollController? newController) {
    if (_isExternalController) {
      _scrollController?.removeListener(_onScroll);
      _scrollController = newController;
      _scrollController?.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (_scrollController!.position.pixels >=
        _scrollController!.position.maxScrollExtent - 200) {
      if (hasMore && !isLoadingMore) {
        onLoadMore();
      }
    }
  }

  Widget buildPaginatedListWithColumn({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: itemCount,
            padding: EdgeInsets.zero,
            itemBuilder: itemBuilder,
          ),
        ),
        if (isLoadingMore)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  void dispose() {
    if (!_isExternalController) {
      _scrollController?.dispose();
    }
  }
}
