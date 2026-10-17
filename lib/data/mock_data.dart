import '../models/category_model.dart';
import '../models/models.dart';

class MockData {
  MockData._();

  static const user = UserModel(
    id: 'u1',
    name: 'Alex Rivera',
    email: 'alex.rivera@email.com',
    phone: '+91 98765 43210',
    avatar: 'https://i.pravatar.cc/150?u=alex',
    membership: 'Qwiko Gold',
    walletBalance: 450.0,
    rewardPoints: 1280,
  );

  static final categories = <CategoryModel>[
    CategoryModel(
      id: 'c1',
      name: 'Groceries',
      icon: '🥬',
      imageUrl: 'https://picsum.photos/seed/qwiko-838132/400/400',
      itemCount: 2400,
      colorIndex: 0,
      subCategories: ['Fruits', 'Vegetables', 'Dairy', 'Staples', 'Snacks'],
    ),
    CategoryModel(
      id: 'c2',
      name: 'Food',
      icon: '🍕',
      imageUrl: 'https://picsum.photos/seed/qwiko-624946/400/400',
      itemCount: 1800,
      colorIndex: 1,
      subCategories: ['Biryani', 'Pizza', 'Burgers', 'Healthy', 'Desserts'],
    ),
    CategoryModel(
      id: 'c3',
      name: 'Pharmacy',
      icon: '💊',
      imageUrl: 'https://picsum.photos/seed/qwiko-666744/400/400',
      itemCount: 920,
      colorIndex: 2,
      subCategories: ['Medicines', 'Wellness', 'Personal Care', 'Devices'],
    ),
    CategoryModel(
      id: 'c4',
      name: 'Beauty',
      icon: '💄',
      imageUrl: 'https://picsum.photos/seed/qwiko-502278/400/400',
      itemCount: 1100,
      colorIndex: 3,
      subCategories: ['Skincare', 'Makeup', 'Haircare', 'Fragrance'],
    ),
    CategoryModel(
      id: 'c5',
      name: 'Home Essentials',
      icon: '🏠',
      imageUrl: 'https://picsum.photos/seed/qwiko-492125/400/400',
      itemCount: 1500,
      colorIndex: 4,
      subCategories: ['Cleaning', 'Kitchen', 'Bath', 'Decor'],
    ),
    CategoryModel(
      id: 'c6',
      name: 'Electronics',
      icon: '💻',
      imageUrl: 'https://picsum.photos/seed/qwiko-794561/400/400',
      itemCount: 680,
      colorIndex: 5,
      subCategories: ['Mobiles', 'Accessories', 'Audio', 'Gadgets'],
    ),
    CategoryModel(
      id: 'c7',
      name: 'Fashion',
      icon: '👕',
      imageUrl: 'https://picsum.photos/seed/qwiko-170230/400/400',
      itemCount: 2200,
      colorIndex: 6,
      subCategories: ['Men', 'Women', 'Kids', 'Footwear'],
    ),
    CategoryModel(
      id: 'c8',
      name: 'Pet Care',
      icon: '🐶',
      imageUrl: 'https://picsum.photos/seed/qwiko-003388/400/400',
      itemCount: 450,
      colorIndex: 7,
      subCategories: ['Food', 'Toys', 'Grooming', 'Accessories'],
    ),
    CategoryModel(
      id: 'c9',
      name: 'Baby Care',
      icon: '👶',
      imageUrl: 'https://picsum.photos/seed/qwiko-042361/400/400',
      itemCount: 720,
      colorIndex: 0,
      subCategories: ['Diapers', 'Food', 'Toys', 'Skincare'],
    ),
    CategoryModel(
      id: 'c10',
      name: 'Flowers & Gifts',
      icon: '🌹',
      imageUrl: 'https://picsum.photos/seed/qwiko-967868/400/400',
      itemCount: 340,
      colorIndex: 1,
      subCategories: ['Bouquets', 'Cakes', 'Hampers', 'Cards'],
    ),
    CategoryModel(
      id: 'c11',
      name: 'Bakery',
      icon: '🥐',
      imageUrl: 'https://picsum.photos/seed/qwiko-159596/400/400',
      itemCount: 280,
      colorIndex: 2,
      subCategories: ['Bread', 'Cakes', 'Pastries', 'Cookies'],
    ),
    CategoryModel(
      id: 'c12',
      name: 'Stationery',
      icon: '📚',
      imageUrl: 'https://picsum.photos/seed/qwiko-084080/400/400',
      itemCount: 560,
      colorIndex: 3,
      subCategories: ['Notebooks', 'Pens', 'Art', 'Office'],
    ),
    CategoryModel(
      id: 'c13',
      name: 'Sports',
      icon: '⚽',
      imageUrl: 'https://picsum.photos/seed/qwiko-836934/400/400',
      itemCount: 410,
      colorIndex: 4,
      subCategories: ['Fitness', 'Outdoor', 'Team Sports', 'Yoga'],
    ),
    CategoryModel(
      id: 'c14',
      name: 'Automotive',
      icon: '🚗',
      imageUrl: 'https://picsum.photos/seed/qwiko-534655/400/400',
      itemCount: 290,
      colorIndex: 5,
      subCategories: ['Care', 'Accessories', 'Tools', 'Oils'],
    ),
    CategoryModel(
      id: 'c15',
      name: 'Gardening',
      icon: '🌱',
      imageUrl: 'https://picsum.photos/seed/qwiko-595882/400/400',
      itemCount: 380,
      colorIndex: 6,
      subCategories: ['Plants', 'Tools', 'Seeds', 'Pots'],
    ),
  ];

  static final banners = <BannerModel>[
    const BannerModel(
      id: 'b1',
      title: 'Flash Sale',
      subtitle: 'Up to 60% off on groceries',
      imageUrl: 'https://picsum.photos/seed/qwiko-206869/800/400',
    ),
    const BannerModel(
      id: 'b2',
      title: 'Free Delivery',
      subtitle: 'On orders above ₹199',
      imageUrl: 'https://picsum.photos/seed/qwiko-797299/800/400',
    ),
    const BannerModel(
      id: 'b3',
      title: 'Fresh Everyday',
      subtitle: 'Farm-fresh produce in 10 mins',
      imageUrl: 'https://picsum.photos/seed/qwiko-725531/800/400',
    ),
  ];

  static final vendors = <VendorModel>[
    const VendorModel(
      id: 'v1',
      name: 'FreshMart Express',
      logo: 'https://picsum.photos/seed/qwiko-312566/200/200',
      banner: 'https://picsum.photos/seed/qwiko-838132/800/400',
      rating: 4.7,
      reviewCount: 2340,
      deliveryTimeMins: 12,
      distanceKm: 0.8,
      minOrder: 99,
      category: 'Groceries',
      tags: ['Organic', 'Fast Delivery'],
      isFeatured: true,
      isTrending: true,
      offer: '₹50 OFF above ₹299',
    ),
    const VendorModel(
      id: 'v2',
      name: 'Spice Route Kitchen',
      logo: 'https://picsum.photos/seed/qwiko-135467/200/200',
      banner: 'https://picsum.photos/seed/qwiko-624946/800/400',
      rating: 4.5,
      reviewCount: 1890,
      deliveryTimeMins: 25,
      distanceKm: 1.2,
      minOrder: 149,
      category: 'Food',
      tags: ['Biryani', 'North Indian'],
      isFeatured: true,
      offer: '20% OFF',
    ),
    const VendorModel(
      id: 'v3',
      name: 'MediQuick Pharmacy',
      logo: 'https://picsum.photos/seed/qwiko-976047/200/200',
      banner: 'https://picsum.photos/seed/qwiko-666744/800/400',
      rating: 4.8,
      reviewCount: 980,
      deliveryTimeMins: 15,
      distanceKm: 0.5,
      minOrder: 0,
      category: 'Pharmacy',
      tags: ['24x7', 'Licensed'],
      isTrending: true,
      offer: 'Free Delivery',
    ),
    const VendorModel(
      id: 'v4',
      name: 'Glow Beauty Hub',
      logo: 'https://picsum.photos/seed/qwiko-789203/200/200',
      banner: 'https://picsum.photos/seed/qwiko-502278/800/400',
      rating: 4.6,
      reviewCount: 1120,
      deliveryTimeMins: 20,
      distanceKm: 1.5,
      minOrder: 199,
      category: 'Beauty',
      tags: ['Premium Brands'],
      isFeatured: true,
      offer: 'Buy 1 Get 1',
    ),
    const VendorModel(
      id: 'v5',
      name: 'TechNest Gadgets',
      logo: 'https://picsum.photos/seed/qwiko-244123/200/200',
      banner: 'https://picsum.photos/seed/qwiko-794561/800/400',
      rating: 4.4,
      reviewCount: 760,
      deliveryTimeMins: 30,
      distanceKm: 2.1,
      minOrder: 299,
      category: 'Electronics',
      tags: ['Genuine', 'Warranty'],
      isTrending: true,
      offer: '₹200 OFF',
    ),
    const VendorModel(
      id: 'v6',
      name: 'Pawsome Pet Store',
      logo: 'https://picsum.photos/seed/qwiko-003388/200/200',
      banner: 'https://picsum.photos/seed/qwiko-869180/800/400',
      rating: 4.9,
      reviewCount: 540,
      deliveryTimeMins: 18,
      distanceKm: 1.0,
      minOrder: 149,
      category: 'Pet Care',
      tags: ['Pet Friendly'],
      isFeatured: true,
      offer: '15% OFF',
    ),
    const VendorModel(
      id: 'v7',
      name: 'Bakehouse Daily',
      logo: 'https://picsum.photos/seed/qwiko-159596/200/200',
      banner: 'https://picsum.photos/seed/qwiko-159596/800/400',
      rating: 4.7,
      reviewCount: 890,
      deliveryTimeMins: 22,
      distanceKm: 0.9,
      minOrder: 99,
      category: 'Bakery',
      tags: ['Fresh Baked'],
      isTrending: true,
      offer: 'Free Cookies',
    ),
    const VendorModel(
      id: 'v8',
      name: 'HomeNest Essentials',
      logo: 'https://picsum.photos/seed/qwiko-492125/200/200',
      banner: 'https://picsum.photos/seed/qwiko-911220/800/400',
      rating: 4.3,
      reviewCount: 650,
      deliveryTimeMins: 28,
      distanceKm: 1.8,
      minOrder: 199,
      category: 'Home Essentials',
      tags: ['Quality'],
      offer: '₹100 OFF',
    ),
  ];

  static final products = <ProductModel>[
    ProductModel(
      id: 'p1',
      name: 'Organic Avocados',
      vendorId: 'v1',
      vendorName: 'FreshMart Express',
      categoryId: 'c1',
      images: [
        'https://picsum.photos/seed/qwiko-673857/600/600',
        'https://picsum.photos/seed/qwiko-758481/600/600',
      ],
      price: 149,
      originalPrice: 199,
      rating: 4.6,
      reviewCount: 340,
      deliveryTimeMins: 10,
      unit: '500g',
      description:
          'Farm-fresh organic avocados, perfectly ripe and creamy. Ideal for toast, salads, and guacamole.',
      nutrition: 'Calories: 160 | Fat: 15g | Carbs: 9g | Protein: 2g',
      specifications: {'Origin': 'Maharashtra', 'Type': 'Hass', 'Shelf Life': '5 days'},
      isDeal: true,
      tags: ['Organic', 'Fresh'],
    ),
    ProductModel(
      id: 'p2',
      name: 'Farm Fresh Strawberries',
      vendorId: 'v1',
      vendorName: 'FreshMart Express',
      categoryId: 'c1',
      images: [
        'https://picsum.photos/seed/qwiko-911861/600/600',
      ],
      price: 99,
      originalPrice: 149,
      rating: 4.8,
      reviewCount: 520,
      deliveryTimeMins: 10,
      unit: '250g',
      description: 'Sweet, juicy strawberries picked at peak ripeness.',
      isFlashSale: true,
      tags: ['Fresh'],
    ),
    ProductModel(
      id: 'p3',
      name: 'Butter Chicken Combo',
      vendorId: 'v2',
      vendorName: 'Spice Route Kitchen',
      categoryId: 'c2',
      images: [
        'https://picsum.photos/seed/qwiko-584373/600/600',
      ],
      price: 299,
      originalPrice: 399,
      rating: 4.5,
      reviewCount: 890,
      deliveryTimeMins: 25,
      unit: '1 Plate',
      description:
          'Creamy butter chicken with basmati rice, naan, and raita. Serves 1–2.',
      isDeal: true,
      tags: ['Bestseller'],
    ),
    ProductModel(
      id: 'p4',
      name: 'Margherita Pizza',
      vendorId: 'v2',
      vendorName: 'Spice Route Kitchen',
      categoryId: 'c2',
      images: [
        'https://picsum.photos/seed/qwiko-318508/600/600',
      ],
      price: 249,
      originalPrice: 299,
      rating: 4.4,
      reviewCount: 670,
      deliveryTimeMins: 30,
      unit: 'Medium',
      description: 'Classic wood-fired pizza with fresh mozzarella and basil.',
      tags: ['Vegetarian'],
    ),
    ProductModel(
      id: 'p5',
      name: 'Paracetamol 500mg',
      vendorId: 'v3',
      vendorName: 'MediQuick Pharmacy',
      categoryId: 'c3',
      images: [
        'https://picsum.photos/seed/qwiko-666744/600/600',
      ],
      price: 25,
      originalPrice: 30,
      rating: 4.9,
      reviewCount: 1200,
      deliveryTimeMins: 12,
      unit: '15 Tablets',
      description: 'Trusted pain relief and fever reducer. Take as directed.',
      tags: ['OTC'],
    ),
    ProductModel(
      id: 'p6',
      name: 'Vitamin C Serum',
      vendorId: 'v4',
      vendorName: 'Glow Beauty Hub',
      categoryId: 'c4',
      images: [
        'https://picsum.photos/seed/qwiko-565202/600/600',
      ],
      price: 599,
      originalPrice: 899,
      rating: 4.7,
      reviewCount: 430,
      deliveryTimeMins: 20,
      unit: '30ml',
      description:
          'Brightening vitamin C serum for radiant, even-toned skin. Suitable for all skin types.',
      isFlashSale: true,
      tags: ['Skincare'],
    ),
    ProductModel(
      id: 'p7',
      name: 'Wireless Earbuds Pro',
      vendorId: 'v5',
      vendorName: 'TechNest Gadgets',
      categoryId: 'c6',
      images: [
        'https://picsum.photos/seed/qwiko-268037/600/600',
      ],
      price: 2499,
      originalPrice: 3999,
      rating: 4.5,
      reviewCount: 890,
      deliveryTimeMins: 30,
      unit: '1 Unit',
      description:
          'ANC wireless earbuds with 36hr battery, IPX5 water resistance, and crystal-clear sound.',
      isDeal: true,
      tags: ['Gadgets'],
    ),
    ProductModel(
      id: 'p8',
      name: 'Premium Dog Food',
      vendorId: 'v6',
      vendorName: 'Pawsome Pet Store',
      categoryId: 'c8',
      images: [
        'https://picsum.photos/seed/qwiko-691995/600/600',
      ],
      price: 749,
      originalPrice: 899,
      rating: 4.8,
      reviewCount: 320,
      deliveryTimeMins: 18,
      unit: '3kg',
      description: 'Grain-free premium dog food with real chicken and vegetables.',
      tags: ['Pet'],
    ),
    ProductModel(
      id: 'p9',
      name: 'Artisan Sourdough',
      vendorId: 'v7',
      vendorName: 'Bakehouse Daily',
      categoryId: 'c11',
      images: [
        'https://picsum.photos/seed/qwiko-931319/600/600',
      ],
      price: 120,
      originalPrice: 150,
      rating: 4.9,
      reviewCount: 210,
      deliveryTimeMins: 20,
      unit: '400g',
      description: 'Freshly baked sourdough with a crispy crust and soft crumb.',
      isDeal: true,
      tags: ['Fresh Baked'],
    ),
    ProductModel(
      id: 'p10',
      name: 'Olive Oil Extra Virgin',
      vendorId: 'v1',
      vendorName: 'FreshMart Express',
      categoryId: 'c1',
      images: [
        'https://picsum.photos/seed/qwiko-266404/600/600',
      ],
      price: 449,
      originalPrice: 599,
      rating: 4.6,
      reviewCount: 180,
      deliveryTimeMins: 12,
      unit: '500ml',
      description: 'Cold-pressed extra virgin olive oil from Mediterranean olives.',
      isFlashSale: true,
      tags: ['Gourmet'],
    ),
    ProductModel(
      id: 'p11',
      name: 'Hydrating Face Mask',
      vendorId: 'v4',
      vendorName: 'Glow Beauty Hub',
      categoryId: 'c4',
      images: [
        'https://picsum.photos/seed/qwiko-228720/600/600',
      ],
      price: 199,
      originalPrice: 299,
      rating: 4.4,
      reviewCount: 560,
      deliveryTimeMins: 20,
      unit: '5 Sheets',
      description: 'Deep hydrating sheet masks infused with hyaluronic acid.',
      tags: ['Skincare'],
    ),
    ProductModel(
      id: 'p12',
      name: 'Smart LED Bulb',
      vendorId: 'v5',
      vendorName: 'TechNest Gadgets',
      categoryId: 'c6',
      images: [
        'https://picsum.photos/seed/qwiko-985546/600/600',
      ],
      price: 399,
      originalPrice: 599,
      rating: 4.3,
      reviewCount: 145,
      deliveryTimeMins: 28,
      unit: '1 Unit',
      description: 'WiFi-enabled smart bulb with 16M colors and voice control.',
      isDeal: true,
      tags: ['Smart Home'],
    ),
    ProductModel(
      id: 'p13',
      name: 'Banana Bunch',
      vendorId: 'v1',
      vendorName: 'FreshMart Express',
      categoryId: 'c1',
      images: [
        'https://picsum.photos/seed/qwiko-894821/600/600',
      ],
      price: 49,
      originalPrice: 65,
      rating: 4.5,
      reviewCount: 980,
      deliveryTimeMins: 10,
      unit: '6 pcs',
      description: 'Naturally ripened bananas, rich in potassium.',
      tags: ['Fresh'],
    ),
    ProductModel(
      id: 'p14',
      name: 'Chocolate Croissant',
      vendorId: 'v7',
      vendorName: 'Bakehouse Daily',
      categoryId: 'c11',
      images: [
        'https://picsum.photos/seed/qwiko-507036/600/600',
      ],
      price: 80,
      originalPrice: 100,
      rating: 4.8,
      reviewCount: 340,
      deliveryTimeMins: 22,
      unit: '2 pcs',
      description: 'Flaky butter croissants filled with rich dark chocolate.',
      isFlashSale: true,
      tags: ['Bakery'],
    ),
    ProductModel(
      id: 'p15',
      name: 'All-Purpose Cleaner',
      vendorId: 'v8',
      vendorName: 'HomeNest Essentials',
      categoryId: 'c5',
      images: [
        'https://picsum.photos/seed/qwiko-392212/600/600',
      ],
      price: 179,
      originalPrice: 229,
      rating: 4.2,
      reviewCount: 210,
      deliveryTimeMins: 25,
      unit: '750ml',
      description: 'Multi-surface cleaner with fresh citrus scent. Kills 99.9% germs.',
      tags: ['Home'],
    ),
    ProductModel(
      id: 'p16',
      name: 'Greek Yogurt Pack',
      vendorId: 'v1',
      vendorName: 'FreshMart Express',
      categoryId: 'c1',
      images: [
        'https://picsum.photos/seed/qwiko-181946/600/600',
      ],
      price: 120,
      originalPrice: 160,
      rating: 4.7,
      reviewCount: 450,
      deliveryTimeMins: 10,
      unit: '400g',
      description: 'Thick, creamy Greek yogurt with live cultures. High protein.',
      isDeal: true,
      tags: ['Dairy'],
    ),
  ];

  static final coupons = <CouponModel>[
    CouponModel(
      id: 'cp1',
      code: 'QWIKO50',
      title: 'Flat ₹50 Off',
      description: 'Get ₹50 off on orders above ₹299',
      discountPercent: 0,
      maxDiscount: 50,
      minOrder: 299,
      expiry: DateTime.now().add(const Duration(days: 15)),
      type: 'flat',
    ),
    CouponModel(
      id: 'cp2',
      code: 'FRESH20',
      title: '20% Off Groceries',
      description: '20% off up to ₹100 on grocery orders',
      discountPercent: 20,
      maxDiscount: 100,
      minOrder: 199,
      expiry: DateTime.now().add(const Duration(days: 7)),
    ),
    CouponModel(
      id: 'cp3',
      code: 'FREEDEL',
      title: 'Free Delivery',
      description: 'Free delivery on all orders above ₹149',
      discountPercent: 0,
      maxDiscount: 40,
      minOrder: 149,
      expiry: DateTime.now().add(const Duration(days: 30)),
      type: 'delivery',
    ),
    CouponModel(
      id: 'cp4',
      code: 'WELCOME100',
      title: 'Welcome Bonus',
      description: '₹100 off on your first order above ₹499',
      discountPercent: 0,
      maxDiscount: 100,
      minOrder: 499,
      expiry: DateTime.now().add(const Duration(days: 60)),
      type: 'flat',
    ),
  ];

  static final addresses = <AddressModel>[
    const AddressModel(
      id: 'a1',
      label: 'Home',
      name: 'Alex Rivera',
      phone: '+91 98765 43210',
      addressLine: '42 Green Park Avenue, Flat 3B',
      landmark: 'Near Metro Station',
      city: 'Bengaluru',
      pincode: '560001',
      isDefault: true,
    ),
    const AddressModel(
      id: 'a2',
      label: 'Work',
      name: 'Alex Rivera',
      phone: '+91 98765 43210',
      addressLine: 'Tech Plaza, 8th Floor, MG Road',
      landmark: 'Opposite Central Mall',
      city: 'Bengaluru',
      pincode: '560002',
    ),
  ];

  static final notifications = <NotificationModel>[
    NotificationModel(
      id: 'n1',
      title: 'Order Delivered!',
      body: 'Your order #QW88421 has been delivered. Enjoy!',
      type: 'orders',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    NotificationModel(
      id: 'n2',
      title: 'Flash Sale Live 🔥',
      body: 'Up to 60% off on fresh groceries. Ends in 2 hours!',
      type: 'offers',
      time: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'n3',
      title: 'Wallet Credited',
      body: '₹50 cashback credited to your Qwiko Wallet.',
      type: 'payments',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n4',
      title: 'New Store Near You',
      body: 'Bakehouse Daily is now delivering to your area.',
      type: 'general',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  static final walletTransactions = <WalletTransaction>[
    WalletTransaction(
      id: 'wt1',
      title: 'Cashback — Order #QW88421',
      type: 'credit',
      amount: 50,
      date: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    WalletTransaction(
      id: 'wt2',
      title: 'Paid for Order #QW88390',
      type: 'debit',
      amount: 120,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    WalletTransaction(
      id: 'wt3',
      title: 'Wallet Recharge',
      type: 'credit',
      amount: 500,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    WalletTransaction(
      id: 'wt4',
      title: 'Referral Bonus',
      type: 'credit',
      amount: 100,
      date: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  static final reviews = <ReviewModel>[
    ReviewModel(
      id: 'r1',
      userName: 'Priya S.',
      avatar: 'https://i.pravatar.cc/100?u=priya',
      rating: 5,
      comment: 'Super fresh and delivered in 10 mins. Amazing quality!',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ReviewModel(
      id: 'r2',
      userName: 'Rahul M.',
      avatar: 'https://i.pravatar.cc/100?u=rahul',
      rating: 4,
      comment: 'Good product, packaging could be better. Will order again.',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ReviewModel(
      id: 'r3',
      userName: 'Sneha K.',
      avatar: 'https://i.pravatar.cc/100?u=sneha',
      rating: 5,
      comment: 'Best prices and fastest delivery in the area. Love Qwiko!',
      date: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ];

  static const deliveryPartner = DeliveryPartnerModel(
    id: 'dp1',
    name: 'Ravi Kumar',
    avatar: 'https://i.pravatar.cc/150?u=ravi',
    phone: '+91 99887 76655',
    rating: 4.9,
    vehicle: 'Bike • KA-01-AB-1234',
  );

  static final faqs = <FaqModel>[
    const FaqModel(
      question: 'How fast is delivery?',
      answer:
          'Most orders are delivered within 10–30 minutes depending on the store and your location.',
      category: 'Delivery',
    ),
    const FaqModel(
      question: 'How do I cancel an order?',
      answer:
          'Go to My Orders, select the order, and tap Cancel. Cancellations are free before the store accepts.',
      category: 'Orders',
    ),
    const FaqModel(
      question: 'How do refunds work?',
      answer:
          'Refunds are processed to your original payment method or Qwiko Wallet within 3–5 business days.',
      category: 'Refund',
    ),
    const FaqModel(
      question: 'Can I pay with wallet?',
      answer:
          'Yes! You can use Qwiko Wallet alone or combine it with UPI, cards, or COD.',
      category: 'Payments',
    ),
    const FaqModel(
      question: 'How do I contact support?',
      answer:
          'Use Help Center for live chat, call, or email. For active orders, chat with your delivery partner too.',
      category: 'Support',
    ),
  ];

  static final recentSearches = <String>[
    'Avocado',
    'Pizza',
    'Milk',
    'Vitamin C',
    'Dog food',
  ];

  static final popularSearches = <String>[
    'Fresh fruits',
    'Biryani',
    'Face serum',
    'Earbuds',
    'Bread',
    'Cleaning',
    'Protein',
    'Flowers',
  ];

  static List<OrderModel> get orders {
    final now = DateTime.now();
    return [
      OrderModel(
        id: 'QW88450',
        status: 'upcoming',
        createdAt: now.subtract(const Duration(minutes: 8)),
        items: [
          OrderItemModel(
            name: 'Organic Avocados',
            image: products[0].images.first,
            quantity: 2,
            price: 149,
          ),
          OrderItemModel(
            name: 'Greek Yogurt Pack',
            image: products[15].images.first,
            quantity: 1,
            price: 120,
          ),
        ],
        subtotal: 418,
        deliveryFee: 0,
        tax: 21,
        discount: 50,
        total: 389,
        address: addresses[0].fullAddress,
        paymentMethod: 'UPI',
        vendorName: 'FreshMart Express',
        etaMins: 12,
        timeline: [
          OrderTimelineItem(
            title: 'Order Placed',
            subtitle: 'We received your order',
            time: now.subtract(const Duration(minutes: 8)),
            isCompleted: true,
          ),
          OrderTimelineItem(
            title: 'Confirmed',
            subtitle: 'Store is preparing',
            time: now.subtract(const Duration(minutes: 6)),
            isCompleted: true,
          ),
          OrderTimelineItem(
            title: 'Out for Delivery',
            subtitle: 'Partner on the way',
            time: now.subtract(const Duration(minutes: 2)),
            isCompleted: true,
          ),
          OrderTimelineItem(
            title: 'Delivered',
            subtitle: 'Enjoy your order!',
            time: now.add(const Duration(minutes: 10)),
          ),
        ],
      ),
      OrderModel(
        id: 'QW88421',
        status: 'delivered',
        createdAt: now.subtract(const Duration(days: 1)),
        deliveredAt: now.subtract(const Duration(days: 1)).add(const Duration(minutes: 28)),
        items: [
          OrderItemModel(
            name: 'Vitamin C Serum',
            image: products[5].images.first,
            quantity: 1,
            price: 599,
          ),
        ],
        subtotal: 599,
        deliveryFee: 25,
        tax: 30,
        discount: 0,
        total: 654,
        address: addresses[0].fullAddress,
        paymentMethod: 'Wallet',
        vendorName: 'Glow Beauty Hub',
        etaMins: 0,
        timeline: [
          OrderTimelineItem(
            title: 'Order Placed',
            subtitle: 'We received your order',
            time: now.subtract(const Duration(days: 1)),
            isCompleted: true,
          ),
          OrderTimelineItem(
            title: 'Confirmed',
            subtitle: 'Store accepted',
            time: now.subtract(const Duration(days: 1)).add(const Duration(minutes: 3)),
            isCompleted: true,
          ),
          OrderTimelineItem(
            title: 'Out for Delivery',
            subtitle: 'On the way',
            time: now.subtract(const Duration(days: 1)).add(const Duration(minutes: 15)),
            isCompleted: true,
          ),
          OrderTimelineItem(
            title: 'Delivered',
            subtitle: 'Delivered successfully',
            time: now.subtract(const Duration(days: 1)).add(const Duration(minutes: 28)),
            isCompleted: true,
          ),
        ],
      ),
      OrderModel(
        id: 'QW88301',
        status: 'cancelled',
        createdAt: now.subtract(const Duration(days: 4)),
        items: [
          OrderItemModel(
            name: 'Wireless Earbuds Pro',
            image: products[6].images.first,
            quantity: 1,
            price: 2499,
          ),
        ],
        subtotal: 2499,
        deliveryFee: 0,
        tax: 125,
        discount: 200,
        total: 2424,
        address: addresses[1].fullAddress,
        paymentMethod: 'Card',
        vendorName: 'TechNest Gadgets',
        timeline: [
          OrderTimelineItem(
            title: 'Order Placed',
            subtitle: 'We received your order',
            time: now.subtract(const Duration(days: 4)),
            isCompleted: true,
          ),
          OrderTimelineItem(
            title: 'Cancelled',
            subtitle: 'Cancelled by you',
            time: now.subtract(const Duration(days: 4)).add(const Duration(minutes: 5)),
            isCompleted: true,
          ),
        ],
      ),
      OrderModel(
        id: 'QW88250',
        status: 'returned',
        createdAt: now.subtract(const Duration(days: 10)),
        deliveredAt: now.subtract(const Duration(days: 10)).add(const Duration(minutes: 35)),
        items: [
          OrderItemModel(
            name: 'Smart LED Bulb',
            image: products[11].images.first,
            quantity: 2,
            price: 399,
          ),
        ],
        subtotal: 798,
        deliveryFee: 30,
        tax: 40,
        discount: 0,
        total: 868,
        address: addresses[0].fullAddress,
        paymentMethod: 'UPI',
        vendorName: 'TechNest Gadgets',
      ),
    ];
  }

  static ProductModel? productById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static VendorModel? vendorById(String id) {
    try {
      return vendors.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  static CategoryModel? categoryById(String id) {
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<ProductModel> productsByCategory(String categoryId) =>
      products.where((p) => p.categoryId == categoryId).toList();

  static List<ProductModel> productsByVendor(String vendorId) =>
      products.where((p) => p.vendorId == vendorId).toList();

  static List<ProductModel> get flashSale =>
      products.where((p) => p.isFlashSale).toList();

  static List<ProductModel> get deals =>
      products.where((p) => p.isDeal).toList();

  static List<VendorModel> get trendingVendors =>
      vendors.where((v) => v.isTrending).toList();

  static List<VendorModel> get featuredVendors =>
      vendors.where((v) => v.isFeatured).toList();
}
