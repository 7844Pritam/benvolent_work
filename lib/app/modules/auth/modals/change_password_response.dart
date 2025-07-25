class ChangePasswordResponse {
  final bool success;
  final String message;
  ChangePasswordResponse({required this.success, required this.message});
  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) =>
      ChangePasswordResponse(
        success: json['success'] == 200,
        message: json['message'],
      );
}
