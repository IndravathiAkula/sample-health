import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab item data model for custom tab bar
class TabItem {
  final String label;
  final IconData? icon;
  final Widget? customIcon;
  final String? route;

  const TabItem({
    required this.label,
    this.icon,
    this.customIcon,
    this.route,
  });
}

/// Custom Tab Bar for healthcare IVF application
/// Implements Therapeutic Minimalism with gentle transitions
class CustomTabBar extends StatelessWidget {
  final List<TabItem> tabs;
  final int currentIndex;
  final Function(int) onTap;
  final bool isScrollable;
  final TabAlignment tabAlignment;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double indicatorWeight;
  final bool showIcons;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.isScrollable = false,
    this.tabAlignment = TabAlignment.center,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor,
    this.indicatorColor,
    this.indicatorWeight = 3.0,
    this.showIcons = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: backgroundColor ?? colorScheme.surface,
      padding: padding,
      child: TabBar(
        tabs: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = currentIndex == index;

          return Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showIcons &&
                      (tab.icon != null || tab.customIcon != null)) ...[
                    tab.customIcon ??
                        Icon(
                          tab.icon,
                          size: 20,
                          color: isSelected
                              ? indicatorColor ?? colorScheme.primary
                              : colorScheme.onSurface.withAlpha(153),
                        ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    tab.label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? indicatorColor ?? colorScheme.primary
                          : colorScheme.onSurface.withAlpha(153),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        onTap: (index) {
          onTap(index);
          final tab = tabs[index];
          if (tab.route != null) {
            Navigator.pushNamed(context, tab.route!);
          }
        },
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
        indicatorColor: indicatorColor ?? colorScheme.primary,
        indicatorWeight: indicatorWeight,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: indicatorColor ?? colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withAlpha(153),
        overlayColor: WidgetStateProperty.all(
          (indicatorColor ?? colorScheme.primary).withAlpha(20),
        ),
        splashFactory: InkRipple.splashFactory,
        dividerColor: Colors.transparent,
      ),
    );
  }
}

/// Medical Records Tab Bar - Specialized for healthcare data organization
class CustomMedicalRecordsTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomMedicalRecordsTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<TabItem> _medicalTabs = [
    TabItem(
      label: 'Overview',
      icon: Icons.dashboard_outlined,
    ),
    TabItem(
      label: 'Lab Results',
      icon: Icons.science_outlined,
    ),
    TabItem(
      label: 'Prescriptions',
      icon: Icons.medication_outlined,
    ),
    TabItem(
      label: 'Reports',
      icon: Icons.description_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      tabs: _medicalTabs,
      currentIndex: currentIndex,
      onTap: onTap,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      showIcons: true,
    );
  }
}

/// Appointment Booking Tab Bar - For scheduling workflow
class CustomAppointmentTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomAppointmentTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<TabItem> _appointmentTabs = [
    TabItem(
      label: 'Book New',
      icon: Icons.add_circle_outline,
    ),
    TabItem(
      label: 'Upcoming',
      icon: Icons.schedule_outlined,
    ),
    TabItem(
      label: 'History',
      icon: Icons.history_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      tabs: _appointmentTabs,
      currentIndex: currentIndex,
      onTap: onTap,
      showIcons: true,
    );
  }
}

/// Payment Processing Tab Bar - For financial transactions
class CustomPaymentTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomPaymentTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<TabItem> _paymentTabs = [
    TabItem(
      label: 'Pay Bills',
      icon: Icons.payment_outlined,
    ),
    TabItem(
      label: 'History',
      icon: Icons.receipt_long_outlined,
    ),
    TabItem(
      label: 'Insurance',
      icon: Icons.health_and_safety_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      tabs: _paymentTabs,
      currentIndex: currentIndex,
      onTap: onTap,
      showIcons: true,
    );
  }
}

/// Profile Settings Tab Bar - For user preferences and account management
class CustomProfileTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomProfileTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<TabItem> _profileTabs = [
    TabItem(
      label: 'Personal',
      icon: Icons.person_outline,
    ),
    TabItem(
      label: 'Medical Info',
      icon: Icons.medical_information_outlined,
    ),
    TabItem(
      label: 'Preferences',
      icon: Icons.settings_outlined,
    ),
    TabItem(
      label: 'Privacy',
      icon: Icons.privacy_tip_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      tabs: _profileTabs,
      currentIndex: currentIndex,
      onTap: onTap,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      showIcons: true,
    );
  }
}

/// Segmented Tab Bar - Alternative design for binary choices
class CustomSegmentedTabBar extends StatelessWidget {
  final List<TabItem> tabs;
  final int currentIndex;
  final Function(int) onTap;
  final EdgeInsetsGeometry margin;
  final double borderRadius;

  const CustomSegmentedTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.margin = const EdgeInsets.all(16),
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: colorScheme.outline.withAlpha(51),
          width: 1,
        ),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = currentIndex == index;
          final isFirst = index == 0;
          final isLast = index == tabs.length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                onTap(index);
                if (tab.route != null) {
                  Navigator.pushNamed(context, tab.route!);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(isFirst ? borderRadius - 1 : 0),
                    right: Radius.circular(isLast ? borderRadius - 1 : 0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (tab.icon != null || tab.customIcon != null) ...[
                      tab.customIcon ??
                          Icon(
                            tab.icon,
                            size: 18,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface.withAlpha(153),
                          ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      tab.label,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface.withAlpha(153),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
