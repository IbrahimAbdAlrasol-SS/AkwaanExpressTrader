import 'package:Tosell/Features/settings/widgets/support_enum.dart';
import 'package:Tosell/Features/settings/widgets/support_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupportCardItem extends StatelessWidget {
  final SupportModel support;
  final VoidCallback onTap;
  final bool isExpanded;

  const SupportCardItem({
    super.key,
    required this.support,
    required this.onTap,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final status =
        SupportStatus.values[support.statusIndex % SupportStatus.values.length];
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Container(
      key: ValueKey(support.id),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Material(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Right Side: Icon + Text
                    Flexible(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: theme.colorScheme.surface,
                            child: SvgPicture.asset(
                              'assets/svg/support.svg',
                              width: 24,
                              height: 24,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  support.id,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  support.time,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status Badge
                    Container(
                      constraints: const BoxConstraints(minWidth: 80),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: status.getBackgroundColor(isDarkTheme),
                        borderRadius: BorderRadius.circular(20),
                        border: isDarkTheme
                            ? Border.all(
                                color: status
                                    .getTextColor(isDarkTheme)
                                    .withOpacity(0.3),
                                width: 1,
                              )
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          status.name,
                          style: TextStyle(
                            color: status.getTextColor(isDarkTheme),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Description
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: theme.colorScheme.outline, width: 1),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/3line.svg',
                          width: 16,
                          height: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            support.description,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: isExpanded ? null : 1,
                            overflow: isExpanded ? null : TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
