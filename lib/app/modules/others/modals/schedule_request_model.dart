class ScheduleRequestModel {
  final int leadId;
  final String scheduleDate;
  final String scheduleTime;
  final String planToDo;
  final String comment;

  ScheduleRequestModel({
    required this.leadId,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.planToDo,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'lead_id': leadId,
      'schedule_date': scheduleDate,
      'schedule_time': scheduleTime,
      'plan_to_do': planToDo,
      'comment': comment,
    };
  }
}
