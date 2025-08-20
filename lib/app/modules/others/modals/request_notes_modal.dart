class RequestNotesModal {
  final int leadId;
  final String newComments;

  RequestNotesModal({required this.leadId, required this.newComments});

  factory RequestNotesModal.fromjson(Map<String, dynamic> json) {
    return RequestNotesModal(
      leadId: json['lead_id'],
      newComments: json['new_comments'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'lead_id': leadId, 'new_comments': newComments};
  }
}
