class SourceResponse {
  final int success;
  final String message;
  final List<SourceData> data;

  SourceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SourceResponse.fromJson(Map<String, dynamic> json) {
    return SourceResponse(
      success: json['success'],
      message: json['message'],
      data: List<SourceData>.from(
        json['data'].map((item) => SourceData.fromJson(item)),
      ),
    );
  }
}

class SourceData {
  final int id;
  final String name;
  final int status;
  final String type;
  final String startDate;
  final String endDate;
  final int compaignId;
  final int isCrored;
  final int runAllTime;
  final String createdAt;
  final String updatedAt;

  SourceData({
    required this.id,
    required this.name,
    required this.status,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.compaignId,
    required this.isCrored,
    required this.runAllTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SourceData.fromJson(Map<String, dynamic> json) {
    return SourceData(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      type: json['type'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      compaignId: json['compaign_id'],
      isCrored: json['is_croned'],
      runAllTime: json['run_all_time'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
