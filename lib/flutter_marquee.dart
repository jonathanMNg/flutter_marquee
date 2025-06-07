import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';

class FlutterMarquee extends StatefulWidget {
  const FlutterMarquee({
    super.key,
    required this.height,
    required this.text,
    this.style,
    this.startAfter = Duration.zero,
    this.pauseAfterRound = Duration.zero,
    this.velocity = 100,
  });

  final double height;
  final String text;
  final TextStyle? style;
  final Duration startAfter;
  final Duration pauseAfterRound;
  final double velocity;

  @override
  State<FlutterMarquee> createState() => _FlutterMarqueeState();
}

class _FlutterMarqueeState extends State<FlutterMarquee> {
  late final ScrollController _scrollController;
  late final double _textWidth;
  late Duration _totalDuration;
  Duration? _linearDuration;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _scrollReverse();
      } else if (_scrollController.position.pixels == 0) {
        _scroll();
      }
    });

    // Calculate text width synchronously
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textWidth = _getTextWidth(context);
      _initialize();
      Future.delayed(Duration(seconds: 1), () {
        _scroll();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  } 

  void _initialize() {
    final linearLength = _textWidth * 1;
    _totalDuration = Duration(
      milliseconds: (linearLength / widget.velocity * 1000).toInt(),
    );
    _linearDuration = _totalDuration;
  }

  Future<void> _scroll() async {
    Future.delayed(widget.startAfter, () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: _linearDuration!,
        curve: Curves.linear,
      );
    });
    await Future.delayed(widget.pauseAfterRound);
  }

  Future<void> _scrollReverse() async {
    Future.delayed(widget.startAfter, () {
      _scrollController.animateTo(
        0,
        duration: _linearDuration!,
        curve: Curves.linear,
      );
    });
    await Future.delayed(widget.pauseAfterRound);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Text(widget.text, style: widget.style),
        ),
      ),
    );
  }

  /// Returns the width of the text.
  double _getTextWidth(BuildContext context) {
    final span = TextSpan(text: widget.text, style: widget.style);

    final constraints = BoxConstraints(maxWidth: double.infinity);

    final richTextWidget = Text.rich(span).build(context) as RichText;
    final renderObject = richTextWidget.createRenderObject(context);
    renderObject.layout(constraints);

    final boxes = renderObject.getBoxesForSelection(
      TextSelection(
        baseOffset: 0,
        extentOffset: TextSpan(text: widget.text).toPlainText().length,
      ),
    );

    return boxes.last.right;
  }
}
