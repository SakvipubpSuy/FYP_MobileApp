class UserModel {
  final int id;
  final String name;
  final String email;
  final int energy;
  final String profilePhotoUrl;
  final String? profilePhotoPath;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.energy,
    required this.profilePhotoUrl,
    required this.profilePhotoPath,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      energy: json['energy'],
      profilePhotoUrl: json['profile_photo_url'],
      profilePhotoPath: json['profile_photo_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'energy': energy,
      'profile_photo_url': profilePhotoUrl,
      'profile_photo_path': profilePhotoPath,
    };
  }
}
