class ColdCall {
  final int id;
  final String name;
  final String date;
  final String agent;
  final String phone;
  final String source;
  final String status;

  ColdCall({
    required this.id,
    required this.name,
    required this.date,
    required this.agent,
    required this.phone,
    required this.source,
    required this.status,
  });

  factory ColdCall.fromJson(Map<String, dynamic> json) {
    return ColdCall(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      agent: json['agent'] ?? '',
      phone: json['phone'] ?? '',
      source: json['source'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class ColdCallResponse {
  final int currentPage;
  final List<ColdCall> data;
  final int lastPage;

  ColdCallResponse({
    required this.currentPage,
    required this.data,
    required this.lastPage,
  });

  factory ColdCallResponse.fromJson(Map<String, dynamic> json) {
    final inner = json['data'] ?? {};
    final List<dynamic> list = inner['data'] ?? [];

    return ColdCallResponse(
      currentPage: inner['current_page'] ?? 1,
      lastPage: inner['last_page'] ?? 1,
      data: list.map((x) => ColdCall.fromJson(x)).toList(),
    );
  }
}
