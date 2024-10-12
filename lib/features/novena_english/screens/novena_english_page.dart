import 'package:flutter/material.dart';
import 'package:novena_lorenzo/widgets/appbar.dart';

class NovenaEnglishPage extends StatefulWidget {
  final int novenaDay;

  const NovenaEnglishPage({super.key, required this.novenaDay});

  @override
  State<NovenaEnglishPage> createState() => _NovenaEnglishPageState();
}

class _NovenaEnglishPageState extends State<NovenaEnglishPage> {
  ScrollController _scrollController = ScrollController();
  bool isCollapsed = false;

  @override
  void initState() {
    super.initState();

    // Listen to the scroll events
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      // kToolbarHeight is the height of the AppBar when collapsed
      setState(() {
        isCollapsed = offset > 200 - kToolbarHeight;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      controller: _scrollController,
      slivers: [
        CustomAppbar(
            isCollapsed: isCollapsed,
            customAppbarTitle: "Novena Day 1",
            imgUrl: "./assets/backround.jpg")
      ],
    ));
  }
}
