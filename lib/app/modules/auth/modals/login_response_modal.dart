class LoginResponseModel {
  final int success;
  final String message;
  final LoginResult? results;

  LoginResponseModel({
    required this.success,
    required this.message,
    this.results,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      results: json['results'] != null
          ? LoginResult.fromJson(json['results'])
          : null,
    );
  }
}

class LoginResult {
  final String token;
  final String tokenType;
  final String expiresAt;
  final String role;
  final UserData? data;

  LoginResult({
    required this.token,
    required this.tokenType,
    required this.expiresAt,
    required this.role,
    this.data,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? '',
      expiresAt: json['expires_at'] ?? '',
      role: json['role'] ?? '',
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final String firstName;
  final String lastName;
  final String email;
  final String? dob;
  final String? atContact;
  final String? address;
  final String userProfile;
  final dynamic phone;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.dob,
    this.atContact,
    this.address,
    required this.userProfile,
    this.phone,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      dob: json['dob'],
      atContact: json['at_contact'],
      address: json['address'],
      userProfile: json['user_profile'] ?? '',
      phone: json['phone'],
    );
  }
}
