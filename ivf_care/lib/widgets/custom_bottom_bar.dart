import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data model for bottom navigation
class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Custom Bottom Navigation Bar for healthcare IVF application
/// Implements Therapeutic Minimalism with gentle confidence
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool showLabels;
  final double elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.showLabels = true,
    this.elevation = 8.0,
  });

  // Hardcoded navigation items for healthcare IVF app
  static const List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
      route: '/dashboard-home',
    ),
    NavigationItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today_rounded,
      label: 'Appointments',
      route: '/appointment-booking',
    ),
    NavigationItem(
      icon: Icons.folder_outlined,
      activeIcon: Icons.folder_rounded,
      label: 'Records',
      route: '/medical-records',
    ),
    NavigationItem(
      icon: Icons.medication_outlined,
      activeIcon: Icons.medication_rounded,
      label: 'Medications',
      route: '/medication-reminders',
    ),
    NavigationItem(
      icon: Icons.person_rounded,
      activeIcon: Icons.person_outline_rounded,
      label: 'Profile',
      route: '/profile-settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () {
                    onTap(index);
                    if (ModalRoute.of(context)?.settings.name != item.route) {
                      Navigator.pushNamed(context, item.route);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon with gentle scaling animation
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary.withAlpha(31)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            size: 24,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Label with fade animation
                        if (showLabels)
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withAlpha(153),
                              letterSpacing: 0.4,
                            ),
                            child: Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Floating Action Button variant for primary healthcare actions
class CustomFloatingBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback? onFabPressed;
  final IconData fabIcon;
  final String fabTooltip;

  const CustomFloatingBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onFabPressed,
    this.fabIcon = Icons.add_rounded,
    this.fabTooltip = 'Quick Action',
  });

  // Reduced navigation items for FAB variant
  static const List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
      route: '/dashboard-home',
    ),
    NavigationItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today_rounded,
      label: 'Appointments',
      route: '/appointment-booking',
    ),
    NavigationItem(
      icon: Icons.folder_outlined,
      activeIcon: Icons.folder_rounded,
      label: 'Records',
      route: '/medical-records',
    ),
    NavigationItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
      route: '/profile-settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Bottom navigation bar
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withAlpha(31),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // First two items
                  ..._navigationItems.take(2).toList().asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = currentIndex == index;

                    return _buildNavItem(context, item, index, isSelected);
                  }),
                  // Spacer for FAB
                  const SizedBox(width: 56),
                  // Last two items
                  ..._navigationItems.skip(2).toList().asMap().entries.map((entry) {
                    final index = entry.key + 2;
                    final item = entry.value;
                    final isSelected = currentIndex == index;

                    return _buildNavItem(context, item, index, isSelected);
                  }),
                ],
              ),
            ),
          ),
        ),
        // Floating Action Button
        Positioned(
          top: -28,
          left: MediaQuery.of(context).size.width / 2 - 28,
          child: FloatingActionButton(
            onPressed: onFabPressed ??
                () {
                  Navigator.pushNamed(context, '/appointment-booking');
                },
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 8,
            tooltip: fabTooltip,
            child: Icon(fabIcon, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
      BuildContext context, NavigationItem item, int index, bool isSelected) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: InkWell(
        onTap: () {
          onTap(index);
          if (ModalRoute.of(context)?.settings.name != item.route) {
            Navigator.pushNamed(context, item.route);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? item.activeIcon : item.icon,
                size: 24,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withAlpha(153),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withAlpha(153),
                  letterSpacing: 0.4,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}