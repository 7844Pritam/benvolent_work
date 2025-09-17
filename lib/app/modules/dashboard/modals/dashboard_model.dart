class DashboardModel {
  final int success;
  final String message;
  final int coldCallCounts;
  final List<String> coldCallLabels;
  final List<int> coldCallData;
  final int coldCallConvertsCounts;
  final List<String> coldCallConvertLabels;
  final List<int> coldCallConvertData;
  final int leadsCounts;
  final List<String> leadsLabels;
  final List<int> leadsData;

  DashboardModel({
    required this.success,
    required this.message,
    required this.coldCallCounts,
    required this.coldCallLabels,
    required this.coldCallData,
    required this.coldCallConvertsCounts,
    required this.coldCallConvertLabels,
    required this.coldCallConvertData,
    required this.leadsCounts,
    required this.leadsLabels,
    required this.leadsData,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      coldCallCounts: json['cold_call_counts'] ?? 0,
      coldCallLabels: List<String>.from(json['cold_call_labels'] ?? []),
      coldCallData: List<int>.from(json['cold_call_data'] ?? []),
      coldCallConvertsCounts: json['cold_call_converts_counts'] ?? 0,
      coldCallConvertLabels: List<String>.from(
        json['cold_call_Convert_labels'] ?? [],
      ),
      coldCallConvertData: List<int>.from(json['cold_call_Convert_data'] ?? []),
      leadsCounts: json['leads_counts'] ?? 0,
      leadsLabels: List<String>.from(json['leads_labels'] ?? []),
      leadsData: List<int>.from(json['leads_data'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'cold_call_counts': coldCallCounts,
      'cold_call_labels': coldCallLabels,
      'cold_call_data': coldCallData,
      'cold_call_converts_counts': coldCallConvertsCounts,
      'cold_call_Convert_labels': coldCallConvertLabels,
      'cold_call_Convert_data': coldCallConvertData,
      'leads_counts': leadsCounts,
      'leads_labels': leadsLabels,
      'leads_data': leadsData,
    };
  }
}
