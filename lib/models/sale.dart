class Sale {
  final int saleId;
  final int userId;
  final int? paymentId;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final String paymentStatus; // 'draft', 'pending', 'paid', 'cancelled'
  final DateTime saleDate;
  final List<SaleItem>? items;

  Sale({
    required this.saleId,
    required this.userId,
    this.paymentId,
    required this.subtotal,
    required this.discountAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.paymentStatus,
    required this.saleDate,
    this.items,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      saleId: json['sale_id'] is int 
          ? json['sale_id'] 
          : int.parse(json['sale_id'].toString()),
      userId: json['user_id'] is int 
          ? json['user_id'] 
          : int.parse(json['user_id'].toString()),
      paymentId: json['payment_id'] != null
          ? (json['payment_id'] is int 
              ? json['payment_id'] 
              : int.parse(json['payment_id'].toString()))
          : null,
      subtotal: double.parse(json['subtotal'].toString()),
      discountAmount: double.parse(json['discount_amount'].toString()),
      taxAmount: double.parse(json['tax_amount'].toString()),
      totalAmount: double.parse(json['total_amount'].toString()),
      paymentStatus: json['payment_status'] as String,
      saleDate: DateTime.parse(json['sale_date'] as String),
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => SaleItem.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sale_id': saleId,
      'user_id': userId,
      'payment_id': paymentId,
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'total_amount': totalAmount,
      'payment_status': paymentStatus,
      'sale_date': saleDate.toIso8601String(),
      if (items != null) 'items': items!.map((item) => item.toJson()).toList(),
    };
  }

  Sale copyWith({
    int? saleId,
    int? userId,
    int? paymentId,
    double? subtotal,
    double? discountAmount,
    double? taxAmount,
    double? totalAmount,
    String? paymentStatus,
    DateTime? saleDate,
    List<SaleItem>? items,
  }) {
    return Sale(
      saleId: saleId ?? this.saleId,
      userId: userId ?? this.userId,
      paymentId: paymentId ?? this.paymentId,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      saleDate: saleDate ?? this.saleDate,
      items: items ?? this.items,
    );
  }
}

class SaleItem {
  final int? saleItemId;
  final int saleId;
  final int productId;
  final String nameProduct;
  final int quantity;
  final double discountAmount;
  final double subtotal;

  SaleItem({
    this.saleItemId,
    required this.saleId,
    required this.productId,
    required this.nameProduct,
    required this.quantity,
    required this.discountAmount,
    required this.subtotal,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      saleItemId: json['sale_item_id'] != null
          ? (json['sale_item_id'] is int 
              ? json['sale_item_id'] 
              : int.parse(json['sale_item_id'].toString()))
          : null,
      saleId: json['sale_id'] is int 
          ? json['sale_id'] 
          : int.parse(json['sale_id'].toString()),
      productId: json['product_id'] is int 
          ? json['product_id'] 
          : int.parse(json['product_id'].toString()),
      nameProduct: json['name_product'] as String,
      quantity: json['quantity'] is int 
          ? json['quantity'] 
          : int.parse(json['quantity'].toString()),
      discountAmount: double.parse(json['discount_amount'].toString()),
      subtotal: double.parse(json['subtotal'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (saleItemId != null) 'sale_item_id': saleItemId,
      'sale_id': saleId,
      'product_id': productId,
      'name_product': nameProduct,
      'quantity': quantity,
      'discount_amount': discountAmount,
      'subtotal': subtotal,
    };
  }
}
