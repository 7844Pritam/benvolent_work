class AddNoteResponse {
  final int success;
  final String message;
  final NoteData data;

  AddNoteResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AddNoteResponse.fromJson(Map<String, dynamic> json) {
    return AddNoteResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data: NoteData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class NoteData {
  final int leadId;
  final int agentId;
  final String date;
  final String time;
  final String newComments;
  final String updatedAt;
  final String createdAt;
  final int id;

  NoteData({
    required this.leadId,
    required this.agentId,
    required this.date,
    required this.time,
    required this.newComments,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory NoteData.fromJson(Map<String, dynamic> json) {
    return NoteData(
      leadId: json['lead_id'] ?? 0,
      agentId: json['agent_id'] ?? 0,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      newComments: json['new_comments'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lead_id': leadId,
      'agent_id': agentId,
      'date': date,
      'time': time,
      'new_comments': newComments,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}
