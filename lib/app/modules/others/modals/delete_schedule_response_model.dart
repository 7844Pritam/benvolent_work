class DeleteScheduleResponseModel {
  final bool success;
  final String message;
  final List<dynamic> data;

  DeleteScheduleResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DeleteScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteScheduleResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data};
  }
}
