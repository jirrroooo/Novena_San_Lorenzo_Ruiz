import 'package:flutter/material.dart';
import 'package:novena_lorenzo/common/error.dart';
import 'package:novena_lorenzo/features/novena_english/bloc/novena_english_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NovenaEnglishPage extends StatefulWidget {
  final int novenaDay;

  const NovenaEnglishPage({super.key, required this.novenaDay});

  @override
  State<NovenaEnglishPage> createState() => _NovenaEnglishPageState();
}

class _NovenaEnglishPageState extends State<NovenaEnglishPage> {
  ScrollController _scrollController = ScrollController();
  bool isCollapsed = false;
  bool isExpanded = false;

  double? titleFontSize = 20;
  double? subTitleFontSize = 18;
  double? prayerFontSize = 17;

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

    context
        .read<NovenaEnglishBloc>()
        .add(NovenaEnglishPageFetch(index: widget.novenaDay));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isExpanded)
              FloatingActionButton(
                backgroundColor: Colors.amber[200],
                onPressed: () {
                  setState(() {
                    titleFontSize = 18;
                    subTitleFontSize = 17;
                    prayerFontSize = 16;
                    isExpanded = !isExpanded;
                  });
                },
                child: Text('Small', style: TextStyle(fontSize: 14.0)),
              ),
            if (isExpanded)
              SizedBox(
                height: 15,
              ),
            if (isExpanded)
              FloatingActionButton(
                backgroundColor: Colors.amber[200],
                onPressed: () {
                  setState(() {
                    titleFontSize = 20;
                    subTitleFontSize = 18;
                    prayerFontSize = 17;
                    isExpanded = !isExpanded;
                  });
                },
                child: Text('Normal', style: TextStyle(fontSize: 14.0)),
              ),
            if (isExpanded)
              SizedBox(
                height: 15,
              ),
            if (isExpanded)
              FloatingActionButton(
                backgroundColor: Colors.amber[200],
                onPressed: () {
                  setState(() {
                    titleFontSize = 21;
                    subTitleFontSize = 20;
                    prayerFontSize = 18;
                    isExpanded = !isExpanded;
                  });
                },
                child: Text('Large', style: TextStyle(fontSize: 14.0)),
              ),
            if (isExpanded)
              SizedBox(
                height: 15,
              ),
            FloatingActionButton(
                backgroundColor:
                    isExpanded ? Colors.grey[300] : Colors.amber[200],
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  isExpanded ? Icons.close : Icons.text_fields,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                }),
          ],
        ),
        body: BlocBuilder<NovenaEnglishBloc, NovenaEnglishState>(
          builder: (context, state) {
            if (state is NovenaEnglishPageFetchFailure) {
              showError(context, state.error);
            }

            if (state is! NovenaEnglishPageFetchSuccess) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            final data = state.pageModel;

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  centerTitle: true,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                    ),
                  ),
                  expandedHeight: 200,
                  backgroundColor: Colors.amber[200],
                  title: AnimatedOpacity(
                      opacity:
                          isCollapsed ? 1.0 : 0.0, // Show title when collapsed
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        "English Novena | ${data.reflection.subtitle}",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700),
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
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const Text(
                          "NOVENA TO SAINT LORENZO RUIZ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "${data.reflection.subtitle} of Novena",
                          style: TextStyle(fontSize: 17),
                        )
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          "+ Sign of the Cross +",
                          style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "In the name of the Father, and of the Son, and of the Holy Spirit. Amen.",
                          style: TextStyle(
                            fontSize: prayerFontSize,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "Act of Contrition",
                      style: TextStyle(
                          fontSize: titleFontSize, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Text(
                          data.act_of_contrition[index],
                          style: TextStyle(
                            fontSize: prayerFontSize,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      );
                    },
                    childCount:
                        data.act_of_contrition.length, // Total number of items
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "Opening Prayer",
                      style: TextStyle(
                          fontSize: titleFontSize, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Text(
                          data.opening_prayer[index],
                          style: TextStyle(
                            fontSize: prayerFontSize,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      );
                    },
                    childCount:
                        data.opening_prayer.length, // Total number of items
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(left: 80, right: 80, top: 40, bottom: 5),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Divider(),
                        Text(
                          "${data.reflection.subtitle} Reflection",
                          style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Divider()
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(right: 15, left: 15, bottom: 20),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          data.reflection.title,
                          style: TextStyle(
                              fontSize: subTitleFontSize,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Text(
                          data.reflection.reflection[index],
                          style: TextStyle(
                            fontSize: prayerFontSize,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      );
                    },
                    childCount: data
                        .reflection.reflection.length, // Total number of items
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "(${data.reflection_instruction})",
                      style: TextStyle(
                        fontSize: prayerFontSize,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "Act of Supplication",
                      style: TextStyle(
                          fontSize: titleFontSize, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Column(
                          children: [
                            Text(
                              data.supplications[index],
                              style: TextStyle(
                                fontSize: prayerFontSize,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              data.supplication_response,
                              style: TextStyle(
                                  fontSize: prayerFontSize,
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      );
                    },
                    childCount:
                        data.supplications.length, // Total number of items
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "The Lord's Prayer",
                      style: TextStyle(
                          fontSize: titleFontSize, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 0, left: 70, right: 70, bottom: 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "In Honor of the Holy Passion of Jesus Christ",
                      style: TextStyle(
                        fontSize: prayerFontSize! - 2,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      data.our_father,
                      style: TextStyle(
                        fontSize: prayerFontSize,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                      top: 30, left: 15, right: 15, bottom: 100),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          "+ Sign of the Cross +",
                          style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "In the name of the Father, and of the Son, and of the Holy Spirit. Amen.",
                          style: TextStyle(
                            fontSize: prayerFontSize,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
