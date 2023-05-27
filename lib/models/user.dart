class User {
  final int id;
  final String name;
  final String noTelp;
  final String alamat;
  final String email;
  final String avatar;

  User({
    required this.id,
    required this.name,
    required this.noTelp,
    required this.alamat,
    required this.email,
    required this.avatar
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    noTelp: json["no_telp"] ?? '',
    alamat: json["alamat"] ?? '',
    email: json["email"] ?? '',
    avatar: json['avatar'] ?? ''
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "no_telp": noTelp,
    "alamat": alamat,
    "email": email,
    "avatar": avatar
  };
}