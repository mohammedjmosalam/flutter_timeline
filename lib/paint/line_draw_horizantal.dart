import 'package:flutter/rendering.dart';
import 'package:flutter_timeline/data/enum/type_time_line.dart';
import 'package:flutter_timeline/data/line_style.dart';

class LineDrawHorizontal extends CustomPainter {
  final LineStyle beforeLineStyle;
  final LineStyle afterLineStyle;
  final double radiusCircle;
  final bool isFirst;
  final bool isLast;
  final bool isEven;
  final TypeTimeLine timeLine;
  final double? hight;
  final double? hightCircleAndText;

  LineDrawHorizontal({
    required this.afterLineStyle,
    required this.beforeLineStyle,
    required this.radiusCircle,
    required this.isFirst,
    required this.isLast,
    this.hight,
    this.hightCircleAndText,
    required this.isEven,
    required this.timeLine,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // before Line
    if (!isLast) {
      Paint paintLineBefore = Paint()
        ..color = beforeLineStyle.lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = beforeLineStyle.lineStokeWidth;
      canvas.drawLine(
          Offset(0, radiusCircle),
          Offset(isFirst ? size.width : size.width / 2, radiusCircle),
          paintLineBefore);
      if (timeLine == TypeTimeLine.winding) {
        double hightLine = 200;

        if (hight != null && hightCircleAndText != null) {
          hightLine = hight! -
              hightCircleAndText! -
              (isEven ? radiusCircle : hightCircleAndText! - radiusCircle) +
              (isEven
                  ? beforeLineStyle.lineStokeWidth
                  : beforeLineStyle.lineStokeWidth / 2);
        }
        canvas.drawLine(
            Offset(
                size.width,
                radiusCircle +
                    (isEven
                        ? -beforeLineStyle.lineStokeWidth / 2
                        : beforeLineStyle.lineStokeWidth / 2)),
            Offset(size.width, isEven ? hightLine : -hightLine),
            Paint()
              ..color = afterLineStyle.lineColor
              ..style = PaintingStyle.stroke
              ..strokeWidth = afterLineStyle.lineStokeWidth);
      }
    }

    // after Line
    if (!isFirst) {
      Paint paintLineAfter = Paint()
        ..color = afterLineStyle.lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = afterLineStyle.lineStokeWidth;
      canvas.drawLine(Offset(isLast ? 0 : size.width / 2, radiusCircle),
          Offset(size.width, radiusCircle), paintLineAfter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
