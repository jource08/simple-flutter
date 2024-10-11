class User {
  int? id;
  String? username;
  String? email;
  String? fullname;
  String? bio;
  String? profileImageUrl;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.fullname,
      this.bio,
      this.profileImageUrl});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    fullname = json['fullname'];
    bio = json['bio'];
    profileImageUrl = json['profile_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['fullname'] = fullname;
    data['bio'] = bio;
    data['profile_image_url'] = profileImageUrl;
    return data;
  }
}
