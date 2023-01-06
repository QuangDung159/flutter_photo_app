// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_photo_app/common/constants.dart';
import 'package:flutter_photo_app/screens/components/home_tab_grid_photos.dart';
import 'package:flutter_photo_app/screens/components/home_tab_list_post.dart';
import 'package:flutter_photo_app/screens/components/main_app_bar.dart';
import 'package:flutter_photo_app/services/google_services.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final googleInfo = Get.put(GoogleInfo());

  void onTap(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTabGridPhoto(),
    HomeTabListPost(),
    // HomeTabListAlbum(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(contentAppBarHeight),
        child: MainAppBar(),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryBackground,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Post',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.abc),
          //   label: 'List album',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: onTap,
      ),
    );
  }
}