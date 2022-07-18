import 'package:create_social/models/post.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteService {
  late Future<Database> _db;
  SQLiteService() {
    _initDB();
  }

  void _initDB() async {
    _db = openDatabase(join(await getDatabasesPath(), "create_social.db"),
        onCreate: ((db, version) {
      db.execute(
          "CREATE TABLE posts (id TEXT PRIMARY KEY,content TEXT,type INTEGER,createdAt DATETIME, creator TEXT)");
    }), version: 1);
  }

  Future<List<Post>> readPost() async {
    List<Post> posts = [];
    Database db = await _db;
    var result = await db.query("post");
    for (var post in result) {
      posts.add(Post.fromJson(post["id"] as String, post));
    }
    return posts;
  }

  Future<void> updatePost(Post post) async {
    Database db = await _db;
    db.update("post", post.toJSON(), where: 'id=?', whereArgs: [post.id]);
  }

  Future<void> deletePost(Post post) async {
    Database db = await _db;
    db.delete("post", where: 'id=?', whereArgs: [post.id]);
  }

  Future<void> createPost(Post post) async {
    Database db = await _db;
    db.insert("post", post.toJSON());
  }
}
