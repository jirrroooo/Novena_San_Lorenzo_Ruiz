import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novena_lorenzo/common/error.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/novena_bikol/bloc/novena_bikol_bloc.dart';
import 'package:novena_lorenzo/features/novena_bikol/models/novena_bikol_home_model.dart';
import 'package:novena_lorenzo/features/novena_bikol/screens/novena_bikol_page.dart';
import 'package:novena_lorenzo/widgets/scripture/screens/scripture.dart';

class NovenaBikolHome extends StatefulWidget {
  const NovenaBikolHome({super.key});

  @override
  State<NovenaBikolHome> createState() => _NovenaBikolHomeState();
}

class _NovenaBikolHomeState extends State<NovenaBikolHome> {
  ScrollController _scrollController = ScrollController();
  bool isCollapsed = false;

  List<NovenaBikolHomeModel>? data;

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

    context.read<NovenaBikolBloc>().add(NovenaBikolTitleFetched());
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
              Navigator.pushReplacementNamed(context, '/main-navigation');
            },
            child: const Icon(
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
              child: const Text(
                "Bicol Novena",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              )),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Image.asset(
              "./assets/bicol.webp",
              height: 250.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Scripture(
          translation: Translation.bicol,
        ),
        const SliverToBoxAdapter(
          child: Divider(
            thickness: 2,
          ),
        ),
        BlocConsumer<NovenaBikolBloc, NovenaBikolState>(
          listener: (context, state) {
            if (state is NovenaBikolTitleFetchedFailure) {
              showError(context, state.error);
            }

            if (state is NovenaBikolTitleFetchedLoading) {}

            if (state is NovenaBikolTitleFetchedSuccess) {
              data = state.titleList;
            }
          },
          builder: (context, state) {
            if (state is NovenaBikolPageFetcedLoading ||
                data == null ||
                data!.isEmpty) {
              return const SliverToBoxAdapter(
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
                          data![index].title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          data![index].aldaw,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NovenaBikolPage(novenaDay: index),
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
                    "./assets/bernarte.webp",
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
                    "./assets/pavilando.webp",
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
                    "./assets/sorra.webp",
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
        )
      ],
    ));
  }
}
