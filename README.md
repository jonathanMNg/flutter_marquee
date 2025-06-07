<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Flutter Marquee

A Flutter widget that creates a smooth scrolling marquee text effect, automatically handling text that exceeds screen width.

## Features

- Smooth scrolling text animation
- Automatic handling of text width vs screen width
- Customizable scroll speed
- Configurable start delay and pause duration
- Memory efficient (disposes scroll controller when not needed)
- Customizable text style

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_marquee: ^1.0.0
```

## Usage

```dart
import 'package:flutter_marquee/flutter_marquee.dart';

// Basic usage
FlutterMarquee(
  height: 50,
  text: 'This is a long text that will scroll horizontally',
)

// Advanced usage with all options
FlutterMarquee(
  height: 50,
  text: 'This is a long text that will scroll horizontally',
  style: TextStyle(
    fontSize: 20,
    color: Colors.blue,
  ),
  startAfter: Duration(seconds: 2),
  pauseAfterRound: Duration(seconds: 1),
  velocity: 100, // pixels per second
)
```

## Parameters

- `height` (required): The height of the marquee widget
- `text` (required): The text to display in the marquee
- `style`: TextStyle for the text (optional)
- `startAfter`: Duration to wait before starting the scroll (default: Duration.zero)
- `pauseAfterRound`: Duration to pause after each scroll round (default: Duration.zero)
- `velocity`: Scroll speed in pixels per second (default: 100)

## Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_marquee/flutter_marquee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Marquee Example'),
        ),
        body: Center(
          child: FlutterMarquee(
            height: 50,
            text: 'This is a very long text that will automatically scroll if it exceeds the screen width!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            startAfter: Duration(seconds: 2),
            pauseAfterRound: Duration(seconds: 1),
            velocity: 100,
          ),
        ),
      ),
    );
  }
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
