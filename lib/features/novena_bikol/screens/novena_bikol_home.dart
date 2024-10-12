import 'package:flutter/material.dart';
import 'package:novena_lorenzo/features/novena_bikol/screens/novena_bikol_page.dart';
import 'package:novena_lorenzo/widgets/appbar.dart';
import 'package:novena_lorenzo/widgets/scripture.dart';

class NovenaBikolHome extends StatefulWidget {
  const NovenaBikolHome({super.key});

  @override
  State<NovenaBikolHome> createState() => _NovenaBikolHomeState();
}

class _NovenaBikolHomeState extends State<NovenaBikolHome> {
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
            customAppbarTitle: "Novena ki San Lorenzo Ruiz",
            imgUrl: "./assets/background.jpg"),
        Scripture(),
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
                          builder: (context) => NovenaBikolPage(
                              novenaDay: index), // Replace with your screen
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
