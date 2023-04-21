class ProfileModel {
  final String? id;
  final String? fullName;
  final String? role;
  final String? bio;
  final String email;
  final int? phone;

  ProfileModel(
      {
        this.id,
        this.fullName,
        this.phone,
        this.role,
        this.bio,
        required this.email,
      });

  toJson() {
    return {
      "FullName": fullName,
      "Email": email,
      "Phone": phone,
      "Bio": bio,
      "Role": role,
    };
  }
}
