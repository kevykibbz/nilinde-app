class UserModel {
  final String? id;
  final String? fullName;
  final String? role;
  final String? location;
  final String? photoUri;
  final bool? client;
  final bool? employee;
  final int? phone;
  final List indexKey;
  final String email;
  final String? bio;
  final String password;

  UserModel(
      {this.id,
      this.fullName,
      this.phone,
      this.bio,
      this.client = false,
      this.employee = false,
      this.location,
      this.role,
      this.photoUri,
      required this.indexKey,
      required this.email,
      required this.password});

  toJson() {
    return {
      "FullName": fullName,
      "Location": location,
      "Client": client,
      "Employee": employee,
      "IndexKey":indexKey,
      "Bio": bio,
      "Email": email,
      "Phone": phone,
      "PhotoURI": photoUri,
      "Role": role,
      "Password": password,
    };
  }
}
