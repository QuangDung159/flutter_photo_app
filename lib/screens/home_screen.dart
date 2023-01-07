// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_photo_app/common/constants.dart';
import 'package:flutter_photo_app/screens/MyHomePage.dart';
import 'package:flutter_photo_app/screens/components/home_tab_grid_photos.dart';
import 'package:flutter_photo_app/screens/components/home_tab_list_post.dart';
import 'package:flutter_photo_app/screens/components/main_app_bar.dart';
import 'package:flutter_photo_app/services/google_services.dart';
import 'package:flutter_photo_app/utils/notification_service.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GoogleInfo googleInfo = Get.put(GoogleInfo());
  late final NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
  }

  void onTap(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTabGridPhoto(),
    HomeTabListPost(),
    // HomeTabListAlbum(),
    MyHomePage()
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          notificationService.showLocalNotification(
            id: 1,
            title: 'title',
            body: 'body',
            payload: 'payload',
          );
        },
        child: Icon(Icons.abc),
      ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            label: 'My Home',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: onTap,
      ),
    );
  }
}
