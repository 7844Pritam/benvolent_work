class ColdCall {
  final int id;
  final String name;
  final String date;
  final String agent;
  final String phone;
  final String source;
  final String sourceName;
  final String status;
  final String statusName;

  ColdCall({
    required this.id,
    required this.name,
    required this.date,
    required this.agent,
    required this.phone,
    required this.source,
    required this.sourceName,
    required this.status,
    required this.statusName,
  });

  factory ColdCall.fromJson(Map<String, dynamic> json) {
    return ColdCall(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      agent: json['agent'] ?? '',
      phone: json['phone'] ?? '',
      source: json['source'] ?? '',
      sourceName: json['sourceName'] ?? '',
      status: json['status'] ?? '',
      statusName: json['statusName'] ?? '',
    );
  }
}

class ColdCallResponse {
  final int success;
  final int count;
  final String message;
  final int currentPage;
  final int lastPage;
  final List<ColdCall> data;

  ColdCallResponse({
    required this.success,
    required this.count,
    required this.message,
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory ColdCallResponse.fromJson(Map<String, dynamic> json) {
    final inner = json['data'] ?? {};
    final List<dynamic> list = inner['data'] ?? [];

    return ColdCallResponse(
      success: json['success'] ?? 0,
      count: json['count'] ?? 0,
      message: json['message'] ?? '',
      currentPage: inner['current_page'] ?? 1,
      lastPage: inner['last_page'] ?? 1,
      data: list.map((x) => ColdCall.fromJson(x)).toList(),
    );
  }
}

class StatusChangeResponse {
  final int success;
  final String message;

  StatusChangeResponse({required this.success, required this.message});

  factory StatusChangeResponse.fromJson(Map<String, dynamic> json) {
    return StatusChangeResponse(
      success: json['success'] ?? 0,
      message: json['message']?.toString() ?? '',
    );
  }
}

class ConvertedLeadData {
  final int id;
  final String leadId;
  final String name;
  final String email;
  final String phone;

  ConvertedLeadData({
    required this.id,
    required this.leadId,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory ConvertedLeadData.fromJson(Map<String, dynamic> json) {
    return ConvertedLeadData(
      id: json['id'] ?? 0,
      leadId: json['lead_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }
}

class ConvertToLeadResponse {
  final int success;
  final String message;
  final ConvertedLeadData? data;

  ConvertToLeadResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ConvertToLeadResponse.fromJson(Map<String, dynamic> json) {
    return ConvertToLeadResponse(
      success: json['success'] ?? 0,
      message: json['message']?.toString() ?? '',
      data: json['data'] == null
          ? null
          : ConvertedLeadData.fromJson(json['data']),
    );
  }
}
