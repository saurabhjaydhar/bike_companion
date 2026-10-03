import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

/// Colour of each expense category in charts, chips and icons.
const categoryColours = <String, Color>{
  ExpenseCategories.fuel: AppColors.primary,
  ExpenseCategories.service: Color(0xFF22D98E),
  ExpenseCategories.parts: Color(0xFFA78BFA),
  ExpenseCategories.insurance: Color(0xFFFFC233),
  ExpenseCategories.parking: AppColors.accent,
  ExpenseCategories.accessories: Color(0xFFFF4FD8),
  ExpenseCategories.fine: Color(0xFFFF4D6A),
  ExpenseCategories.other: Color(0xFF8B93A7),
};

Color categoryColour(String category) =>
    categoryColours[category] ?? AppColors.textSecondary;

IconData categoryIcon(String category) => switch (category) {
  ExpenseCategories.fuel => Icons.local_gas_station_rounded,
  ExpenseCategories.service => Icons.build_rounded,
  ExpenseCategories.parts => Icons.hardware_rounded,
  ExpenseCategories.insurance => Icons.verified_rounded,
  ExpenseCategories.parking => Icons.local_parking_rounded,
  ExpenseCategories.accessories => Icons.shopping_bag_rounded,
  ExpenseCategories.fine => Icons.gavel_rounded,
  _ => Icons.receipt_rounded,
};

final _rupees = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '₹',
  decimalDigits: 0,
);

/// Whole rupees in Indian grouping, e.g. ₹1,24,500.
String rupees(double amount) => _rupees.format(amount);
