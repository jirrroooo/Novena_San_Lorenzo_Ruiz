import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novena_lorenzo/common/error.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/perpetual_novena/bloc/perpetual_novena_bloc.dart';
import 'package:novena_lorenzo/features/perpetual_novena/models/perpetual_novena_model.dart';

class PerpetualNovenaScreen extends StatefulWidget {
  const PerpetualNovenaScreen({super.key});

  @override
  State<PerpetualNovenaScreen> createState() => _PerpetualNovenaScreenState();
}

class _PerpetualNovenaScreenState extends State<PerpetualNovenaScreen> {
  ScrollController _scrollController = ScrollController();
  bool isCollapsed = false;
  bool isExpanded = false;
  Translation translation = Translation.english;

  double? titleFontSize = 20;
  double? subTitleFontSize = 18;
  double? prayerFontSize = 17;

  PerpetualNovenaModel? data;

  @override
  void initState() {
    super.initState();

    context
        .read<PerpetualNovenaBloc>()
        .add(PerpetualNovenaFetched(translation: translation));

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
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isExpanded)
              FloatingActionButton(
                backgroundColor: Colors.red[400],
                onPressed: () {
                  setState(() {
                    titleFontSize = 16;
                    subTitleFontSize = 15;
                    prayerFontSize = 14;
                    isExpanded = !isExpanded;
                  });
                },
                child: Text('Small',
                    style: TextStyle(fontSize: 14.0, color: Colors.white)),
              ),
            if (isExpanded)
              SizedBox(
                height: 15,
              ),
            if (isExpanded)
              FloatingActionButton(
                backgroundColor: Colors.red[400],
                onPressed: () {
                  setState(() {
                    titleFontSize = 20;
                    subTitleFontSize = 18;
                    prayerFontSize = 17;
                    isExpanded = !isExpanded;
                  });
                },
                child: Text('Normal',
                    style: TextStyle(fontSize: 14.0, color: Colors.white)),
              ),
            if (isExpanded)
              SizedBox(
                height: 15,
              ),
            if (isExpanded)
              FloatingActionButton(
                backgroundColor: Colors.red[400],
                onPressed: () {
                  setState(() {
                    titleFontSize = 22;
                    subTitleFontSize = 21;
                    prayerFontSize = 20;
                    isExpanded = !isExpanded;
                  });
                },
                child: Text('Large',
                    style: TextStyle(fontSize: 14.0, color: Colors.white)),
              ),
            if (isExpanded)
              SizedBox(
                height: 15,
              ),
            FloatingActionButton(
                backgroundColor:
                    isExpanded ? Colors.grey[300] : Colors.red[400],
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  isExpanded ? Icons.close : Icons.text_fields,
                  color: isExpanded ? Colors.black : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                }),
          ],
        ),
        body: BlocConsumer<PerpetualNovenaBloc, PerpetualNovenaState>(
          listener: (context, state) {
            if (state is PerpetualNovenaFetchedFailure) {
              showError(context, state.error);
            }

            if (state is PerpetualNovenaFetchedSuccess) {
              data = state.perpetualNovenaModel;
            }
          },
          builder: (context, state) {
            if (state is! PerpetualNovenaFetchedSuccess || data == null) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

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
                      color: Colors.white,
                    ),
                  ),
                  expandedHeight: 250,
                  backgroundColor: Colors.red[400],
                  title: AnimatedOpacity(
                      opacity:
                          isCollapsed ? 1.0 : 0.0, // Show title when collapsed
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        translation == Translation.bicol
                            ? "Bicol | Danay na Novena"
                            : "English | Perpetual Novena",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      )),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Image.asset(
                      "./assets/perpetual.jpg",
                      height: 250.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: 25, right: 10, left: 10),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data!.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                translation == Translation.bicol
                                    ? translation = Translation.english
                                    : translation = Translation.bicol;

                                context.read<PerpetualNovenaBloc>().add(
                                    PerpetualNovenaFetched(
                                        translation: translation));
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 3),
                                child: Text(
                                  translation == Translation.bicol
                                      ? "Bicol"
                                      : "English",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ))
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
                          translation == Translation.bicol
                              ? "+ Pag-antanda nin Krus +"
                              : "+ Sign of the Cross +",
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
                          translation == Translation.bicol
                              ? "Sa ngaran kan Ama, asin kan Aki, Pati an Espiritu Santo. Amen."
                              : "In the name of the Father, and of the Son, and of the Holy Spirit. Amen.",
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
                  padding: EdgeInsets.only(top: 20, right: 10, left: 10),
                  sliver: SliverList.builder(
                      itemCount: data!.prayer.length,
                      itemBuilder: (BuildContext context, index) {
                        return Column(
                          children: [
                            Text(
                              data!.prayer[index],
                              style: TextStyle(
                                fontSize: prayerFontSize,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        );
                      }),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: 20, right: 10, left: 10),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          translation == Translation.bicol
                              ? "Ama Niamo"
                              : "The Lord's Prayer",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: titleFontSize),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          data!.ourFather,
                          style: TextStyle(fontSize: prayerFontSize),
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: 30, right: 10, left: 10),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          translation == Translation.bicol
                              ? "Ave Maria"
                              : "Hail Mary",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: titleFontSize),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          data!.hailMary,
                          style: TextStyle(fontSize: prayerFontSize),
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: 50, right: 10, left: 10),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          translation == Translation.bicol
                              ? "Kamurawayan sa Dios"
                              : "Glory Be",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: titleFontSize),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          data!.gloryBe,
                          style: TextStyle(fontSize: prayerFontSize),
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: 50, right: 10, left: 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      translation == Translation.bicol
                          ? "Huring Pamibi"
                          : "Last Prayer",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: titleFontSize),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 0),
                  sliver: SliverList.builder(
                      itemCount: data!.lastPrayer.length,
                      itemBuilder: (BuildContext context, index) {
                        return Column(
                          children: [
                            Text(
                              data!.lastPrayer[index],
                              style: TextStyle(
                                fontSize: prayerFontSize,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        );
                      }),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 30),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          translation == Translation.bicol
                              ? "+ Pag-antanda nin Krus +"
                              : "+ Sign of the Cross +",
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
                          translation == Translation.bicol
                              ? "Sa ngaran kan Ama, asin kan Aki, Pati an Espiritu Santo. Amen."
                              : "In the name of the Father, and of the Son, and of the Holy Spirit. Amen.",
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(),
                  ),
                ),
                if (translation == Translation.bicol)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.all(0),
                            leading: Image.asset(
                              "./assets/bernarte.png",
                              width: 50,
                            ),
                            title: Text(
                              "Rev. Msgr. Crispin C. Bernarte Jr.",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              "Author",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.all(0),
                            leading: Image.asset(
                              "./assets/pavilando.jpg",
                              width: 50,
                            ),
                            title: Text(
                              "Rev. Msgr. Don Vito Pavilando",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              "Nihil Obstat",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.all(0),
                            leading: Image.asset(
                              "./assets/sorra.jpg",
                              width: 50,
                            ),
                            title: Text(
                              "+ Most. Rev. Jose C. Sorra, DD",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              "Imprimatur",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            "All Rights Reserved",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "COPYRIGHT 2004",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Commission on Lay Apostolate",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Diocese of Legazpi",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 50)
                        ],
                      ),
                    ),
                  ),
                if (translation == Translation.english)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 15.0, right: 15, bottom: 50),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.all(0),
                            leading: Image.asset(
                              "./assets/aquino.png",
                              width: 50,
                            ),
                            title: Text(
                              "Rev. Msgr. Benedicto S. Aquino",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              "Nihil Obstat",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.all(0),
                            leading: Image.asset(
                              "./assets/abriol.jpg",
                              width: 50,
                            ),
                            title: Text(
                              "Rt. Rev. Msgr. Jose C. Abriol",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              "Imprimatur",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            "All Rights Reserved to the Rightful Owner",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            );
          },
        ));
  }
}
