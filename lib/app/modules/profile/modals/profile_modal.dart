class ProfileResponse {
  final int success;
  final String message;
  final Profile? data;

  ProfileResponse({required this.success, required this.message, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? Profile.fromJson(json['data']) : null,
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
    this.dob,
    required this.phone,
    this.atContact,
    this.address,
    required this.availability,
    required this.imageUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      dob: json['dob']?.toString(),
      phone: json['phone']?.toString() ?? '',
      atContact: json['at_contact']?.toString(),
      address: json['address']?.toString(),
      availability: json['availability'] ?? 'Unavailable',
      imageUrl: json['user_profile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "dob": dob ?? '',
      "phone": phone,
      "at_contact": atContact ?? '',
      "address": address ?? '',
      "availability": availability,
      "user_profile": imageUrl,
    };
  }

  Profile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? dob,
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
      dob: dob ?? this.dob,
      phone: phone ?? this.phone,
      atContact: atContact ?? this.atContact,
      address: address ?? this.address,
      availability: availability ?? this.availability,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
