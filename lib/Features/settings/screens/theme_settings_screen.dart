import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/config/theme/ThemeNotifier.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          children: [
            const CustomAppBar(
              title: "إعدادات المظهر",
              showBackButton: true,
            ),
            const Gap(AppSpaces.large),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "اختر مظهر التطبيق",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                        fontFamily: "Tajawal",
                      ),
                    ),
                    const Gap(AppSpaces.medium),
                    Text(
                      "يمكنك اختيار المظهر المفضل لديك للتطبيق",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.secondary,
                        fontFamily: "Tajawal",
                      ),
                    ),
                    const Gap(AppSpaces.large),
                    _buildThemeOption(
                      context,
                      theme,
                      "الوضع الفاتح",
                      "مظهر فاتح ومريح للعينين",
                      Icons.light_mode,
                      ThemeMode.light,
                      currentTheme,
                      () => themeNotifier.setTheme(ThemeMode.light),
                    ),
                    const Gap(AppSpaces.medium),
                    _buildThemeOption(
                      context,
                      theme,
                      "الوضع المظلم",
                      "مظهر مظلم يوفر الطاقة ومريح في الإضاءة المنخفضة",
                      Icons.dark_mode,
                      ThemeMode.dark,
                      currentTheme,
                      () => themeNotifier.setTheme(ThemeMode.dark),
                    ),
                    const Gap(AppSpaces.medium),
                    _buildThemeOption(
                      context,
                      theme,
                      "تلقائي (حسب النظام)",
                      "يتبع إعدادات النظام تلقائياً",
                      Icons.auto_mode,
                      ThemeMode.system,
                      currentTheme,
                      () => themeNotifier.setTheme(ThemeMode.system),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
    ThemeMode themeMode,
    ThemeMode currentTheme,
    VoidCallback onTap,
  ) {
    final isSelected = currentTheme == themeMode;

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
       onTap: onTap,
       child: Container(
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(
           color: isSelected
               ? theme.colorScheme.primary.withOpacity(0.1)
               : theme.colorScheme.surface,
           border: Border.all(
             color: isSelected
                 ? theme.colorScheme.primary
                 : theme.colorScheme.outline,
             width: isSelected ? 2 : 1,
           ),
           borderRadius: BorderRadius.circular(12),
         ),
         child: Row(
           children: [
             Container(
               padding: const EdgeInsets.all(8),
               decoration: BoxDecoration(
                 color: isSelected
                     ? theme.colorScheme.primary
                     : theme.colorScheme.outline.withOpacity(0.3),
                 borderRadius: BorderRadius.circular(8),
               ),
               child: Icon(
                 icon,
                 color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                 size: 24,
               ),
             ),
             const Gap(AppSpaces.medium),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     title,
                     style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.w600,
                       color: isSelected
                           ? theme.colorScheme.primary
                           : theme.colorScheme.onSurface,
                       fontFamily: "Tajawal",
                     ),
                   ),
                   const Gap(4),
                   Text(
                     subtitle,
                     style: TextStyle(
                       fontSize: 12,
                       fontWeight: FontWeight.w400,
                       color: theme.colorScheme.secondary,
                       fontFamily: "Tajawal",
                     ),
                   ),
                 ],
               ),
             ),
             if (isSelected)
               Icon(
                 Icons.check_circle,
                 color: theme.colorScheme.primary,
                 size: 24,
               ),
           ],
         ),
       ),
     );
  }
}
