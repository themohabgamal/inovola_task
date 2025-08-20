import 'package:flutter/material.dart';

class CategoryUtils {
  static final Map<String, Map<String, dynamic>> _categoryData = {
    'Groceries': {'icon': 'shopping_cart', 'color': Color(0xFF6366F1)},
    'Entertainment': {'icon': 'movie', 'color': Color(0xFF3B82F6)},
    'Gas': {'icon': 'local_gas_station', 'color': Color(0xFFEF4444)},
    'Shopping': {'icon': 'shopping_bag', 'color': Color(0xFFF59E0B)},
    'News Paper': {'icon': 'newspaper', 'color': Color(0xFF8B5CF6)},
    'Transport': {'icon': 'directions_car', 'color': Color(0xFF10B981)},
    'Rent': {'icon': 'home', 'color': Color(0xFFF97316)},
    'Food': {'icon': 'restaurant', 'color': Color(0xFF10B981)},
    'Health': {'icon': 'local_hospital', 'color': Color(0xFFEF4444)},
    'Education': {'icon': 'school', 'color': Color(0xFF06B6D4)},
    'Travel': {'icon': 'flight', 'color': Color(0xFF8B5CF6)},
    'Utilities': {'icon': 'electrical_services', 'color': Color(0xFFEF4444)},
    'Insurance': {'icon': 'security', 'color': Color(0xFF6366F1)},
    'Gym': {'icon': 'fitness_center', 'color': Color(0xFF10B981)},
    'Clothing': {'icon': 'checkroom', 'color': Color(0xFFF59E0B)},
  };

  static String getIconForCategory(String categoryName) {
    return _categoryData[categoryName]?['icon'] ?? 'receipt';
  }

  static Color getColorForCategory(String categoryName) {
    return _categoryData[categoryName]?['color'] ?? Colors.grey;
  }

  static IconData getFlutterIcon(String iconName) {
    switch (iconName) {
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'movie':
        return Icons.movie;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'newspaper':
        return Icons.newspaper;
      case 'directions_car':
        return Icons.directions_car;
      case 'home':
        return Icons.home;
      case 'restaurant':
        return Icons.restaurant;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'school':
        return Icons.school;
      case 'flight':
        return Icons.flight;
      case 'electrical_services':
        return Icons.electrical_services;
      case 'security':
        return Icons.security;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'checkroom':
        return Icons.checkroom;
      default:
        return Icons.receipt;
    }
  }
}
