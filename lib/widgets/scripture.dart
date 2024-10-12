import 'package:flutter/material.dart';

class Scripture extends StatefulWidget {
  const Scripture({super.key});

  @override
  State<Scripture> createState() => _ScriptureState();
}

class _ScriptureState extends State<Scripture> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(30),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "\"Do not be afraid of what you are about to suffer. I tell you, the devil will put some of you in prison to test you, and you will suffer persecution for ten days. Be faithful, even to the point of death, and I will give you life as your victor’s crown.\"",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              "- Revelation 2:10",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            )
          ],
        ),
      ),
    );
  }
}
