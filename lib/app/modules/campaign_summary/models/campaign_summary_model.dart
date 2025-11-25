class CampaignSummaryModel {
  String? statusName;
  int? noOfLeads;
  String? colorCode;

  CampaignSummaryModel({this.statusName, this.noOfLeads, this.colorCode});

  CampaignSummaryModel.fromJson(Map<String, dynamic> json) {
    statusName = json['status_name'];
    noOfLeads = json['no_of_leads'];
    colorCode = json['color_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_name'] = statusName;
    data['no_of_leads'] = noOfLeads;
    data['color_code'] = colorCode;
    return data;
  }
}

class CampaignSummaryResponse {
  int? success;
  String? message;
  List<CampaignSummaryModel>? data;

  CampaignSummaryResponse({this.success, this.message, this.data});

  CampaignSummaryResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CampaignSummaryModel>[];
      json['data'].forEach((v) {
        data!.add(CampaignSummaryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
