import 'package:flutter/material.dart';

class MockAsyncLoader extends StatefulWidget {
  final WidgetBuilder loadingBuilder;
  final WidgetBuilder contentBuilder;
  final Widget Function(BuildContext context, VoidCallback onRetry)? errorBuilder;
  final Duration delay;
  final VoidCallback? onLoadStart;
  final VoidCallback? onLoaded;

  const MockAsyncLoader({
    super.key,
    required this.loadingBuilder,
    required this.contentBuilder,
    this.errorBuilder,
    this.delay = const Duration(milliseconds: 500),
    this.onLoadStart,
    this.onLoaded,
  });

  @override
  State<MockAsyncLoader> createState() => MockAsyncLoaderState();
}

class MockAsyncLoaderState extends State<MockAsyncLoader> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> reload() => _load();

  Future<void> _load() async {
    widget.onLoadStart?.call();
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }
    try {
      await Future.delayed(widget.delay);
      if (!mounted) return;
      setState(() => _isLoading = false);
      widget.onLoaded?.call();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return widget.loadingBuilder(context);
    if (_hasError) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, reload);
      }
      return const SizedBox.shrink();
    }
    return widget.contentBuilder(context);
  }
}
