import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novena_lorenzo/common/error.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/novena_english/bloc/novena_english_bloc.dart';
import 'package:novena_lorenzo/features/novena_english/models/novena_english_home_model.dart';
import 'package:novena_lorenzo/features/novena_english/screens/novena_english_page.dart';
import 'package:novena_lorenzo/widgets/scripture/screens/scripture.dart';

class NovenaEnglishHome extends StatefulWidget {
  const NovenaEnglishHome({super.key});

  @override
  State<NovenaEnglishHome> createState() => _NovenaEnglishHomeState();
}

class _NovenaEnglishHomeState extends State<NovenaEnglishHome> {
  ScrollController _scrollController = ScrollController();
  bool isCollapsed = false;
  List<NovenaEnglishHomeModel> data = [];

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

    context.read<NovenaEnglishBloc>().add(NovenaEnglishHomeFetch());
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
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
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
                "English Novena",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              )),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Image.asset(
              "./assets/english.jpg",
              height: 250.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scripture(
          translation: Translation.english,
        ),
        SliverToBoxAdapter(
          child: Divider(
            thickness: 2,
          ),
        ),
        BlocConsumer<NovenaEnglishBloc, NovenaEnglishState>(
          listener: (context, state) {
            if (state is NovenaEnglishHomeFetchFailure) {
              showError(context, state.error);
            }

            if (state is NovenaEnglishHomeFetchLoading) {}

            if (state is NovenaEnglishHomeFetchSuccess) {
              data = state.homeModel;
            }
          },
          builder: (context, state) {
            if (state is NovenaEnglishHomeFetchLoading || data.isEmpty) {
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
                          data[index].title,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          data[index].subtitle,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NovenaEnglishPage(novenaDay: index),
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
                childCount: 9, // The number of items in your list
              ),
            );
          },
        ),
      ],
    ));
  }
}
