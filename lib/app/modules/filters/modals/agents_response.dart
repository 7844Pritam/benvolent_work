// class AgentsResponse {
//   final int success;
//   final String message;
//   final Map<String, dynamic> data;

//   AgentsResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   factory AgentsResponse.fromJson(Map<String, dynamic> json) {
//     return AgentsResponse(
//       success: json['success'],
//       message: json['message'],
//       data: json['data'],
//     );
//   }
// }

// class GroupedAgentsResponse {
//   final int success;
//   final String message;
//   final String allLabel;
//   final List<AgentGroup> groups;

//   GroupedAgentsResponse({
//     required this.success,
//     required this.message,
//     required this.allLabel,
//     required this.groups,
//   });

//   factory GroupedAgentsResponse.fromJson(Map<String, dynamic> json) {
//     final Map<String, dynamic> data = json['data'];
//     final String allLabel = data[''] ?? 'All';

//     final List<AgentGroup> groups = [];
//     data.forEach((key, value) {
//       if (key.isNotEmpty && value is Map<String, dynamic>) {
//         groups.add(
//           AgentGroup(groupName: key, agents: Map<String, String>.from(value)),
//         );
//       }
//     });

//     return GroupedAgentsResponse(
//       success: json['success'],
//       message: json['message'],
//       allLabel: allLabel,
//       groups: groups,
//     );
//   }
// }

// class AgentGroup {
//   final String groupName;
//   final Map<String, String> agents;

//   AgentGroup({required this.groupName, required this.agents});
// }

class AgentsResponse {
  final int success;
  final String message;
  final List<AgentGroup> data;

  AgentsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AgentsResponse.fromJson(Map<String, dynamic> json) {
    final groups = <AgentGroup>[];
    if (json['data'] != null) {
      (json['data'] as Map<String, dynamic>).forEach((groupName, value) {
        if (value is Map<String, dynamic>) {
          groups.add(
            AgentGroup(
              groupName: groupName,
              agents: value.entries
                  .map(
                    (e) => Agent(
                      id: int.tryParse(e.key) ?? 0,
                      name: e.value.toString(),
                    ),
                  )
                  .toList(),
            ),
          );
        } else {
          // For "" : "All"
          groups.add(
            AgentGroup(
              groupName: groupName,
              agents: [Agent(id: 0, name: value.toString())],
            ),
          );
        }
      });
    }
    return AgentsResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data: groups,
    );
  }
}

class AgentGroup {
  final String groupName;
  final List<Agent> agents;

  AgentGroup({required this.groupName, required this.agents});
}

class Agent {
  final int id;
  final String name;

  Agent({required this.id, required this.name});
}
