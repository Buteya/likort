import 'package:flutter/material.dart';
import 'package:likort/models/likortcartitem.dart';
import 'package:provider/provider.dart';

class CartBadge extends StatefulWidget {
  const CartBadge({super.key});

  @override
  State<CartBadge> createState() => _CartBadgeState();
}

class _CartBadgeState extends State<CartBadge> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartItem>(context);
    final cartItemCount = cartProvider.cartItems.length;
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.shopping_cart),
        if (cartItemCount > 0)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                '$cartItemCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
