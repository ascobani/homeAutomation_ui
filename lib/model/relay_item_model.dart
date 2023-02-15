import 'package:flutter/material.dart';

class RelayItemModel {
  final BuildContext context;
  final String title;
  final bool value;
  final Function(bool) onChanged;
  final IconData icon;

  RelayItemModel(
      {required this.context,
      required this.title,
      required this.value,
      required this.onChanged,
      required this.icon});
}
