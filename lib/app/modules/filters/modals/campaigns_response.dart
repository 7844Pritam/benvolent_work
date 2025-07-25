class CampaignsResponse {
  final int success;
  final String message;
  final List<Campaign> data;
  final String keyword;

  CampaignsResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.keyword,
  });

  factory CampaignsResponse.fromJson(Map<String, dynamic> json) {
    return CampaignsResponse(
      success: json['success'],
      message: json['message'],
      keyword: json['keyword'] ?? '',
      data: List<Campaign>.from(
        json['data'].map((item) => Campaign.fromJson(item)),
      ),
    );
  }
}

class Campaign {
  final int id;
  final String name;
  final int status;

  Campaign({required this.id, required this.name, required this.status});

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(id: json['id'], name: json['name'], status: json['status']);
  }
}
