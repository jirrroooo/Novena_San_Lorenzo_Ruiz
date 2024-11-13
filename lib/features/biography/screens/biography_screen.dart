import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novena_lorenzo/common/error.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/biography/bloc/biography_bloc.dart';
import 'package:novena_lorenzo/features/biography/models/biography_model.dart';
import 'package:novena_lorenzo/widgets/scripture/screens/scripture.dart';

class BiographyScreen extends StatefulWidget {
  const BiographyScreen({super.key});

  @override
  State<BiographyScreen> createState() => _BiographyScreenState();
}

class _BiographyScreenState extends State<BiographyScreen> {
  ScrollController _scrollController = ScrollController();
  bool isCollapsed = false;

  BiographyModel? data;

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

    context.read<BiographyBloc>().add(BiographyFetched());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Translation randomTranslation() {
    var random = Random();
    int randomNumber = random.nextInt(2) + 1;

    if (randomNumber % 2 == 0) {
      return Translation.bicol;
    }
    return Translation.english;
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
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              centerTitle: true,
              pinned: true,
              expandedHeight: 200,
              backgroundColor: Colors.amber[200],
              title: AnimatedOpacity(
                  opacity: isCollapsed ? 1.0 : 0.0, // Show title when collapsed
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    "Biography of San Lorenzo Ruiz",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  )),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Image.asset(
                  "./assets/lorenzo.jpg",
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Scripture(
              translation: randomTranslation(),
            ),
            SliverToBoxAdapter(
              child: Divider(
                thickness: 2,
              ),
            ),
            BlocConsumer<BiographyBloc, BiographyState>(
              listener: (context, state) {
                if (state is BiographyFetchedFailure) {
                  showError(context, state.error);
                }

                if (state is BiographyFetchedLoading) {}

                if (state is BiographyFetchedSuccess) {
                  data = state.biographyModel;
                }
              },
              builder: (context, state) {
                if (state is BiographyFetchedLoading || data == null) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }

                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                    child: Column(
                      children: [
                        Table(
                          columnWidths: {2: const FixedColumnWidth(120)},
                          children: data!.shortTitles.asMap().entries.map((
                            entry,
                          ) {
                            int index = entry.key;
                            return TableRow(
                              children: [
                                TableCell(
                                    child: Text(
                                        "${data!.shortTitles[index].toString()}:",
                                        style: TextStyle(
                                            fontSize: subTitleFontSize,
                                            fontWeight: FontWeight.w700))),
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    data!.shortDetails[index].toString(),
                                    style: TextStyle(
                                      fontSize: prayerFontSize,
                                    ),
                                  ),
                                )),
                              ],
                            );
                          }).toList(),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: data!.longTitles.length,
                            itemBuilder: (context, i) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data!.longTitles[i],
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: titleFontSize,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: data!.longDetails[i].length,
                                      itemBuilder: (context, j) {
                                        return ListTile(
                                          title: Text(
                                            data!.longDetails[i][j],
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: prayerFontSize,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          leading: Icon(
                                            Icons.circle,
                                            size: 14,
                                            color: Colors.red[700],
                                          ),
                                        );
                                      }),
                                  SizedBox(
                                    height: 25,
                                  )
                                ],
                              );
                            })
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
