class SubStatusResponse {
  final int success;
  final String message;
  final List<SubStatus> data;

  SubStatusResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SubStatusResponse.fromJson(Map<String, dynamic> json) {
    return SubStatusResponse(
      success: json['success'],
      message: json['message'],
      data: List<SubStatus>.from(
        json['data'].map((x) => SubStatus.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class SubStatus {
  final int id;
  final int statusId;
  final String subName;
  final String createdAt;
  final String updatedAt;

  SubStatus({
    required this.id,
    required this.statusId,
    required this.subName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubStatus.fromJson(Map<String, dynamic> json) {
    return SubStatus(
      id: json['id'],
      statusId: json['status_id'],
      subName: json['sub_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status_id': statusId,
      'sub_name': subName,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
