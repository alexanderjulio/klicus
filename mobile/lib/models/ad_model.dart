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
    return AdModel(
      id: json['id']?.toString() ?? '',
      ownerId: json['owner_id']?.toString() ?? '',
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? '',
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      priorityLevel: json['priority_level'] ?? 'basic',
      location: json['location'] ?? 'Ubicación no disponible',
      categoryName: json['category_name'] ?? 'General',
      categorySlug: json['category_slug'] ?? 'general',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      phone: json['phone'],
      cellphone: json['cellphone'],
      email: json['email'],
      websiteUrl: json['website_url'],
      facebookUrl: json['facebook_url'],
      instagramUrl: json['instagram_url'],
      businessHours: json['business_hours'],
      address: json['address'],
      priceRange: json['price_range'],
      deliveryInfo: json['delivery_info'],
      ownerName: json['owner_name'],
    );
  }

  String get firstImage => imageUrls.isNotEmpty ? imageUrls.first : 'https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=1000&auto=format&fit=crop';
}
