class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String imageUrl;
  final int itemCount;
  final int colorIndex;
  final List<String> subCategories;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.imageUrl,
    required this.itemCount,
    required this.colorIndex,
    this.subCategories = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String,
        imageUrl: json['imageUrl'] as String,
        itemCount: json['itemCount'] as int,
        colorIndex: json['colorIndex'] as int? ?? 0,
        subCategories: (json['subCategories'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );
}

class VendorModel {
  final String id;
  final String name;
  final String logo;
  final String banner;
  final double rating;
  final int reviewCount;
  final int deliveryTimeMins;
  final double distanceKm;
  final double minOrder;
  final String category;
  final List<String> tags;
  final bool isFeatured;
  final bool isTrending;
  final String offer;

  const VendorModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.banner,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTimeMins,
    required this.distanceKm,
    required this.minOrder,
    required this.category,
    this.tags = const [],
    this.isFeatured = false,
    this.isTrending = false,
    this.offer = '',
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        id: json['id'] as String,
        name: json['name'] as String,
        logo: json['logo'] as String,
        banner: json['banner'] as String,
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
        deliveryTimeMins: json['deliveryTimeMins'] as int,
        distanceKm: (json['distanceKm'] as num).toDouble(),
        minOrder: (json['minOrder'] as num).toDouble(),
        category: json['category'] as String,
        tags: (json['tags'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        isFeatured: json['isFeatured'] as bool? ?? false,
        isTrending: json['isTrending'] as bool? ?? false,
        offer: json['offer'] as String? ?? '',
      );
}

class ProductModel {
  final String id;
  final String name;
  final String vendorId;
  final String vendorName;
  final String categoryId;
  final List<String> images;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final int deliveryTimeMins;
  final String unit;
  final String description;
  final String nutrition;
  final Map<String, String> specifications;
  final bool isWishlisted;
  final bool isFlashSale;
  final bool isDeal;
  final int stock;
  final List<String> tags;

  const ProductModel({
    required this.id,
    required this.name,
    required this.vendorId,
    required this.vendorName,
    required this.categoryId,
    required this.images,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTimeMins,
    required this.unit,
    required this.description,
    this.nutrition = '',
    this.specifications = const {},
    this.isWishlisted = false,
    this.isFlashSale = false,
    this.isDeal = false,
    this.stock = 50,
    this.tags = const [],
  });

  int get discountPercent {
    if (originalPrice <= price) return 0;
    return (((originalPrice - price) / originalPrice) * 100).round();
  }

  ProductModel copyWith({bool? isWishlisted}) => ProductModel(
        id: id,
        name: name,
        vendorId: vendorId,
        vendorName: vendorName,
        categoryId: categoryId,
        images: images,
        price: price,
        originalPrice: originalPrice,
        rating: rating,
        reviewCount: reviewCount,
        deliveryTimeMins: deliveryTimeMins,
        unit: unit,
        description: description,
        nutrition: nutrition,
        specifications: specifications,
        isWishlisted: isWishlisted ?? this.isWishlisted,
        isFlashSale: isFlashSale,
        isDeal: isDeal,
        stock: stock,
        tags: tags,
      );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String,
        name: json['name'] as String,
        vendorId: json['vendorId'] as String,
        vendorName: json['vendorName'] as String,
        categoryId: json['categoryId'] as String,
        images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
        price: (json['price'] as num).toDouble(),
        originalPrice: (json['originalPrice'] as num).toDouble(),
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
        deliveryTimeMins: json['deliveryTimeMins'] as int,
        unit: json['unit'] as String,
        description: json['description'] as String,
        nutrition: json['nutrition'] as String? ?? '',
        specifications: (json['specifications'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v.toString())) ??
            {},
        isWishlisted: json['isWishlisted'] as bool? ?? false,
        isFlashSale: json['isFlashSale'] as bool? ?? false,
        isDeal: json['isDeal'] as bool? ?? false,
        stock: json['stock'] as int? ?? 50,
        tags: (json['tags'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );
}
