# Changelog

## 1.0.0

* Initial release of Flutter Marquee
* Features:
  * Smooth scrolling text animation
  * Automatic handling of text width vs screen width
  * Customizable scroll speed
  * Configurable start delay and pause duration
  * Memory efficient (disposes scroll controller when not needed)
  * Customizable text style
* Parameters:
  * `height`: The height of the marquee widget
  * `text`: The text to display in the marquee
  * `style`: TextStyle for the text (optional)
  * `startAfter`: Duration to wait before starting the scroll (default: Duration.zero)
  * `pauseAfterRound`: Duration to pause after each scroll round (default: Duration.zero)
  * `velocity`: Scroll speed in pixels per second (default: 100)
