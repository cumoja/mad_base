class User {
  final String id;
  final String name;
  final String bio;
  final DateTime? date;

  User({required this.id, required this.name, required this.bio, this.date});

  factory User.fromJson(String id, Map<String, dynamic> data) {
    return User(id: id, name: data[_nameKey], bio: data[_bioKey]);
  }

  Map<String, dynamic> toJSON() {
    return {_nameKey: name, _bioKey: bio, _dateKey: date};
  }
}

const String _nameKey = "name";
const String _bioKey = "bio";
const String _dateKey = "date";
