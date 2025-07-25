class ProfileResponse {
  final int success;
  final String message;
  final Profile data;

  ProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'],
      message: json['message'],
      data: Profile.fromJson(json['data']),
    );
  }
}

class Profile {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? dob;
  final String phone;
  final String? atContact;
  final String? address;
  String availability;
  final String imageUrl;

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dob,
    required this.phone,
    required this.atContact,
    required this.address,
    required this.availability,
    required this.imageUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      dob: json['dob'],
      phone: json['phone'].toString(),
      atContact: json['at_contact'],
      address: json['address'],
      availability: json['availability'],
      imageUrl: json['user_profile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "dob": dob,
      "phone": phone,
      "at_contact": atContact,
      "address": address,
      "user_profile": imageUrl,
    };
  }

  Profile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? atContact,
    String? address,
    String? availability,
    String? imageUrl,
  }) {
    return Profile(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      dob: dob,
      phone: phone ?? this.phone,
      atContact: atContact ?? this.atContact,
      address: address ?? this.address,
      availability: availability ?? this.availability,
      imageUrl: imageUrl ?? "",
    );
  }
}
