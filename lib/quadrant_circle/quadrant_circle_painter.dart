import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

enum QuadrantType { topRight, bottomRight, bottomLeft, topLeft }

class QuadrantCirclePainter extends CustomPainter {

  /// UI control variables
  static const double dataItemCircleSize = 48;
  static const double dataIconSize = 24;
  static const double centerCircleSize = 48;
  static const double centerCircleIconSize = 48;

  static const Color topRightQuadrantColor = Colors.red;
  static const Color bottomRightQuadrantColor = Colors.blue;
  static const Color bottomLeftQuadrantColor = Colors.green;
  static const Color topLeftQuadrantColor = Colors.yellow;

  static const Color centerCircleColor = Colors.black;
  static const Color centerCircleIconColor = Colors.white;

  static const Color dataItemsCircleColor = Colors.purple;
  static const Color dataItemIconColor = Colors.white;


  /// Angle variables
  final double left = math.pi;
  final double top = math.pi + math.pi / 2;
  final double right = 0.0;
  final double bottom = math.pi / 2;
  final double quarterAngle = math.pi / 2; // 1 quadrant = 90 degrees

  /// Data variable
  final Map<QuadrantType, List<IconData>> dataItems;

  QuadrantCirclePainter({
    @required this.dataItems,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = new Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    final double centerCircleDiameter = centerCircleSize;
    final double outerDiameter = size.width;
    final double outerRadius = outerDiameter / 2;

    final arcsRect = Rect.fromLTWH(0, 0, outerDiameter, outerDiameter);
    final useCenter = true;

    double rectSideInsideQuadrant = math.sqrt((outerRadius * outerRadius) / 2);

    /// DRAW QUADRANTS
    /// Top Right Quarter
    canvas.drawArc(arcsRect, top, quarterAngle, useCenter, paint..color = topRightQuadrantColor);
    /// Bottom Right Quarter
    canvas.drawArc(arcsRect, right, quarterAngle, useCenter, paint..color = bottomRightQuadrantColor);
    /// Bottom Left Quarter
    canvas.drawArc(arcsRect, bottom, quarterAngle, useCenter, paint..color = bottomLeftQuadrantColor);
    /// Top Left Quarter
    canvas.drawArc(arcsRect, left, quarterAngle, useCenter, paint..color = topLeftQuadrantColor);

    /// DRAW CENTER CIRCLE
    Offset circleOffset = Offset(size.width / 2, size.width / 2);
    canvas.drawCircle(circleOffset, centerCircleDiameter, paint..color = centerCircleColor);
    drawIcon(
      canvas,
      Icons.add,
      circleOffset,
      fromCenter: true,
      iconSize: centerCircleIconSize,
      iconColor: centerCircleIconColor,
    );

    /// DRAW ITEMS in all quadrant bounds
    for(QuadrantType quadrantType in QuadrantType.values){
      populateQuadrantItems(
        canvas,
        quadrantType,
        outerRadius,
        rectSideInsideQuadrant,
        centerCircleDiameter / 2,
      );
    }
  }

  /// Function to calculate the bounds of each quadrant that can be suitable to put icons inside
  Rect getQuadrantDrawableBounds(
    QuadrantType quadrantType,
    double quadrantRadius,
    double rectSizeOfQuadrantBound,
    double centerCircleRadius,
  ) {
    Offset offset = Offset(0, 0);
    switch (quadrantType) {
      case QuadrantType.topRight:
        offset = Offset(quadrantRadius + centerCircleRadius,
            quadrantRadius - rectSizeOfQuadrantBound);
        break;
      case QuadrantType.bottomRight:
        offset = Offset(quadrantRadius + centerCircleRadius + 8,
            quadrantRadius + centerCircleRadius + 8);
        break;
      case QuadrantType.bottomLeft:
        offset = Offset(quadrantRadius - rectSizeOfQuadrantBound,
            quadrantRadius + centerCircleRadius);
        break;
      case QuadrantType.topLeft:
      default:
        offset = Offset(quadrantRadius - rectSizeOfQuadrantBound,
            quadrantRadius - rectSizeOfQuadrantBound);
        break;
    }
    return Rect.fromLTWH(
      offset.dx,
      offset.dy,
      rectSizeOfQuadrantBound - centerCircleRadius,
      rectSizeOfQuadrantBound - centerCircleRadius,
    );
  }

  /// Add items inside for a quadrant within the respective quadrant bounds
  void populateQuadrantItems(
    Canvas canvas,
    QuadrantType quadrantType,
    double outerRadius,
    double rectSideInsideQuadrant,
    double centerCircleRadius,
  ) {
    Rect quadrantBounds = getQuadrantDrawableBounds(
      quadrantType,
      outerRadius,
      rectSideInsideQuadrant,
      centerCircleRadius,
    );
    addItemsToRect(canvas, quadrantBounds, dataItems[quadrantType], dataItemCircleSize);
  }

  /// Add data items inside the given bounds
  void addItemsToRect(
    Canvas canvas,
    Rect rect,
    List<IconData> items,
    double itemSize,
  ) {
    final Paint paint = new Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..color = dataItemsCircleColor
      ..style = PaintingStyle.fill;

    int fitHorizontal = (rect.width / itemSize).floor();
    int fitVertical = (rect.height / itemSize).floor();

    int totalFit = fitHorizontal * fitVertical;

    int rowNumber = 0;
    int colNumber = 0;
    for (int i = 0; i < math.min(totalFit, items.length); i++) {
      if (colNumber >= fitHorizontal) {
        colNumber = 0;
        rowNumber += 1;
      }
      var leftOffset = colNumber * itemSize;
      var topOffset = rowNumber * itemSize;
      Offset offset = Offset(rect.left + leftOffset, rect.top + topOffset);

      /// Draw icon background circles
      Rect itemRect = Rect.fromLTWH(offset.dx, offset.dy, itemSize, itemSize);
      canvas.drawOval(itemRect, paint);

      /// Draw icons inside circles
      double iconPushFactor = ((itemSize - dataIconSize) / 2);
      drawIcon(
        canvas,
        items[i],
        Offset(offset.dx + iconPushFactor, offset.dy + iconPushFactor),
        iconSize: dataIconSize,
        iconColor: dataItemIconColor,
      );

      colNumber++;
    }
  }

  /// Utility function to draw an icon at given position offset in circle
  void drawIcon(
    Canvas canvas,
    IconData iconData,
    Offset offset, {
    bool fromCenter = false,
    double iconSize = 40,
    Color iconColor = Colors.white,
  }) {
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(fontSize: iconSize,fontFamily: iconData.fontFamily, color: iconColor));
    textPainter.layout();
    if(fromCenter){
      offset = Offset(offset.dx - (iconSize/2), offset.dy - (iconSize/2));
    }
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
