import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_photo_app/common/constants.dart';
import 'package:flutter_photo_app/models/album.dart';
import 'package:http/http.dart' as http;

class HomeTabListAlbum extends StatefulWidget {
  const HomeTabListAlbum({super.key});

  @override
  State<HomeTabListAlbum> createState() => _HomeTabListAlbumState();
}

class _HomeTabListAlbumState extends State<HomeTabListAlbum> {
  @override
  void initState() {
    super.initState();
    listAlbum = fetchListAlbum();
  }

  late Future<List<AlbumModel>> listAlbum;

  Future<List<AlbumModel>> fetchListAlbum() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/album'));

      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body)['data']['albums'];
        List<AlbumModel> albums = List<AlbumModel>.from(
          l.map(
            (model) => AlbumModel.fromJson(model),
          ),
        );
        return albums;
      } else {
        throw Exception('Fail');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Widget renderChild(AlbumModel album) {
    return Text(album.albumDesc?.toString() ?? 'N/a');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<AlbumModel>>(
        future: fetchListAlbum(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Text(
                    data[index].albumDesc?.toString() ?? 'N/a',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          } else {
            if (snapshot.hasError) {
              {
                return const Text('Fail');
              }
            }
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
