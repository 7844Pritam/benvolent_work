/// Model classes for parsing notifications from the CRM API.

class NotificationResponse {
  final int success;
  final String message;
  final List<DeviceNotification> data;

  NotificationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final list = (raw is List)
        ? raw
              .where((e) => e is Map<String, dynamic>)
              .map<DeviceNotification>(
                (e) => DeviceNotification.fromJson(e as Map<String, dynamic>),
              )
              .toList()
        : <DeviceNotification>[];

    return NotificationResponse(
      success: (json['success'] ?? 0) is int
          ? json['success']
          : int.tryParse('${json['success']}') ?? 0,
      message: (json['message'] ?? '').toString(),
      data: list,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class DeviceNotification {
  final int id;
  final int agentId;
  final String title;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeviceNotification({
    required this.id,
    required this.agentId,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  static DateTime _parseDate(dynamic v) {
    if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
    final s = v.toString().replaceFirst(
      ' ',
      'T',
    ); // tolerate 'YYYY-MM-DD HH:mm:ss'
    return DateTime.tryParse(s) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  factory DeviceNotification.fromJson(Map<String, dynamic> json) {
    return DeviceNotification(
      id: (json['id'] ?? 0) is int
          ? json['id']
          : int.tryParse('${json['id']}') ?? 0,
      agentId: (json['agent_id'] ?? 0) is int
          ? json['agent_id']
          : int.tryParse('${json['agent_id']}') ?? 0,
      title: (json['title'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'agent_id': agentId,
    'title': title,
    'message': message,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
