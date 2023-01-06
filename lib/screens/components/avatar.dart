import 'package:flutter/material.dart';
import 'package:flutter_photo_app/services/google_services.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    required this.googleInfo,
  }) : super(key: key);

  final GoogleInfo googleInfo;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(googleInfo.photoUrl.value),
    );
  }
}