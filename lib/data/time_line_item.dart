import 'package:flutter/material.dart';
import 'package:katro_timeline/data/icon_and_image_style.dart';
import 'package:katro_timeline/data/line_style.dart';

class ItemLineItem {
  final LineStyle? afterLineStyle;
  final LineStyle? beforeLineStyle;
  final double radiusCircle;
  final bool isFirst;
  final bool isLast;
  final double? width;
  final String title;
  final Widget? endWidget;
  final Color circleColor;
  final double? height;
  final IconData? icon;
  final String? imageAssetsPath;
  final IconAndImageStyle iconAndImageStyle;
  ItemLineItem({
    this.afterLineStyle,
    this.beforeLineStyle,
    this.radiusCircle = 20,
    this.isFirst = false,
    this.isLast = false,
    this.width,
    this.height,
    this.endWidget,
    required this.title,
    this.circleColor = Colors.amber,
    this.icon,
    this.imageAssetsPath,
    this.iconAndImageStyle = const IconAndImageStyle(),
  });
}
