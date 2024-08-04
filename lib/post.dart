import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String id;
  final String uid;
  final String title;
  final String description;
  final int likes;
  final int dislikes;
  final List<String> imageURLs;

  const Post({
    required this.id,
    required this.uid,
    required this.title,
    this.description = '',
    this.likes = 0,
    this.dislikes = 0,
    this.imageURLs = const []
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Post(
      id: doc.id,
      uid: data['uid'] ?? 'debug',
      title: data['title'] ?? 'Untitled',
      description: data['description'] ?? '',
      likes: data['likes'] ?? 0,
      dislikes: data['dislikes'] ?? 0,
      imageURLs: List<String>.from(data['images'] ?? []),
    );
  }
}