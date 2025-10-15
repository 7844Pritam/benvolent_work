class SignupResponse {
  final bool success;
  final String message;

  SignupResponse({required this.success, required this.message});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    // Convert numeric 200/400 to bool
    bool isSuccess = false;
    if (json['success'] is int) {
      isSuccess = json['success'] == 200;
    } else if (json['success'] is bool) {
      isSuccess = json['success'];
    }

    return SignupResponse(success: isSuccess, message: json['message'] ?? '');
  }
}
