class LeadStatusResponse {
  final int success;
  final String message;
  final List<LeadStatus> data;

  LeadStatusResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LeadStatusResponse.fromJson(Map<String, dynamic> json) {
    return LeadStatusResponse(
      success: json['success'],
      message: json['message'],
      data: List<LeadStatus>.from(
        json['data'].map((item) => LeadStatus.fromJson(item)),
      ),
    );
  }
}

class LeadStatus {
  final int id;
  final String name;
  final int? statusOrder;
  final String color;
  final int isDefault;
  final String approveStatus;
  final int? superStatusId;
  final String createdAt;
  final String updatedAt;

  LeadStatus({
    required this.id,
    required this.name,
    required this.statusOrder,
    required this.color,
    required this.isDefault,
    required this.approveStatus,
    required this.superStatusId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeadStatus.fromJson(Map<String, dynamic> json) {
    return LeadStatus(
      id: json['id'],
      name: json['name'],
      statusOrder: json['statusorder'],
      color: json['color'],
      isDefault: json['isdefault'],
      approveStatus: json['approve_status'],
      superStatusId: json['super_status_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
