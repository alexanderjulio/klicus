import 'dart:convert';

class AdModel {
  final String id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String priorityLevel;
  final String ownerId;
  final String location;
  final String categoryName;
  final String categorySlug;
  final DateTime createdAt;
  
  // Extended Fields for Elite Detail View
  final String? phone;
  final String? cellphone;
  final String? email;
  final String? websiteUrl;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? businessHours;
  final String? address;
  final String? priceRange;
  final String? deliveryInfo;
  final String? ownerName;

  AdModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.priorityLevel,
    required this.location,
    required this.categoryName,
    required this.categorySlug,
    required this.createdAt,
    this.phone,
    this.cellphone,
    this.email,
    this.websiteUrl,
    this.facebookUrl,
    this.instagramUrl,
    this.businessHours,
    this.address,
    this.priceRange,
    this.deliveryInfo,
    this.ownerName,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    // Robust parsing for image_urls (can be List or JSON String)
    List<String> parsedImages = [];
    var rawImages = json['image_urls'];
    if (rawImages is List) {
      parsedImages = rawImages.map((e) => e.toString()).toList();
    } else if (rawImages is String && rawImages.isNotEmpty) {
      try {
        // Fallback for cases where DB returns raw JSON string
        var decoded = jsonDecode(rawImages);
        if (decoded is List) {
          parsedImages = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    return AdModel(
      id: json['id']?.toString() ?? '',
      ownerId: json['owner_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción disponible',
      imageUrls: parsedImages,
      priorityLevel: json['priority_level'] ?? 'basic',
      location: json['location'] ?? 'Ubicación no disponible',
      categoryName: json['category_name'] ?? 'General',
      categorySlug: json['category_slug'] ?? 'general',
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      phone: json['phone']?.toString(),
      cellphone: json['cellphone']?.toString(),
      email: json['email']?.toString(),
      websiteUrl: json['website_url']?.toString(),
      facebookUrl: json['facebook_url']?.toString(),
      instagramUrl: json['instagram_url']?.toString(),
      businessHours: json['business_hours']?.toString(),
      address: json['address']?.toString(),
      priceRange: json['price_range']?.toString(),
      deliveryInfo: json['delivery_info']?.toString(),
      ownerName: json['owner_name']?.toString(),
    );
  }

  String get firstImage => imageUrls.isNotEmpty ? imageUrls.first : 'https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=1000&auto=format&fit=crop';
}
