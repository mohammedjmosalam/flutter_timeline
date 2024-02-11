import 'dart:math';

import 'package:flutter/material.dart';
import 'package:katro_timeline/data/enum/type_time_line.dart';
import 'package:katro_timeline/data/icon_and_image_style.dart';
import 'package:katro_timeline/data/line_style.dart';
import 'package:katro_timeline/data/time_line_item.dart';
import 'package:katro_timeline/flutter_timeline.dart';
import 'package:line_icons/line_icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter TimeLine'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey keyContainer = GlobalKey();
  @override
  Widget build(BuildContext context) {
    List<Color> colorNode = [
      const Color(0xff1052b5),
      const Color(0xffb81a22),
      const Color(0xff4c81b0),
      const Color(0xffcf235c),
      const Color(0xffedd207),
    ];
    double storkLineWidth = 5;
    List<String> title = [
      '2004',
      '2005',
      '2006',
      '2010',
      '2011',
    ];
    List<String> description = [
      " Facebook \n Originally designed for college students, it quickly grew into the world's largest social networking platform, connecting billions of users globally.",
      " YouTube \n Revolutionized the way people consume and share video content online, becoming the leading platform for video sharing and streaming.",
      " Twitter \n Introduced the concept of microblogging, enabling users to share short updates and follow others in real-time.",
      " Instagram \n Focused on photo and video sharing, it quickly gained popularity for its visual-centric approach to social networking.",
      " Snapchat \n Pioneered ephemeral messaging, allowing users to send photos and videos that disappear after being viewed.",
    ];
    List<IconData> icons = [
      LineIcons.facebook,
      LineIcons.youtube,
      LineIcons.twitter,
      LineIcons.instagram,
      LineIcons.snapchat,
    ];

    return Scaffold(
      backgroundColor: const Color(0xffcad6e8),
      appBar: AppBar(
        backgroundColor: const Color(0xff4c81b0),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlutterTimeLine(
            direction: Axis.vertical,
            typeTimeLine: TypeTimeLine.winding,
            height: 500,
            itemsTimeLine: title
                .map(
                  (e) => ItemLineItem(
                    title: e,
                    endWidget: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(description.elementAt(title.indexOf(e))),
                    ),
                    height: 80,
                    isFirst: title.indexOf(e) == 0,
                    isLast: title.indexOf(e) == title.length - 1,
                    icon: icons.elementAt(title.indexOf(e)),
                    iconAndImageStyle: const IconAndImageStyle(
                      color: Colors.white,
                      size: 28,
                    ),
                    afterLineStyle: LineStyle(
                      lineColor: colorNode.elementAt(title.indexOf(e)),
                      lineStokeWidth: storkLineWidth,
                    ),
                    circleColor: colorNode.elementAt(title.indexOf(e)),
                    beforeLineStyle: LineStyle(
                      lineColor:
                          colorNode.elementAt(max(title.indexOf(e) - 1, 0)),
                      lineStokeWidth: storkLineWidth,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
