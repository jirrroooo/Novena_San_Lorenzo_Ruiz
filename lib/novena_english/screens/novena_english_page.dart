import 'package:flutter/material.dart';

class NovenaEnglishPage extends StatefulWidget {
  final int novena_day;

  const NovenaEnglishPage({super.key, required this.novena_day});

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
        SliverAppBar(
          centerTitle: true,
          pinned: true,
          expandedHeight: 200,
          title: AnimatedOpacity(
              opacity: isCollapsed ? 1.0 : 0.0, // Show title when collapsed
              duration: const Duration(milliseconds: 300),
              child: const Text(
                "01 | Pagkamundag sa Pamilya nin Dios",
                style: TextStyle(fontWeight: FontWeight.w500),
              )),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Image.asset(
              "./assets/background.jpg",
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ));
  }
}
