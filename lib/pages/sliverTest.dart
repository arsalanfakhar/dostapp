import 'package:flutter/material.dart';

class SliverTest extends StatefulWidget {
  @override
  _SliverTestState createState() => _SliverTestState();
}

class _SliverTestState extends State<SliverTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(

          )
        ],
      ),
    );
  }
}
