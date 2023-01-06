import 'package:flutter_photo_app/models/user.dart';

class AlbumModel {
  final String? id;
  final String? albumDesc;
  final String? albumName;
  final bool? albumStatus;
  final bool? albumIsDeleted;
  final String? createdAt;
  final String? updatedAt;
  final User? albumCreatedBy;

  AlbumModel({
    this.id,
    this.albumDesc,
    this.albumName,
    this.albumStatus,
    this.albumIsDeleted,
    this.createdAt,
    this.updatedAt,
    this.albumCreatedBy,
  });

  factory AlbumModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AlbumModel();
    }
    return AlbumModel(
      id: json['_id'],
      albumDesc: json['album_desc'],
      albumName: json['album_name'],
      albumStatus: json['album_status'],
      albumIsDeleted: json['album_is_deleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      albumCreatedBy: User.fromJson(
        json['album_created_by'],
      ),
    );
  }
}
