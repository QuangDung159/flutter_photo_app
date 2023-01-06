import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo_app/common/constants.dart';
import 'package:flutter_photo_app/models/photo.dart';
import 'package:flutter_photo_app/screens/components/main_app_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoViewScreen extends StatefulWidget {
  GalleryPhotoViewScreen({
    super.key,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    this.listPhoto,
    this.scrollDirection = Axis.vertical,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final Axis scrollDirection;
  final List<Photo>? listPhoto;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewScreenState();
  }
}

class _GalleryPhotoViewScreenState extends State<GalleryPhotoViewScreen> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(contentAppBarHeight),
          child: MainAppBar(
            hasBack: true,
          )),
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            GestureDetector(
              onVerticalDragEnd: (details) => Navigator.pop(context),
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.listPhoto?.length ?? 0,
                loadingBuilder: widget.loadingBuilder,
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
                scrollDirection: widget.scrollDirection,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                widget.listPhoto![currentIndex].photoName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  decoration: null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final Photo photo = widget.listPhoto![index];
    return PhotoViewGalleryPageOptions(
      imageProvider: CachedNetworkImageProvider(photo.photoUrl),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: photo.id),
    );
  }
}
