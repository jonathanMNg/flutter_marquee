import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';

/// A Flutter widget that creates a smooth scrolling marquee text effect.
///
/// This widget automatically handles text that exceeds screen width by creating
/// a smooth scrolling animation. If the text fits within the screen width,
/// no scrolling animation will be performed.
class FlutterMarquee extends StatefulWidget {
  /// Creates a marquee widget.
  ///
  /// The [height] and [text] parameters must not be null.
  const FlutterMarquee({
    super.key,
    required this.height,
    required this.text,
    this.style,
    this.startAfter = Duration.zero,
    this.pauseAfterRound = Duration.zero,
    this.velocity = 100,
  })  : assert(
          startAfter >= Duration.zero,
          'startAfter must be greater than or equal to Duration.zero',
        ),
        assert(
          pauseAfterRound >= Duration.zero,
          'pauseAfterRound must be greater than or equal to Duration.zero',
        ),
        assert(velocity > 0, "The velocity cannot be less than zero");

  /// The height of the marquee widget.
  ///
  /// This determines the vertical space the marquee will occupy.
  final double height;

  /// The text to display in the marquee.
  ///
  /// This text will be scrolled horizontally if it exceeds the screen width.
  final String text;

  /// The text style to apply to the marquee text.
  ///
  /// If null, the default text style will be used.
  final TextStyle? style;

  /// The duration to wait before starting the scroll animation.
  ///
  /// Defaults to [Duration.zero], meaning the animation starts immediately.
  final Duration startAfter;

  /// The duration to pause after each complete scroll round.
  ///
  /// Defaults to [Duration.zero], meaning no pause between scroll rounds.
  final Duration pauseAfterRound;

  /// The scroll speed in pixels per second.
  ///
  /// Defaults to 100 pixels per second.
  final double velocity;

  @override
  State<FlutterMarquee> createState() => _FlutterMarqueeState();
}

class _FlutterMarqueeState extends State<FlutterMarquee> {
  /// Controller for managing the scroll position and animation.
  late final ScrollController _scrollController;

  /// The calculated width of the text content.
  late final double _textWidth;

  /// The total duration for one complete scroll cycle.
  late Duration _totalDuration;

  /// The duration for the linear scrolling animation.
  Duration? _linearDuration;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Calculate text width synchronously
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textWidth = _getTextWidth(context);
      final screenWidth = MediaQuery.of(context).size.width;

      if (_textWidth > screenWidth) {
        _scrollController.addListener(() {
          if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
            _scrollReverse();
          } else if (_scrollController.position.pixels == 0) {
            _scroll();
          }
        });

        _initialize();
        Future.delayed(Duration(seconds: 1), () {
          _scroll();
        });
      } else {
        _scrollController.dispose();
      }
    });
  }

  @override
  void dispose() {
    if (_scrollController.hasClients) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  /// Initializes the scroll duration based on text width and velocity.
  void _initialize() {
    final linearLength = _textWidth * 1;
    _totalDuration =
        Duration(milliseconds: (linearLength / widget.velocity * 1000).toInt());
    _linearDuration = _totalDuration;
  }

  /// Scrolls the text from left to right.
  ///
  /// This method is called when the text needs to scroll forward.
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

  /// Scrolls the text from right to left.
  ///
  /// This method is called when the text needs to scroll backward.
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

  /// Calculates the width of the text content.
  ///
  /// Returns the width in pixels that the text will occupy.
  double _getTextWidth(BuildContext context) {
    final span = TextSpan(text: widget.text, style: widget.style);

    const constraints = BoxConstraints(maxWidth: double.infinity);

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
