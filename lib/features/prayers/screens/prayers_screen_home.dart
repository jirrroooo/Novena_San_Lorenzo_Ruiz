import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novena_lorenzo/common/error.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/prayers/bloc/prayer_bloc.dart';
import 'package:novena_lorenzo/features/prayers/models/prayer_model.dart';
import 'package:novena_lorenzo/features/prayers/screens/prayer_screen_page.dart';
import 'package:novena_lorenzo/widgets/scripture/screens/scripture.dart';

class PrayersScreenHome extends StatefulWidget {
  const PrayersScreenHome({super.key});

  @override
  State<PrayersScreenHome> createState() => _PrayersScreenHomeState();
}

class _PrayersScreenHomeState extends State<PrayersScreenHome> {
  ScrollController _scrollController = ScrollController();
  bool isCollapsed = false;

  List<PrayerModel>? data;

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

    context.read<PrayerBloc>().add(PrayersFetched());
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
        body: CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          centerTitle: true,
          pinned: true,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/main-navigation');
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
              opacity: isCollapsed ? 1.0 : 0.0, // Show title when collapsed
              duration: const Duration(milliseconds: 300),
              child: Text(
                "Prayers to San Lorenzo Ruiz",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              )),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Image.asset(
              "./assets/prayers.jpg",
              height: 250.0,
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
        BlocConsumer<PrayerBloc, PrayerState>(
          listener: (context, state) {
            if (state is PrayerFetchedFailure) {
              showError(context, state.error);
            }

            if (state is PrayerFetchedLoading) {}

            if (state is PrayerFetchedSuccess) {
              data = state.prayers;
            }
          },
          builder: (context, state) {
            if (state is PrayerFetchedLoading ||
                data == null ||
                data!.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Image.asset("./assets/cross.png", height: 30),
                        title: Text(
                          data![index].englishTitle,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: data![index].bicolTitle == null
                            ? null
                            : Text(
                                data![index].bicolTitle ?? '',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PrayerScreenPage(prayerModel: data![index]),
                            ),
                          );
                        },
                      ),
                      const Divider(
                        indent: 55,
                      ),
                    ],
                  );
                },
                childCount: data!.length,
              ),
            );
          },
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
          ),
        )
      ],
    ));
  }
}
