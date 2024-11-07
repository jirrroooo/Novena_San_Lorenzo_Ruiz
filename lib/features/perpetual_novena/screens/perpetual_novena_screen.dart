import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novena_lorenzo/common/error.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/perpetual_novena/bloc/perpetual_novena_bloc.dart';
import 'package:novena_lorenzo/features/perpetual_novena/models/perpetual_novena_model.dart';
import 'package:novena_lorenzo/widgets/appbar.dart';

class PerpetualNovenaScreen extends StatefulWidget {
  const PerpetualNovenaScreen({super.key});

  @override
  State<PerpetualNovenaScreen> createState() => _PerpetualNovenaScreenState();
}

class _PerpetualNovenaScreenState extends State<PerpetualNovenaScreen> {
  ScrollController _scrollController = ScrollController();
  bool isCollapsed = false;
  Translation translation = Translation.english;

  double? titleFontSize = 18;
  double? subTitleFontSize = 17;
  double? prayerFontSize = 16;

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
            CustomAppbar(
              isCollapsed: isCollapsed,
              customAppbarTitle: translation == Translation.bicol
                  ? "Danay na Novena"
                  : "Perpetual Novena",
              imgUrl: "./assets/background.jpg",
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
                          fontSize: titleFontSize, fontWeight: FontWeight.bold),
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
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3),
                            child: Text(
                              translation == Translation.bicol
                                  ? "Bicol"
                                  : "English",
                              style: TextStyle(
                                  fontSize: subTitleFontSize,
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
                          fontSize: prayerFontSize),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      data!.ourFather,
                      style: TextStyle(fontSize: subTitleFontSize),
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 20, right: 10, left: 10),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    Text(
                      translation == Translation.bicol
                          ? "Ave Maria"
                          : "Hail Mary",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: subTitleFontSize),
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
              padding: EdgeInsets.only(top: 20, right: 10, left: 10),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    Text(
                      translation == Translation.bicol
                          ? "Kamurawayan sa Dios"
                          : "Glory Be",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: subTitleFontSize),
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
              padding: EdgeInsets.only(top: 20, right: 10, left: 10),
              sliver: SliverToBoxAdapter(
                child: Text(
                  translation == Translation.bicol
                      ? "Huring Pamibi"
                      : "Last Prayer",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: subTitleFontSize),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SliverPadding(
              padding:
                  EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 20),
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
          ],
        );
      },
    ));
  }
}
