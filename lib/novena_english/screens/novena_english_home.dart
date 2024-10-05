import 'package:flutter/material.dart';
import 'package:novena_lorenzo/novena_english/screens/novena_english_page.dart';

class NovenaEnglishHome extends StatefulWidget {
  const NovenaEnglishHome({super.key});

  @override
  State<NovenaEnglishHome> createState() => _NovenaEnglishHomeState();
}

class _NovenaEnglishHomeState extends State<NovenaEnglishHome> {
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
                "Novena ki San Lorenzo Ruiz",
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
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(top: 40, bottom: 30, right: 30, left: 30),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\"Do not be afraid of what you are about to suffer. I tell you, the devil will put some of you in prison to test you, and you will suffer persecution for ten days. Be faithful, even to the point of death, and I will give you life as your victor’s crown.\"",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  "- Revelation 2:10",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Divider(
            thickness: 2,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.add_rounded,
                      size: 40,
                    ),
                    title: Text(
                      "Pagkamundag sa Pamilya nin Dios",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "Enot na Aldaw",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    onTap: () {
                      print("Index: $index");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NovenaEnglishPage(
                              novena_day: index), // Replace with your screen
                        ),
                      );
                    },
                  ),
                  const Divider(
                    indent: 70, // This will add spacing from the leading icon
                  ),
                ],
              );
            },
            childCount: 9, // The number of items in your list
          ),
        ),
      ],
    ));
  }
}
