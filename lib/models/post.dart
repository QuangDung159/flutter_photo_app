import 'package:flutter_photo_app/models/album.dart';
import 'package:flutter_photo_app/models/user.dart';

class Post {
  final String? id;
  final String? postTitle;
  final String? postContent;
  final String? postPanelImage;
  final String? postSummary;
  final bool? postStatus;
  final bool? postIsDeleted;
  final int? postLikes;
  final String? postCreatedAt;
  final String? postUpdatedAt;
  final AlbumModel? album;
  final User? postCreatedBy;

  Post({
    this.id,
    this.postTitle,
    this.postContent,
    this.postPanelImage,
    this.postSummary,
    this.postCreatedBy,
    this.postStatus,
    this.postIsDeleted,
    this.album,
    this.postLikes,
    this.postCreatedAt,
    this.postUpdatedAt,
  });

  factory Post.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Post();
    }
    return Post(
      id: json['_id'],
      postTitle: json['post_title'],
      postContent: json['post_content'],
      postPanelImage: json['post_panel_image'],
      postSummary: json['post_summary'],
      postStatus: json['post_status'],
      postIsDeleted: json['post_is_deleted'],
      postLikes: json['post_likes'],
      postCreatedAt: json['createdAt'],
      postUpdatedAt: json['updatedAt'],
      postCreatedBy: User.fromJson(json['post_created_by']),
      album: AlbumModel.fromJson(json['album']),
    );
  }
}
