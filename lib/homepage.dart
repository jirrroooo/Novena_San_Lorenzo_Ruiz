import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novena_lorenzo/common/error.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/biography/bloc/biography_bloc.dart';
import 'package:novena_lorenzo/features/biography/models/biography_model.dart';
import 'package:novena_lorenzo/features/prayers/bloc/prayer_bloc.dart';
import 'package:novena_lorenzo/features/prayers/models/prayer_model.dart';
import 'package:novena_lorenzo/features/prayers/screens/prayer_screen_page.dart';
import 'package:novena_lorenzo/widgets/scripture/screens/scripture.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  bool isCollapsed = false;

  List<PrayerModel>? prayers;
  BiographyModel? biography;

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
    context.read<BiographyBloc>().add(BiographyFetched());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> _homepageSelection = [
    {"title": "Himno", "img_url": "./assets/background.jpg", "nav": '/himno'},
    {
      "title": "Perpetual Novena",
      "img_url": "./assets/background.jpg",
      "nav": "/perpetual-novena"
    },
    {
      "title": "Bicol Novena",
      "img_url": "./assets/background.jpg",
      "nav": "/bicol-novena-home"
    },
    {
      "title": "English Novena",
      "img_url": "./assets/background.jpg",
      "nav": "/english-novena-home"
    },
  ];

  @override
  Widget build(BuildContext context) {
    const _tableSpacing = 25.0;

    return Scaffold(
        body: CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          centerTitle: true,
          pinned: true,
          automaticallyImplyLeading: false,
          expandedHeight: 200,
          backgroundColor: Colors.amber[200],
          title: AnimatedOpacity(
              opacity: isCollapsed ? 1.0 : 0.0, // Show title when collapsed
              duration: const Duration(milliseconds: 300),
              child: const Text(
                "Novena to Saint Lorenzo Ruiz",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
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
        const Scripture(
          translation: Translation.english,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 0,
                crossAxisSpacing: 15.0,
                childAspectRatio: 1.0,
                mainAxisExtent: 150),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, _homepageSelection[index]["nav"]!);
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        _homepageSelection[index]["img_url"]!,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _homepageSelection[index]["title"]!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                );
              },
              childCount: _homepageSelection.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Prayers to St. Lorenzo Ruiz",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/prayers-home");
                  },
                )
              ],
            ),
          ),
        ),
        BlocConsumer<PrayerBloc, PrayerState>(
          listener: (context, state) {
            if (state is PrayerFetchedLoading) {}

            if (state is PrayerFetchedFailure) {
              showError(context, state.error);
            }

            if (state is PrayerFetchedSuccess) {
              prayers = state.prayers;
            }
          },
          builder: (context, state) {
            if (prayers == null) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }

            return SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(prayers!.length, (index) {
                    // Replace ListView.builder
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrayerScreenPage(
                                    prayerModel: prayers![index])));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.asset(
                              "./assets/background.jpg",
                              height: 50,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              prayers![index].shortTitle,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          },
        ),
        BlocConsumer<BiographyBloc, BiographyState>(
          listener: (context, state) {
            if (state is BiographyFetchedLoading) {}

            if (state is BiographyFetchedFailure) {
              showError(context, state.error);
            }

            if (state is BiographyFetchedSuccess) {
              biography = state.biographyModel;
            }
          },
          builder: (context, state) {
            if (biography == null) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }
            return SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 30, right: 10, left: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Biography of St. Lorenzo Ruiz",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const Spacer(),
                        TextButton(
                          child: Text("Read More",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w400)),
                          onPressed: () {
                            Navigator.pushNamed(context, "/biography");
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "./assets/lorenzo.jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Table(
                      columnWidths: {3: const FixedColumnWidth(120)},
                      children: biography!.shortTitles.asMap().entries.map((
                        entry,
                      ) {
                        int index = entry.key;
                        return TableRow(
                          children: [
                            TableCell(
                                child: Text(
                                    "${biography!.shortTitles[index].toString()}:",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700))),
                            TableCell(
                                child: Padding(
                              padding: EdgeInsets.only(bottom: _tableSpacing),
                              child: Text(
                                biography!.shortDetails[index].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
