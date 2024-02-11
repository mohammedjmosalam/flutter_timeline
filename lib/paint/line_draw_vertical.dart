import 'package:flutter/rendering.dart';
import 'package:katro_timeline/data/enum/type_time_line.dart';
import 'package:katro_timeline/data/line_style.dart';

class LineDrawVertical extends CustomPainter {
  final LineStyle beforeLineStyle;
  final LineStyle afterLineStyle;
  final double radiusCircle;
  final bool isFirst;
  final bool isLast;
  final bool isEven;
  final TypeTimeLine timeLine;
  final double? width;
  final double? widthCircleAndText;

  LineDrawVertical({
    required this.afterLineStyle,
    required this.beforeLineStyle,
    required this.radiusCircle,
    required this.isFirst,
    required this.isLast,
    this.width,
    this.widthCircleAndText,
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
        Offset(radiusCircle, 0),
        Offset(radiusCircle, isFirst ? size.height : size.height / 2),
        paintLineBefore,
      );
      if (timeLine == TypeTimeLine.winding) {
        double widthLine = 400;
        if (width != null && widthCircleAndText != null) {
          widthLine = width! -
              widthCircleAndText! -
              (isEven ? radiusCircle : widthCircleAndText! - radiusCircle) +
              (isEven
                  ? beforeLineStyle.lineStokeWidth
                  : beforeLineStyle.lineStokeWidth / 2);
          widthLine =
              widthLine - radiusCircle * 3 - (isEven ? radiusCircle : 0);
        }
        double endOffset = size.height;
        canvas.drawLine(
            Offset(
                radiusCircle +
                    (isEven
                        ? -beforeLineStyle.lineStokeWidth / 2
                        : beforeLineStyle.lineStokeWidth / 2),
                endOffset + (radiusCircle >= endOffset ? radiusCircle : 0)),
            Offset(
                (isEven
                    ? widthLine +
                        radiusCircle -
                        beforeLineStyle.lineStokeWidth / 2
                    : -widthLine - 3 * radiusCircle),
                endOffset + (radiusCircle >= endOffset ? radiusCircle : 0)),
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
      canvas.drawLine(Offset(radiusCircle, isLast ? 0 : size.height / 2),
          Offset(radiusCircle, size.height), paintLineAfter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
