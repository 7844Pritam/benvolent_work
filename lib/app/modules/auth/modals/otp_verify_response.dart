class OTPVerifyResponse {
  final bool success;
  final String message;
  OTPVerifyResponse({required this.success, required this.message});
  factory OTPVerifyResponse.fromJson(Map<String, dynamic> json) =>
      OTPVerifyResponse(success: json['success'], message: json['message']);
}
