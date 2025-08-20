class ConvertedCall {
  final int id;
  final String createdDate;
  final String assignedDate;
  final String name;
  final String email;
  final String phone;
  final String status;
  final String campaign;
  final String source;
  final int userId;
  final int isAccepted;
  final String agent;

  ConvertedCall({
    required this.id,
    required this.createdDate,
    required this.assignedDate,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.campaign,
    required this.source,
    required this.userId,
    required this.isAccepted,
    required this.agent,
  });

  factory ConvertedCall.fromJson(Map<String, dynamic> json) {
    return ConvertedCall(
      id: json['id'] ?? 0,
      createdDate: json['createdDate'] ?? '',
      assignedDate: json['assignedDate'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? '',
      campaign: json['campaign'] ?? '',
      source: json['source'] ?? '',
      userId: json['userId'] ?? 0,
      isAccepted: json['isAccepted'] ?? 0,
      agent: json['agent'] ?? '',
    );
  }
}

class ConvertedCallResponse {
  final int currentPage;
  final int lastPage;
  final int total;
  final List<ConvertedCall> data;

  ConvertedCallResponse({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.data,
  });

  factory ConvertedCallResponse.fromJson(Map<String, dynamic> json) {
    final innerData = json['data'] as Map<String, dynamic>;
    return ConvertedCallResponse(
      currentPage: innerData['current_page'] ?? 1,
      lastPage: innerData['last_page'] ?? 1,
      total: innerData['total'] ?? 0,
      data: List<ConvertedCall>.from(
        (innerData['data'] as List).map((x) => ConvertedCall.fromJson(x)),
      ),
    );
  }
}

class ConvertedCallApiResponse {
  final int success;
  final int count;
  final ConvertedCallResponse response;
  final String message;

  ConvertedCallApiResponse({
    required this.success,
    required this.count,
    required this.response,
    required this.message,
  });

  factory ConvertedCallApiResponse.fromJson(Map<String, dynamic> json) {
    return ConvertedCallApiResponse(
      success: json['success'] ?? 0,
      count: json['count'] ?? 0,
      response: ConvertedCallResponse.fromJson(json['data']),
      message: json['message'] ?? '',
    );
  }
}
