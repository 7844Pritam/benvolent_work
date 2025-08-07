class CreateScheduleResponseModel {
  final bool success;
  final String message;
  final ScheduleData data;

  CreateScheduleResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateScheduleResponseModel(
      success: json['success'],
      message: json['message'],
      data: ScheduleData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class ScheduleData {
  final int leadId;
  final String scheduleDate;
  final String scheduleTime;
  final String planToDo;
  final String? comment;
  final int agentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;

  ScheduleData({
    required this.leadId,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.planToDo,
    this.comment,
    required this.agentId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory ScheduleData.fromJson(Map<String, dynamic> json) {
    return ScheduleData(
      leadId: json['lead_id'],
      scheduleDate: json['schedule_date'],
      scheduleTime: json['schedule_time'],
      planToDo: json['plan_to_do'],
      comment: json['comment'],
      agentId: json['agent_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lead_id': leadId,
      'schedule_date': scheduleDate,
      'schedule_time': scheduleTime,
      'plan_to_do': planToDo,
      'comment': comment,
      'agent_id': agentId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'id': id,
    };
  }
}
