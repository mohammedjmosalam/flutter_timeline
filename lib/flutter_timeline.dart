import 'package:flutter/material.dart';
import 'package:katro_timeline/data/icon_and_image_style.dart';
import 'package:katro_timeline/data/line_style.dart';
import 'package:katro_timeline/paint/line_draw_horizantal.dart';
import 'package:katro_timeline/paint/line_draw_vertical.dart';

import 'data/enum/type_time_line.dart';
import 'data/time_line_item.dart';

class FlutterTimeLine extends StatefulWidget {
  const FlutterTimeLine({
    super.key,
    required this.itemsTimeLine,
    this.height,
    this.width,
    this.direction = Axis.horizontal,
    this.typeTimeLine = TypeTimeLine.liner,
  });
  final List<ItemLineItem> itemsTimeLine;
  final TypeTimeLine typeTimeLine;
  final double? width;
  final double? height;
  final Axis direction;

  @override
  State<FlutterTimeLine> createState() => _FlutterTimeLineState();
}

class _FlutterTimeLineState extends State<FlutterTimeLine> {
  List<Size> itemsSize = [];
  Size? sizeItem;
  ScrollController scrollController = ScrollController();
  bool setSizeDone = false;
  @override
  void initState() {
    print(widget.direction);
    scrollController.addListener(() {
      print(
          'scrollController.position.maxScrollExtent : ${scrollController.position.maxScrollExtent}');
    });
    super.initState();
  }

  void addSize(Size size) {
    itemsSize.add(size);
    if (itemsSize.length == widget.itemsTimeLine.length && !setSizeDone) {
      setSizeDone = true;
      itemsSize.sort(
        (a, b) => widget.direction == Axis.horizontal
            ? a.height.compareTo(b.height)
            : a.width.compareTo(b.width),
      );
      setState(() {
        sizeItem = itemsSize.last;
        sizeItem = Size(sizeItem!.width + 40, sizeItem!.height + 40);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: widget.direction,
          controller: scrollController,
          child: widget.direction == Axis.horizontal
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.itemsTimeLine.map(
                    (item) {
                      return _TimeLineItemHorizontal(
                        circleColor: item.circleColor,
                        isFirst: item.isFirst,
                        isLast: item.isLast,
                        typeTimeLine: widget.typeTimeLine,
                        isEven: widget.itemsTimeLine.indexOf(item) % 2 == 0,
                        radiusCircle: item.radiusCircle,
                        width: item.width,
                        height: item.height ?? sizeItem?.height,
                        afterLineStyle: item.afterLineStyle,
                        beforeLineStyle: item.beforeLineStyle,
                        endWidget: item.endWidget,
                        iconAndImageStyle: item.iconAndImageStyle,
                        icon: item.icon,
                        imageAssetsPath: item.imageAssetsPath,
                        startWidget: SizedBox(
                          width: 100,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item.title),
                            ),
                          ),
                        ),
                        itemSizeChange: addSize,
                      );
                    },
                  ).toList(),
                )
              : Column(
                  children: widget.itemsTimeLine.map(
                    (item) {
                      return _TimeLineItemVertical(
                        circleColor: item.circleColor,
                        isFirst: item.isFirst,
                        isLast: item.isLast,
                        isEven: widget.itemsTimeLine.indexOf(item) % 2 == 0,
                        itemSizeChange: addSize,
                        typeTimeLine: widget.typeTimeLine,
                        radiusCircle: item.radiusCircle,
                        width: item.width ?? sizeItem?.width,
                        height: item.height,
                        afterLineStyle: item.afterLineStyle,
                        beforeLineStyle: item.beforeLineStyle,
                        iconAndImageStyle: item.iconAndImageStyle,
                        icon: item.icon,
                        imageAssetsPath: item.imageAssetsPath,
                        endWidget: item.endWidget,
                        startWidget: SizedBox(
                            width: 100,
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item.title),
                            ))),
                      );
                    },
                  ).toList(),
                ),
        ),
      ),
    );
  }
}

class _TimeLineItemHorizontal extends StatefulWidget {
  const _TimeLineItemHorizontal({
    this.width,
    this.height,
    required this.radiusCircle,
    required this.isFirst,
    required this.isLast,
    required this.circleColor,
    required this.typeTimeLine,
    this.startWidget,
    this.endWidget,
    this.afterLineStyle,
    this.beforeLineStyle,
    required this.isEven,
    required this.itemSizeChange,
    this.icon,
    this.imageAssetsPath,
    required this.iconAndImageStyle,
  });
  final double? width;
  final Widget? startWidget;
  final Widget? endWidget;
  final LineStyle? afterLineStyle;
  final LineStyle? beforeLineStyle;
  final double radiusCircle;
  final bool isFirst;
  final bool isEven;
  final bool isLast;
  final Color circleColor;
  final double? height;
  final TypeTimeLine typeTimeLine;
  final ValueChanged<Size> itemSizeChange;
  final IconData? icon;
  final String? imageAssetsPath;
  final IconAndImageStyle iconAndImageStyle;

  @override
  State<_TimeLineItemHorizontal> createState() =>
      _TimeLineItemHorizontalState();
}

class _TimeLineItemHorizontalState extends State<_TimeLineItemHorizontal> {
  GlobalKey key = GlobalKey();
  GlobalKey circleAndFirstTextHightKey = GlobalKey();
  double? width;
  double? hightCircleAndText;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderObject renderBox = key.currentContext!.findRenderObject()!;
      widget.itemSizeChange(renderBox.paintBounds.size);
      if (widget.width == null && width == null) {
        setState(() {
          width = renderBox.paintBounds.size.width;
        });
      }
      if (hightCircleAndText == null) {
        RenderBox renderBox = circleAndFirstTextHightKey.currentContext!
            .findRenderObject() as RenderBox;
        setState(() {
          hightCircleAndText = renderBox.size.height;
        });
      }
    });
    List<Widget> firstWidget = [
      widget.startWidget ?? const SizedBox(),
    ];

    if (!widget.isEven && widget.typeTimeLine == TypeTimeLine.winding) {
      firstWidget.insert(
        0,
        CustomPaint(
          painter: LineDrawHorizontal(
            afterLineStyle: widget.afterLineStyle ?? LineStyle(),
            beforeLineStyle: widget.beforeLineStyle ?? LineStyle(),
            radiusCircle: widget.radiusCircle,
            isFirst: widget.isFirst,
            isLast: widget.isLast,
            hight: widget.height,
            isEven: widget.isEven,
            timeLine: widget.typeTimeLine,
            hightCircleAndText: hightCircleAndText,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: widget.isFirst
                ? MainAxisAlignment.start
                : widget.isLast
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: widget.circleColor,
                radius: widget.radiusCircle,
                backgroundImage: widget.imageAssetsPath != null
                    ? AssetImage(
                        widget.imageAssetsPath!,
                      )
                    : null,
                child: widget.icon != null
                    ? Icon(
                        widget.icon,
                        color: widget.iconAndImageStyle.color,
                        size: widget.iconAndImageStyle.size,
                      )
                    : null,
              ),
            ],
          ),
        ),
      );
    } else {
      firstWidget.add(
        CustomPaint(
          painter: LineDrawHorizontal(
            afterLineStyle: widget.afterLineStyle ?? LineStyle(),
            beforeLineStyle: widget.beforeLineStyle ?? LineStyle(),
            radiusCircle: widget.radiusCircle,
            isFirst: widget.isFirst,
            isLast: widget.isLast,
            hight: widget.height,
            isEven: widget.isEven,
            timeLine: widget.typeTimeLine,
            hightCircleAndText: hightCircleAndText,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: widget.isFirst
                ? MainAxisAlignment.start
                : widget.isLast
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: widget.circleColor,
                radius: widget.radiusCircle,
                backgroundImage: widget.imageAssetsPath != null
                    ? AssetImage(
                        widget.imageAssetsPath!,
                      )
                    : null,
                child: widget.icon != null
                    ? Icon(
                        widget.icon,
                        color: widget.iconAndImageStyle.color,
                        size: widget.iconAndImageStyle.size,
                      )
                    : null,
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      width: widget.width ?? width,
      height: widget.height,
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            (!widget.isEven && widget.typeTimeLine == TypeTimeLine.winding)
                ? [
                    if (widget.height != null)
                      Expanded(
                        child: Center(
                          child: widget.endWidget ?? const SizedBox(),
                        ),
                      )
                    else
                      widget.endWidget ?? const SizedBox(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      key: circleAndFirstTextHightKey,
                      children: firstWidget,
                    ),
                  ]
                : [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      key: circleAndFirstTextHightKey,
                      children: firstWidget,
                    ),
                    if (widget.height != null)
                      Expanded(
                        child: Center(
                          child: widget.endWidget ?? const SizedBox(),
                        ),
                      )
                    else
                      widget.endWidget ?? const SizedBox(),
                  ],
      ),
    );
  }
}

class _TimeLineItemVertical extends StatefulWidget {
  const _TimeLineItemVertical({
    this.width,
    this.height,
    required this.radiusCircle,
    required this.isFirst,
    required this.isLast,
    required this.circleColor,
    this.startWidget,
    this.endWidget,
    this.afterLineStyle,
    this.beforeLineStyle,
    required this.isEven,
    required this.itemSizeChange,
    required this.typeTimeLine,
    this.icon,
    this.imageAssetsPath,
    required this.iconAndImageStyle,
  });
  final double? width;
  final double? height;
  final Widget? startWidget;
  final Widget? endWidget;
  final LineStyle? afterLineStyle;
  final LineStyle? beforeLineStyle;
  final double radiusCircle;
  final bool isFirst;
  final bool isLast;
  final Color circleColor;
  final ValueChanged<Size> itemSizeChange;
  final TypeTimeLine typeTimeLine;
  final bool isEven;
  final IconData? icon;
  final String? imageAssetsPath;
  final IconAndImageStyle iconAndImageStyle;

  @override
  State<_TimeLineItemVertical> createState() => _TimeLineItemVerticalState();
}

class _TimeLineItemVerticalState extends State<_TimeLineItemVertical> {
  GlobalKey key = GlobalKey();
  GlobalKey circleAndFirstTextWidthKey = GlobalKey();

  double? height;
  double? widthCircleAndText;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
      widget.itemSizeChange(renderBox.size);
      if (widget.height == null && height == null) {
        setState(() {
          height = renderBox.size.height;
        });
      }
      if (widthCircleAndText == null) {
        RenderBox renderBox = circleAndFirstTextWidthKey.currentContext!
            .findRenderObject() as RenderBox;
        setState(() {
          widthCircleAndText = renderBox.size.width;
        });
      }
    });
    List<Widget> firstWidget = [
      widget.startWidget ?? const SizedBox(),
    ];
    if (!widget.isEven && widget.typeTimeLine == TypeTimeLine.winding) {
      firstWidget.insert(
        0,
        CustomPaint(
          painter: LineDrawVertical(
            afterLineStyle: widget.afterLineStyle ?? LineStyle(),
            beforeLineStyle: widget.beforeLineStyle ?? LineStyle(),
            radiusCircle: widget.radiusCircle,
            isFirst: widget.isFirst,
            isLast: widget.isLast,
            width: widget.width,
            isEven: widget.isEven,
            timeLine: widget.typeTimeLine,
            widthCircleAndText: widthCircleAndText,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: widget.isFirst
                ? MainAxisAlignment.start
                : widget.isLast
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: widget.circleColor,
                radius: widget.radiusCircle,
                backgroundImage: widget.imageAssetsPath != null
                    ? AssetImage(
                        widget.imageAssetsPath!,
                      )
                    : null,
                child: widget.icon != null
                    ? Icon(
                        widget.icon,
                        color: widget.iconAndImageStyle.color,
                        size: widget.iconAndImageStyle.size,
                      )
                    : null,
              ),
            ],
          ),
        ),
      );
    } else {
      firstWidget.add(
        CustomPaint(
          painter: LineDrawVertical(
            afterLineStyle: widget.afterLineStyle ?? LineStyle(),
            beforeLineStyle: widget.beforeLineStyle ?? LineStyle(),
            radiusCircle: widget.radiusCircle,
            isFirst: widget.isFirst,
            isLast: widget.isLast,
            width: widget.width,
            isEven: widget.isEven,
            timeLine: widget.typeTimeLine,
            widthCircleAndText: widthCircleAndText,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: widget.isFirst
                ? MainAxisAlignment.start
                : widget.isLast
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: widget.circleColor,
                radius: widget.radiusCircle,
                backgroundImage: widget.imageAssetsPath != null
                    ? AssetImage(
                        widget.imageAssetsPath!,
                      )
                    : null,
                child: widget.icon != null
                    ? Icon(
                        widget.icon,
                        color: widget.iconAndImageStyle.color,
                        size: widget.iconAndImageStyle.size,
                      )
                    : null,
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      width: widget.width,
      height: widget.height ?? height,
      key: key,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:
            (!widget.isEven && widget.typeTimeLine == TypeTimeLine.winding)
                ? [
                    if (widget.width != null)
                      Expanded(
                        child: Center(
                          child: widget.endWidget ?? const SizedBox(),
                        ),
                      )
                    else
                      widget.endWidget ?? const SizedBox(),
                    Row(
                      key: circleAndFirstTextWidthKey,
                      children: firstWidget,
                    ),
                  ]
                : [
                    Row(
                      key: circleAndFirstTextWidthKey,
                      children: firstWidget,
                    ),
                    if (widget.width != null)
                      Expanded(
                        child: Center(
                          child: widget.endWidget ?? const SizedBox(),
                        ),
                      )
                    else
                      widget.endWidget ?? const SizedBox(),
                  ],
      ),
    );
  }
}
