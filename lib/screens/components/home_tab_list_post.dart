// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo_app/common/constants.dart';
import 'package:flutter_photo_app/models/post.dart';
import 'package:flutter_photo_app/screens/post_detail_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeTabListPost extends StatefulWidget {
  const HomeTabListPost({super.key});

  @override
  State<HomeTabListPost> createState() => _HomeTabListPostState();
}

class _HomeTabListPostState extends State<HomeTabListPost> {
  late Future<List<Post>> futureListPost;

  @override
  void initState() {
    super.initState();
    futureListPost = fetchListPost();
  }

  Future<List<Post>> fetchListPost() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/post'));
      if (res.statusCode == 200) {
        Iterable l = json.decode(res.body)['data']['posts'];
        List<Post> listPhoto = List<Post>.from(
          l.map(
            (model) {
              return Post.fromJson(model);
            },
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

  List<Widget> renderListPost(List<Post> listPost) {
    String defaultImageUrl =
        'https://lh3.googleusercontent.com/ihDtoi-0gYynl_GD0nSAzVmdWojAO3E-B6YOxMncFSdg4rizOTKTuMEPlWbsdeB94tc04y9udAZd31v_stLeXG_s63VnSvSk6bMAvakxG_H0cQDtWDBUkOsX-voHFSE7IYMyV8FdLrf1keo-2m4iY2jTOFrFKyjOz9D-cauzMsnWKv_pGfR2clYqSzFlpdf1rYfJq7EsBTpFC_vk_1KCUWlWhcb4Xn0tLHtiyO9SeHHE8USY-5d6Ch_q3lU2aQNb-I075KEs9lHuLrU9za_41qU7DKpeAH4WYE9pQ8NptODqj0Pue556n_4AggvbTtfuxtub69uvpwZ2DZtm-heohZ9T_ctcsYX3mwosoVIbRdy3bXM1j_W80ezrbfEF2Gz1v6d3clZt5PVF6ukVgLMQa3enuaiLIvNH0fAzib5QV_vwhlxs87DK-S9OpWGlUKjtqzj6mplTJn1bS-_PIw8oqg5u2oxayz9A8S-EVrA6pM5USnCNyl56-Uu8pUgv9yGTERlcoQX7jkDcVfkMAlgs98wPXmY1gLhcl-RwUPEtnndTYCPtbJPFdzmu94kksPHKECcFl-PTNhG5vRGoa2q97pWiGG2cdYKzHosYv6yBxxiWG9-xcAgNhPiCTTo4zaNl5oDD4KPTx98EpBoaazkV57d7umsxI0l3cIZG_VvvCs3yBsqTM1opMvSVOEoFYIcqCmie1LHBwxwOEK8n0oAPv_TqOmsvTGnpvViz7j3BPEkLJnA5nX470A=w1150-h1532-no';
    return listPost
        .mapIndexed(
          (index, item) => GestureDetector(
            onTap: () {
              Get.to(() => PostDetailScreen(), arguments: item);
            },
            child: Container(
              padding: EdgeInsets.only(
                  bottom: index != listPost.length - 1 ? 20 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: item.postPanelImage ?? defaultImageUrl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      width: Get.width,
                      height: 200,
                      decoration: BoxDecoration(
                        // shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.postTitle?.toString() ?? 'N/a',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            item.postSummary?.toString() ?? 'N/a',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: futureListPost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return Column(
                children: renderListPost(data),
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
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
