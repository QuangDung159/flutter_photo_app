import 'package:flutter_photo_app/models/user.dart';

class Photo {
  final String _id;
  final String photoDesc;
  final String photoName;
  final String photoUrl;
  final String photoThumbnailUrl;
  final User photoCreatedBy;
  final String id;

  Photo(this._id, this.photoDesc, this.photoName, this.photoUrl,
      this.photoThumbnailUrl, this.photoCreatedBy, this.id);

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      json['_id'],
      json['photo_desc'],
      json['photo_name'],
      json['photo_url'],
      json['photo_thumbnail_url'],
      User.fromJson(
        json['photo_created_by'],
      ),
      json['_id'],
    );
  }
}
