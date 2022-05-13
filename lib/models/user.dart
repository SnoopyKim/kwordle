class User {
  String uid;
  String email;
  String name;
  int five;
  int six;
  int seven;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.five,
    required this.six,
    required this.seven,
  });

  factory User.fromMap(Map<dynamic, dynamic> map) => User(
        uid: map['uid'] ?? "",
        email: map['email'] ?? "",
        name: map['name'] ?? "",
        five: map['five'] ?? 0,
        six: map['five'] ?? 0,
        seven: map['five'] ?? 0,
      );

  factory User.empty() => User(
        uid: "",
        email: "",
        name: "",
        five: 0,
        six: 0,
        seven: 0,
      );

  factory User.register({required String email, required String name}) =>
      User(uid: "", email: email, name: name, five: 0, six: 0, seven: 0);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (uid.isNotEmpty) {
      map['uid'] = uid;
    }
    map['email'] = email;
    map['name'] = name;
    map['five'] = five;
    map['six'] = six;
    map['seven'] = seven;
    return map;
  }
}
