import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:main_hoon_arjun/widgets/shlok_selection.dart';
import 'package:main_hoon_arjun/widgets/verse_page.dart';

class AdhyayOverviewScreen extends StatefulWidget {
  final String title;
  final String adhyayName;
  final int totalShloks;
  final List<Map<String, dynamic>> chapterData;
  final List<String> shlokList;
  // ignore: use_key_in_widget_constructors
  const AdhyayOverviewScreen({this.title, this.adhyayName, this.totalShloks,this.chapterData,this.shlokList});

  static const routename = "/AdhyayOverviewScreen";

  @override
  State<AdhyayOverviewScreen> createState() => _AdhyayOverviewScreenState();
}

class _AdhyayOverviewScreenState extends State<AdhyayOverviewScreen> {
  // var chapterdata = <Map<String, dynamic>>[];
  // var shlokList = <String>[];

  

  PageController controller = PageController(initialPage: 0);
  int pagechanged = 1;
  bool _isVisible = false;

  void displayScrollIndicator() async {
    if (_isVisible) return;
    setState(() {
      _isVisible = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isVisible = false;
    });
  }
  @override
  void initState() {
    // getChapterData(widget.title);
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: displayScrollIndicator,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(65.0),
            child: BuildAppBar(
              controller: controller,
              adhyayName: widget.adhyayName,
              adhyayNumber: widget.title,
            )),
        body: Stack(children: [
          PageView.builder(
            onPageChanged: (index) => {
              setState(() {
                pagechanged = index + 1;
                () async {
                  if (_isVisible) return;
                  setState(() {
                    _isVisible = true;
                  });
                  await Future.delayed(const Duration(seconds: 3));
                  setState(() {
                    _isVisible = false;
                  });
                }();
              }),
            },
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return VersePage(
                verseNumber: index+1,
                shlokTitle:  widget.chapterData[index]['shlok'],
                pageController: controller,
                shlokText:  widget.chapterData[index]['text'],
                meaning:  widget.chapterData[index]['meaning'],
                translation:  widget.chapterData[index]['translation'],
              );
            },
            itemCount: widget.shlokList.length,
          ),
          Visibility(
            child: SlideIndicator(
                totalShloks: widget.totalShloks, currentShlok: pagechanged),
            visible: _isVisible,
          ),
        ]),
      ),
    );
  }
}

class SlideIndicator extends StatelessWidget {
  final int currentShlok;
  final int totalShloks;
  const SlideIndicator({
    this.currentShlok,
    this.totalShloks,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width / 2.3,
      top: MediaQuery.of(context).size.height / 1.2,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(7)),
          padding: const EdgeInsets.all(7),
          child: Text(
            '$currentShlok/$totalShloks',
            style: TextStyle(color: Colors.grey[200], fontSize: 13),
          )),
    );
  }
}

class BuildAppBar extends StatelessWidget {
  final PageController controller;

  const BuildAppBar({
    Key key,
    @required this.controller,
    @required this.adhyayName,
    @required this.adhyayNumber,
  }) : super(key: key);

  final String adhyayName;
  final String adhyayNumber;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.orange, //change your color here
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10),
              child: Text(
                adhyayName,
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.bold),
              )),
          Padding(
              padding: const EdgeInsets.only(
                left: 18,
              ),
              child: Text(
                adhyayNumber,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ShlokSelection(
                        pageController: controller,
                      );
                    });
              },
              icon: Image.asset(
                "assets/images/gridViewIcon.png",
                height: 26,
              )),
        )
      ],
    );
  }
}
