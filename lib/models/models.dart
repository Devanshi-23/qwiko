class CartItemModel {
  final String productId;
  final String name;
  final String image;
  final String vendorId;
  final String vendorName;
  final double price;
  final double originalPrice;
  final String unit;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.vendorId,
    required this.vendorName,
    required this.price,
    required this.originalPrice,
    required this.unit,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

class AddressModel {
  final String id;
  final String label;
  final String name;
  final String phone;
  final String addressLine;
  final String landmark;
  final String city;
  final String pincode;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.name,
    required this.phone,
    required this.addressLine,
    required this.landmark,
    required this.city,
    required this.pincode,
    this.isDefault = false,
  });

  String get fullAddress =>
      '$addressLine${landmark.isNotEmpty ? ', $landmark' : ''}, $city - $pincode';
}

class OrderModel {
  final String id;
  final String status;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double total;
  final String address;
  final String paymentMethod;
  final String vendorName;
  final int etaMins;
  final List<OrderTimelineItem> timeline;

  const OrderModel({
    required this.id,
    required this.status,
    required this.createdAt,
    this.deliveredAt,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.discount,
    required this.total,
    required this.address,
    required this.paymentMethod,
    required this.vendorName,
    this.etaMins = 30,
    this.timeline = const [],
  });
}

class OrderItemModel {
  final String name;
  final String image;
  final int quantity;
  final double price;

  const OrderItemModel({
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
  });
}

class OrderTimelineItem {
  final String title;
  final String subtitle;
  final DateTime time;
  final bool isCompleted;

  const OrderTimelineItem({
    required this.title,
    required this.subtitle,
    required this.time,
    this.isCompleted = false,
  });
}

class CouponModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final double discountPercent;
  final double maxDiscount;
  final double minOrder;
  final DateTime expiry;
  final String type;

  const CouponModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountPercent,
    required this.maxDiscount,
    required this.minOrder,
    required this.expiry,
    this.type = 'percentage',
  });
}

class WalletTransaction {
  final String id;
  final String title;
  final String type;
  final double amount;
  final DateTime date;
  final String status;

  const WalletTransaction({
    required this.id,
    required this.title,
    required this.type,
    required this.amount,
    required this.date,
    this.status = 'success',
  });
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime time;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.time,
    this.isRead = false,
  });

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        id: id,
        title: title,
        body: body,
        type: type,
        time: time,
        isRead: isRead ?? this.isRead,
      );
}

class ReviewModel {
  final String id;
  final String userName;
  final String avatar;
  final double rating;
  final String comment;
  final DateTime date;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.avatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class DeliveryPartnerModel {
  final String id;
  final String name;
  final String avatar;
  final String phone;
  final double rating;
  final String vehicle;

  const DeliveryPartnerModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.phone,
    required this.rating,
    required this.vehicle,
  });
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String membership;
  final double walletBalance;
  final int rewardPoints;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.membership,
    required this.walletBalance,
    required this.rewardPoints,
  });
}

class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String color;

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.color = '#6BE785',
  });
}

class FaqModel {
  final String question;
  final String answer;
  final String category;

  const FaqModel({
    required this.question,
    required this.answer,
    required this.category,
  });
}
