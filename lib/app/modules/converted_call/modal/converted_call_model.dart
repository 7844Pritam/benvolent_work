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
      id: json['id'],
      createdDate: json['createdDate'],
      assignedDate: json['assignedDate'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      status: json['status'],
      campaign: json['campaign'],
      source: json['source'],
      userId: json['userId'],
      isAccepted: json['isAccepted'],
      agent: json['agent'],
    );
  }
}

class ConvertedCallResponse {
  final int currentPage;
  final int lastPage;
  final List<ConvertedCall> data;

  ConvertedCallResponse({
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory ConvertedCallResponse.fromJson(Map<String, dynamic> json) {
    final innerData = json['data'] as Map<String, dynamic>;
    return ConvertedCallResponse(
      currentPage: innerData['current_page'],
      lastPage: innerData['last_page'],
      data: List<ConvertedCall>.from(
        (innerData['data'] as List).map((x) => ConvertedCall.fromJson(x)),
      ),
    );
  }
}
