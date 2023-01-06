// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_photo_app/common/constants.dart';
import 'package:flutter_photo_app/models/post.dart';
import 'package:flutter_photo_app/screens/components/main_app_bar.dart';
import 'package:get/get.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Post postDetail = Get.arguments;
    return Scaffold(
      backgroundColor: primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(contentAppBarHeight),
        child: MainAppBar(
          hasBack: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                postDetail.postTitle.toString(),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Html(
              data: postDetail.postContent.toString(),
              style: {
                'p': Style(
                    color: Colors.grey,
                    fontSize: FontSize(14),
                    margin: EdgeInsets.only(bottom: 30)),
                'figcaption': Style(
                    fontSize: FontSize(12),
                    color: Colors.grey,
                    margin: EdgeInsets.only(top: 20),
                    textAlign: TextAlign.center)
              },
            ),
          ],
        ),
      ),
    );
  }
}
