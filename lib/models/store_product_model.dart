import 'package:flutter/material.dart';

class StoreProduct {
  final String id;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String usageTitle;
  final String usageDescription;
  final String whyRecommended;
  final String priceLabel;
  final IconData icon;
  final String imagePath;

  /// Ana ürün mü, yan ürün mü?
  final bool isAddOn;

  /// Yan ürün tek başına alınabilir mi?
  final bool canBePurchasedAlone;

  const StoreProduct({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.usageTitle,
    required this.usageDescription,
    required this.whyRecommended,
    required this.priceLabel,
    required this.icon,
    required this.imagePath,
    this.isAddOn = false,
    this.canBePurchasedAlone = true,
  });
}