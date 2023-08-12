import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SearchTextField extends StatelessWidget {
  final Function(String) onSubmitted;
  final Function(String) onTap;
  final Function(String) onChanged;
  final TextEditingController controller;
  const SearchTextField({
    super.key,
    required this.onSubmitted,
    required this.onTap,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (value) => onSubmitted(value),
      onChanged: (value) => onChanged(value),
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search for a product',
        hintStyle: const TextStyle(color: greyColor),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () => onTap(controller.text.trim()),
            child: const CircleAvatar(
              backgroundColor: whiteColor,
              child: Icon(
                Icons.search,
                color: greyColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
