class SourceRequest {
  final String compaignId;

  SourceRequest({required this.compaignId});

  Map<String, dynamic> toJson() {
    return {'compaign_id': compaignId};
  }
}
