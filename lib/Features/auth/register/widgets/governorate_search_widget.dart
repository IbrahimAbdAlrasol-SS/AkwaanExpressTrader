import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:Tosell/Features/auth/register/providers/location_search_provider.dart';

/// Widget للبحث عن المحافظات
class GovernorateSearchWidget extends ConsumerStatefulWidget {
  final Function(Governorate) onGovernorateSelected;
  final Governorate? initialGovernorate;

  const GovernorateSearchWidget({
    super.key,
    required this.onGovernorateSelected,
    this.initialGovernorate,
  });

  @override
  ConsumerState<GovernorateSearchWidget> createState() =>
      _GovernorateSearchWidgetState();
}

class _GovernorateSearchWidgetState
    extends ConsumerState<GovernorateSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialGovernorate != null) {
      _searchController.text = widget.initialGovernorate!.name ?? '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(governorateSearchProvider.notifier).searchGovernorates(query);
    setState(() {
      _isExpanded = query.isNotEmpty;
    });
  }

  void _selectGovernorate(Governorate governorate) {
    _searchController.text = governorate.name ?? '';
    widget.onGovernorateSelected(governorate);
    ref.read(selectedGovernorateProvider.notifier).state = governorate;
    setState(() {
      _isExpanded = false;
    });
    _focusNode.unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(governorateSearchProvider.notifier).loadAllGovernorates();
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(governorateSearchProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان الحقل
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'المحافظة',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // حقل البحث
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? colorScheme.primary
                  : colorScheme.outline,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
            color: colorScheme.surface,
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: _onSearchChanged,
            onTap: () {
              if (!_isExpanded && searchState.governorates.isNotEmpty) {
                setState(() {
                  _isExpanded = true;
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'ابحث عن المحافظة...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: colorScheme.onSurfaceVariant,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: _clearSearch,
                    )
                  : Icon(
                      Icons.keyboard_arrow_down,
                      color: colorScheme.onSurfaceVariant,
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),

        // قائمة النتائج
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline),
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildResultsList(searchState, theme, colorScheme),
          ),
        ],
      ],
    );
  }

  Widget _buildResultsList(
    GovernorateSearchState searchState,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    if (searchState.isLoading) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      );
    }

    if (searchState.error != null) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: colorScheme.error,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'حدث خطأ في تحميل البيانات',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (searchState.governorates.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              color: colorScheme.onSurfaceVariant,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'لا توجد نتائج',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: searchState.governorates.length,
      itemBuilder: (context, index) {
        final governorate = searchState.governorates[index];
        return InkWell(
          onTap: () => _selectGovernorate(governorate),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: index < searchState.governorates.length - 1
                  ? Border(
                      bottom: BorderSide(
                        color: colorScheme.outlineVariant,
                        width: 0.5,
                      ),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_city,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    governorate.name ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
