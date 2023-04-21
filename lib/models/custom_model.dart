class CustomModel {
  final String? id;
  final String? fullName;
  final String? username;
  final String? role;
  final double? rating;
  final String? photoUri;
  final String? location;
  final String? bio;
  final int? phone;
  final int? idNumber;
  final bool? isEmailVerified;
  final bool? isPhoneVerified;

  CustomModel(
      {
        this.id,
        this.fullName,
        this.phone,
        this.idNumber,
        this.location,
        this.isEmailVerified,
        this.isPhoneVerified,
        this.rating,
        this.bio,
        this.role,
        this.photoUri,
        this.username,
      });

  toJson() {
    return {
      "FullName": fullName,
      "UserName": username,
      "Location": location,
      "isEmailVerified": isEmailVerified,
      "isPhoneVerified": isPhoneVerified,
      "Bio": bio,
      "Rating": rating,
      "IdNumber": idNumber,
      "Phone": phone,
      "PhotoURI": photoUri,
      "Role": role,
    };
  }
}
