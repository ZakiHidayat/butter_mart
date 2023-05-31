

import 'package:butter_mart/models/product.dart';
import 'package:butter_mart/models/user.dart';

class Cart {
    final int id;
    final int productId;
    final int userId;
    final int quantity;
    final DateTime createdAt;
    final DateTime updatedAt;
    final Product product;
    final User user;

    Cart({
        required this.id,
        required this.productId,
        required this.userId,
        required this.quantity,
        required this.createdAt,
        required this.updatedAt,
        required this.product,
        required this.user,
    });

    factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        productId: json["product_id"],
        userId: json["user_id"],
        quantity: json["quantity"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: Product.fromJson(json["product"]),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "user_id": userId,
        "quantity": quantity,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product": product.toJson(),
        "user": user.toJson(),
    };
}

