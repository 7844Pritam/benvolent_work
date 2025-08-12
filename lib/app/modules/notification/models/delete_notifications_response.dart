class DeleteNotificationsResponse {
  final int success;
  final String message;
  final List<String> data;

  DeleteNotificationsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DeleteNotificationsResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final list = (raw is List)
        ? raw
              .map((e) => (e ?? '').toString())
              .where((s) => s.isNotEmpty)
              .toList()
        : <String>[];
    return DeleteNotificationsResponse(
      success: (json['success'] ?? 0) is int
          ? json['success']
          : int.tryParse('${json['success']}') ?? 0,
      message: (json['message'] ?? '').toString(),
      data: list,
    );
  }
}
