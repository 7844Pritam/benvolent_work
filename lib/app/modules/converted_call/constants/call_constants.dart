import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:flutter/material.dart';

class CallConstants {
  static const Map<String, Color> statusColors = {
    'hot': Colors.redAccent,
    'interested': Colors.green,
    'cold': Colors.blueGrey,
    'junk': Colors.grey,
    'new lead': Colors.deepPurple,
  };

  static const Map<String, IconData> statusIcons = {
    'hot': Icons.whatshot,
    'interested': Icons.thumb_up_alt,
    'cold': Icons.ac_unit,
    'junk': Icons.delete,
    'new lead': Icons.fiber_new,
  };

  static const defaultStatusColor = AppColors.primaryColor;
  static const defaultStatusIcon = Icons.label;
}
