import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo_app/common/constants.dart';
import 'package:flutter_photo_app/models/photo.dart';
import 'package:flutter_photo_app/screens/gallery_photo_view_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeTabGridPhoto extends StatefulWidget {
  const HomeTabGridPhoto({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeTabGridPhoto> createState() => _HomeTabGridPhotoState();
}

class _HomeTabGridPhotoState extends State<HomeTabGridPhoto> {
  late Future<List<Photo>> listPhoto;
  late List<Photo> list = [];

  @override
  void initState() {
    super.initState();
    listPhoto = fetchListPhoto();
  }

  Future<List<Photo>> fetchListPhoto() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/photo'));

      if (res.statusCode == 200) {
        Iterable l = json.decode(res.body)['data']['photos'];
        List<Photo> listPhoto = List<Photo>.from(
          l.map(
            (model) => Photo.fromJson(model),
          ),
        );
        return listPhoto;
      } else {
        throw Exception('Fail to fetch list photo');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void open(BuildContext context, final int index, List<Photo> listPhoto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewScreen(
          listPhoto: listPhoto,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    const double crossAxisSpacing = 3;
    double imageWidth = (screenWidth - crossAxisSpacing * 3) / 3;

    return FutureBuilder(
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return GridView.builder(
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: crossAxisSpacing,
            ),
            itemBuilder: (context, index) {
              return renderImageItem(data, index, context, imageWidth);
            },
          );
        } else {
          if (snapshot.hasError) {
            {
              return const Center(
                child: Text(
                  'Fail',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          }
          return const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          );
        }
      }),
      future: listPhoto,
    );
  }

  Hero renderImageItem(
      List<Photo> data, int index, BuildContext context, double imageWidth) {
    return Hero(
      transitionOnUserGestures: true,
      tag: data[index].id,
      child: GestureDetector(
        onTap: () {
          open(context, index, data);
        },
        child: CachedNetworkImage(
          imageUrl: data[index].photoUrl,
          placeholder: (context, url) => const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.error,
            color: Colors.white,
          ),
          imageBuilder: (context, imageProvider) => Container(
            width: imageWidth,
            height: imageWidth,
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
