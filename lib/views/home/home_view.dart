import 'package:flutter/material.dart';
import 'package:trainerdex/views/home/widgets/home_appbar.dart';
import 'package:trainerdex/views/home/widgets/home_listview.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: HomeListview(),
    );
  }
}
