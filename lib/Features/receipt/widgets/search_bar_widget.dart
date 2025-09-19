import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'custom_search_field.dart';
import 'filter_button.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterPressed;

  const SearchBarWidget({
    super.key,
    this.searchController,
    this.onSearchChanged,
    this.onSearchTap,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // حقل البحث
          CustomSearchField(
            controller: searchController,
            onChanged: onSearchChanged,
            onTap: onSearchTap,
          ),
          const Gap(8),
          // زر الفلتر
          FilterButton(
            onPressed: onFilterPressed,
          ),
        ],
      ),
    );
  }
}
