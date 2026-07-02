import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novena_lorenzo/features/novena_bikol/bloc/novena_bikol_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  ScrollController _scrollController = ScrollController();
  bool isCollapsed = false;
  final String privacyPolicyUrl =
      'https://www.termsfeed.com/live/7263e95b-e3b4-47f2-aa5e-92a8050331a3';

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

  Future<void> launchPrivacyPolicyUrl() async {
    final uri = Uri.parse(privacyPolicyUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: "Privacy Policy");
    } else {
      throw 'Could not launch $privacyPolicyUrl';
    }
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
          expandedHeight: 250,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.red[400],
          title: AnimatedOpacity(
              opacity: isCollapsed ? 1.0 : 0.0, // Show title when collapsed
              duration: const Duration(milliseconds: 300),
              child: const Text(
                "About the App",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              )),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Image.asset(
              "./assets/background.webp",
              height: 250.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "About the App:",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          border:
                              Border.all(color: Colors.amber[700]!, width: 3),
                          color: Colors.red[400]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(360),
                        child: Image.asset(
                          './assets/jiro.webp',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "John Rommel B. Octavo",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                          Text(
                            "App Developer",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Welcome to the St. Lorenzo Ruiz Novena App, created to deepen devotion to the first Filipino saint, St. Lorenzo Ruiz.",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "The novena included in this app is not an original work of the developer. Proper attribution to its author is provided within the app.",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "The developer is dedicated to creating Catholic-themed applications designed to strengthen faith and foster devotion through technology. This humble work is dedicated to the Almighty God.",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "For feedback, suggestions, or corrections, feel free to reach out at jiro.octavo@gmail.com.",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87, // Important to set color!
                    ),
                    children: [
                      const TextSpan(
                        text:
                            'We value your privacy and are committed to protecting your data. To learn more, please read our ',
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = launchPrivacyPolicyUrl,
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider()
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Bicol Novena:",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 15,
                ),
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  leading: Image.asset(
                    "./assets/bernarte.webp",
                    width: 50,
                  ),
                  title: const Text(
                    "Rev. Msgr. Crispin C. Bernarte Jr.",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    "Author",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  leading: Image.asset(
                    "./assets/pavilando.webp",
                    width: 50,
                  ),
                  title: const Text(
                    "Rev. Msgr. Don Vito Pavilando",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    "Nihil Obstat",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  leading: Image.asset(
                    "./assets/sorra.webp",
                    width: 50,
                  ),
                  title: const Text(
                    "+ Most. Rev. Jose C. Sorra, DD",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    "Imprimatur",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "All Rights Reserved",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "COPYRIGHT 2004",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "Commission on Lay Apostolate",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "Diocese of Legazpi",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider()
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "English Novena:",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 15,
                ),
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  leading: Image.asset(
                    "./assets/aquino.webp",
                    width: 50,
                  ),
                  title: const Text(
                    "Rev. Msgr. Benedicto S. Aquino",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    "Nihil Obstat",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  leading: Image.asset(
                    "./assets/abriol.webp",
                    width: 50,
                  ),
                  title: const Text(
                    "Rt. Rev. Msgr. Jose C. Abriol",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    "Imprimatur",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "All Rights Reserved to the Rightful Owner",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
