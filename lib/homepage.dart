import 'package:flutter/material.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/novena_bikol/screens/novena_bikol_home.dart';
import 'package:novena_lorenzo/widgets/appbar.dart';
import 'package:novena_lorenzo/widgets/scripture/screens/scripture.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  bool isCollapsed = false;

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
    const _tableSpacing = 15.0;

    return Scaffold(
        body: CustomScrollView(
      controller: _scrollController,
      slivers: [
        CustomAppbar(
            isCollapsed: isCollapsed,
            customAppbarTitle: "Novena to Saint Lorenzo Ruiz",
            imgUrl: "./assets/background.jpg"),
        Scripture(
          translation: Translation.english,
        ),
        SliverPadding(
          padding: EdgeInsets.all(10),
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
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _homepageSelection[index]["title"]!,
                        style: TextStyle(
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
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Prayers to St. Lorenzo Ruiz",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  width: 25,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.pushNamed(context, "/prayers-home");
                  },
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(10, (index) {
                // Replace ListView.builder
                return GestureDetector(
                  onTap: () {
                    // Navigate to another screen when tapped
                    Navigator.pushNamed(context, "/prayers-page");
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
                        const Text(
                          "Financial",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(top: 30, right: 10, left: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Biography of St. Lorenzo Ruiz",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Spacer(),
                    TextButton(
                      child: Text("Read More",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pushNamed(context, "/biography");
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "./assets/lorenzo.jpg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 15,
                ),
                Table(
                  columnWidths: {0: FixedColumnWidth(120)},
                  children: const [
                    TableRow(
                      children: [
                        TableCell(
                            child: Text('Born:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500))),
                        TableCell(
                            child: Padding(
                          padding: EdgeInsets.only(bottom: _tableSpacing),
                          child: Text(
                            'November 28, 1594',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        )),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text('Place of Birth: ',
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        TableCell(
                            child: Padding(
                          padding: EdgeInsets.only(bottom: _tableSpacing),
                          child: Text(
                              'Chinese Father and Filipino Mother (Both Catholics)'),
                        )),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text('Died:',
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        TableCell(
                            child: Padding(
                          padding: EdgeInsets.only(bottom: _tableSpacing),
                          child: Text('September 29, 1637 (Aged 42)'),
                        )),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text('Place of Death:',
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: _tableSpacing),
                            child: Text(
                                'Nagasaki, Hizen Province, Tokugawa Shogunate (Military Government of Japan)'),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text('Cause of Death:',
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        TableCell(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: _tableSpacing),
                              child: Text(
                                  'Tsurushi (Torture technique for Christians to recant their faith. Hung upside-down)')),
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text('Beatified:',
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        TableCell(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: _tableSpacing),
                              child: Text(
                                  'February 18, 1981, Manila, Philippines by Pope John Paul II')),
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text('Canonized:',
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        TableCell(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: _tableSpacing),
                              child: Text(
                                  'October 18, 1987, Vatican City by Pope John Paul II')),
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text('Major Shrine:',
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        TableCell(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: _tableSpacing),
                              child: Text(
                                  'Binondo Church, Binondo, Manila, Philippines')),
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text('Feast:',
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        TableCell(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: _tableSpacing),
                              child: Text('September 28')),
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text('Attributes:',
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        TableCell(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: _tableSpacing),
                              child: Text(
                                  'Rosary in clasped hands, gallows and pit, barong tagalog or camisa de chino and black trousers, cross, palm of martyrdom')),
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text('Patronage',
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        TableCell(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: _tableSpacing),
                              child: Text(
                                  'The Philippines, Filipinos, Overseas Filipino Workers and migrant workers, immigrants, the poor, separated families, Filipino youth, Chinese-Filipinos, Filipino Altar servers, Tagalogs, Archdiocese of Manila.')),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
