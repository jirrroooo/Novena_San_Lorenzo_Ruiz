import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novena_lorenzo/common/error.dart';
import 'package:novena_lorenzo/features/novena_bikol/bloc/novena_bikol_bloc.dart';
import 'package:novena_lorenzo/features/novena_bikol/screens/novena_bikol_home.dart';

class NovenaBikolPage extends StatefulWidget {
  final int novenaDay;

  const NovenaBikolPage({super.key, required this.novenaDay});

  @override
  State<NovenaBikolPage> createState() => _NovenaBikolPageState();
}

class _NovenaBikolPageState extends State<NovenaBikolPage> {
  ScrollController _scrollController = ScrollController();
  bool isCollapsed = false;

  double? titleFontSize = 18;
  double? subTitleFontSize = 17;
  double? prayerFontSize = 16;

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
        .read<NovenaBikolBloc>()
        .add(NovenaBikolPageFetced(index: widget.novenaDay));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber[200],
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Icon(
              Icons.text_fields,
              color: Colors.black,
            ),
            onPressed: () {}),
        body: BlocBuilder<NovenaBikolBloc, NovenaBikolState>(
          builder: (context, state) {
            if (state is NovenaBikolPageFetchedFailure) {
              showError(context, state.error);
            }

            if (state is! NovenaBikolPageFetchedSuccess) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            final data = state.novenaDetail;

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  centerTitle: true,
                  pinned: true,
                  expandedHeight: 200,
                  backgroundColor: Colors.amber[200],
                  title: AnimatedOpacity(
                      opacity:
                          isCollapsed ? 1.0 : 0.0, // Show title when collapsed
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        data.proper.aldaw,
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
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          "RINIBONG BUHAY PARA SA DIOS",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Nobena ki San Lorenzo Ruiz de Manila",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          data.qoute,
                          style: TextStyle(
                              fontSize: prayerFontSize,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider()
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "Pamibi sa Aroaldaw",
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
                          data.pamibi_sa_oroaldaw[index],
                          style: TextStyle(
                            fontSize: prayerFontSize,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      );
                    },
                    childCount:
                        data.pamibi_sa_oroaldaw.length, // Total number of items
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                      left: 100, right: 100, top: 20, bottom: 5),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Divider(),
                        Text(
                          "Enot na Kabtang",
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
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          "PAG-OMAW SA DIOS PARA KI SAN LORENZO",
                          style: TextStyle(
                              fontSize: subTitleFontSize,
                              fontWeight: FontWeight.bold),
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
                      "Antifona:",
                      style: TextStyle(
                          fontSize: prayerFontSize,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Text(
                        data.pagomaw_antifona[index],
                        style: TextStyle(
                            fontSize: prayerFontSize,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      );
                    },
                    childCount:
                        data.pagomaw_antifona.length, // Total number of items
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "Lider:",
                      style: TextStyle(
                          fontSize: prayerFontSize,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
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
                          data.enot_na_pamibi[index],
                          style: TextStyle(
                            fontSize: prayerFontSize,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      );
                    },
                    childCount:
                        data.enot_na_pamibi.length, // Total number of items
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "(${data.bible_verse})",
                      style: TextStyle(
                          fontSize: prayerFontSize,
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                for (int i = 0;
                    i < data.enot_na_kabtang_pamibi.length;
                    i++) ...[
                  SliverPadding(
                    padding: EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 10),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        "Lider:",
                        style: TextStyle(
                            fontSize: prayerFontSize,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int j) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          child: Text(
                            data.enot_na_kabtang_pamibi[i]
                                [j], // Accessing the item in the inner list
                            style: TextStyle(fontSize: prayerFontSize),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                      childCount: data.enot_na_kabtang_pamibi[i]
                          .length, // Length of the current sublist
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Gabos: ",
                            style: TextStyle(
                                fontSize: prayerFontSize,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10),
                            child: Text(
                              data.gabos,
                              style: TextStyle(
                                  fontSize: prayerFontSize,
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SliverPadding(
                  padding: EdgeInsets.only(
                      left: 100, right: 100, top: 20, bottom: 5),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Divider(),
                        Text(
                          "Ikaduwang Kabtang",
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
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          "NOBENA KI SAN LORENZO MARTIR",
                          style: TextStyle(
                              fontSize: subTitleFontSize,
                              fontWeight: FontWeight.bold),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lider:",
                          style: TextStyle(
                              fontSize: prayerFontSize,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          data.ika_duwang_kabtang_pamibi,
                          style: TextStyle(
                            fontSize: prayerFontSize,
                          ),
                          textAlign: TextAlign.justify,
                        ),
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
                          data.proper.aldaw.toUpperCase(),
                          style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          data.proper.title,
                          style: TextStyle(
                              fontSize: subTitleFontSize,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int i) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Text(
                          data.proper.reflection[i],
                          style: TextStyle(fontSize: prayerFontSize),
                          textAlign: TextAlign.justify,
                        ),
                      );
                    },
                    childCount: data.proper.reflection.length,
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          "Tataramon nin Dios",
                          style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          data.proper.tataramon_nin_Dios,
                          style: TextStyle(
                              fontSize: prayerFontSize,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "(Maontok nin kadikit na panahon sa paghorop-horop)",
                      style: TextStyle(
                          fontSize: prayerFontSize,
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                      left: 100, right: 100, top: 20, bottom: 5),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Divider(),
                        Text(
                          "Ika-tolong Kabtang",
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
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          "PAMIBI KAIBA SI SAN LORENZO",
                          style: TextStyle(
                              fontSize: subTitleFontSize,
                              fontWeight: FontWeight.bold),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lider:",
                          style: TextStyle(
                              fontSize: prayerFontSize,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          data.pataratara,
                          style: TextStyle(
                            fontSize: prayerFontSize,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Center(
                          child: Text(
                            "Pamibi sa ${data.proper.aldaw}",
                            style: TextStyle(
                                fontSize: prayerFontSize,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int i) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lider:",
                              style: TextStyle(
                                  fontSize: prayerFontSize,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              data.ika_tolong_kabtang_pamibi[i],
                              style: TextStyle(fontSize: prayerFontSize),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Gabos:",
                              style: TextStyle(
                                  fontSize: prayerFontSize,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: Text(
                                data.simbag,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: prayerFontSize,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    childCount: data.ika_tolong_kabtang_pamibi.length,
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 70),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Huring Pamibi",
                          style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          data.huring_pamibi,
                          style: TextStyle(
                            fontSize: prayerFontSize,
                          ),
                          textAlign: TextAlign.justify,
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
