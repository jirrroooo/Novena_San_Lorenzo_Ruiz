import 'package:flutter/material.dart';

class CustomAppbar extends StatefulWidget {
  final String customAppbarTitle;
  final String imgUrl;
  final bool isCollapsed;

  const CustomAppbar(
      {super.key,
      required this.isCollapsed,
      required this.customAppbarTitle,
      required this.imgUrl});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      pinned: true,
      expandedHeight: 200,
      title: AnimatedOpacity(
          opacity: widget.isCollapsed ? 1.0 : 0.0, // Show title when collapsed
          duration: const Duration(milliseconds: 300),
          child: Text(
            widget.customAppbarTitle,
            style: TextStyle(fontWeight: FontWeight.w500),
          )),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Image.asset(
          widget.imgUrl,
          height: 200.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
