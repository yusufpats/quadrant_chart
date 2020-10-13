# QuadrantChart

[<img src="https://img.shields.io/badge/SO-StackOverflow-yellow">](https://stackoverflow.com/questions/64309400/how-can-i-create-a-divided-circle-into-4-sections-in-flutter/64337628#64337628)

A flutter application showing the usage of simple `CustomPaint` and `CustomPainter` to draw a quadrant chart with dynamically populated data (icons) inside each quadrant.

The `CustomPaint` widget gives you a canvas to draw any complex UI using elemental shapes like circles, arc, lines, path, etc

#### `CustomPaint` widget
```
CustomPaint(
   painter: ChartPainter(),
   child: Container(),
 )
```

#### `ChartPainter` class
```
class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
     // TODO: start painting shapes here
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
```

This project is part of the answer to the StackOverflow question [here](https://stackoverflow.com/questions/64309400/how-can-i-create-a-divided-circle-into-4-sections-in-flutter/64337628#64337628)


You can check the flutter documetation of `CustomPaint` widget [here](https://api.flutter.dev/flutter/widgets/CustomPaint-class.html)


### Screenshot

<img src="/screenshots/screenshot.png" width="360">
