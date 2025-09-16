class DashboardModel {
  final int success;
  final String message;
  final int coldCallCounts;
  final int coldCallConvertsCounts;
  final int leadsCounts;

  DashboardModel({
    required this.success,
    required this.message,
    required this.coldCallCounts,
    required this.coldCallConvertsCounts,
    required this.leadsCounts,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      coldCallCounts: json['cold_call_counts'] ?? 0,
      coldCallConvertsCounts: json['cold_call_converts_counts'] ?? 0,
      leadsCounts: json['leads_counts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'cold_call_counts': coldCallCounts,
      'cold_call_converts_counts': coldCallConvertsCounts,
      'leads_counts': leadsCounts,
    };
  }
}

// class DashboardModel {
//   final int success;
//   final int totColdCall;
//   final int totLeads;
//   final int totProperties;
//   final List<FeaturedProperty> featuredProperties;
//   final String message;

//   DashboardModel({
//     required this.success,
//     required this.totColdCall,
//     required this.totLeads,
//     required this.totProperties,
//     required this.featuredProperties,
//     required this.message,
//   });

//   factory DashboardModel.fromJson(Map<String, dynamic> json) {
//     return DashboardModel(
//       success: json['success'],
//       totColdCall: json['tot_cold_call'],
//       totLeads: json['tot_leads'],
//       totProperties: json['tot_properties'],
//       featuredProperties: (json['featured_properties'] as List)
//           .map((e) => FeaturedProperty.fromJson(e))
//           .toList(),
//       message: json['message'],
//     );
//   }
// }

// class FeaturedProperty {
//   final int id;
//   final String name;
//   final String slug;
//   final String? description;
//   final int cityId;
//   final String? address;
//   final String? latitude;
//   final String? longitude;
//   final String? meta;
//   final String? source;
//   final int developerId;
//   final String? status;
//   final String budget;
//   final String image;
//   final String featuredProperty;
//   final String? brochure;
//   final String createdAt;
//   final String updatedAt;
//   final List<dynamic> ameneties;
//   final Developer developer;
//   final City city;

//   FeaturedProperty({
//     required this.id,
//     required this.name,
//     required this.slug,
//     this.description,
//     required this.cityId,
//     this.address,
//     this.latitude,
//     this.longitude,
//     this.meta,
//     this.source,
//     required this.developerId,
//     this.status,
//     required this.budget,
//     required this.image,
//     required this.featuredProperty,
//     this.brochure,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.ameneties,
//     required this.developer,
//     required this.city,
//   });

//   factory FeaturedProperty.fromJson(Map<String, dynamic> json) {
//     return FeaturedProperty(
//       id: json['id'],
//       name: json['name'],
//       slug: json['slug'],
//       description: json['description'],
//       cityId: json['city_id'],
//       address: json['address'],
//       latitude: json['latitude'],
//       longitude: json['longitude'],
//       meta: json['meta'],
//       source: json['source'],
//       developerId: json['developer_id'],
//       status: json['status'],
//       budget: json['budget'],
//       image: json['image'],
//       featuredProperty: json['featured_property'],
//       brochure: json['brochure'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//       ameneties: json['ameneties'] ?? [],
//       developer: Developer.fromJson(json['developer']),
//       city: City.fromJson(json['city']),
//     );
//   }
// }

// class Developer {
//   final int id;
//   final String name;
//   final String phone;
//   final String? email;
//   final String address;
//   final String? meta;
//   final String? source;
//   final String createdAt;
//   final String updatedAt;

//   Developer({
//     required this.id,
//     required this.name,
//     required this.phone,
//     this.email,
//     required this.address,
//     this.meta,
//     this.source,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Developer.fromJson(Map<String, dynamic> json) {
//     return Developer(
//       id: json['id'],
//       name: json['name'],
//       phone: json['phone'],
//       email: json['email'],
//       address: json['address'],
//       meta: json['meta'],
//       source: json['source'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//     );
//   }
// }

// class City {
//   final int id;
//   final String name;
//   final String createdAt;
//   final String updatedAt;

//   City({
//     required this.id,
//     required this.name,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory City.fromJson(Map<String, dynamic> json) {
//     return City(
//       id: json['id'],
//       name: json['name'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//     );
//   }
// }
