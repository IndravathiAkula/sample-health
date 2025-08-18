import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget for healthcare IVF application
/// Implements Therapeutic Minimalism design with gentle confidence
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool showNotificationBadge;
  final int notificationCount;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.showNotificationBadge = false,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? colorScheme.primary,
          letterSpacing: 0.15,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.primary,
      elevation: elevation,
      surfaceTintColor: Colors.transparent,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: foregroundColor ?? colorScheme.primary,
                    size: 20,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                  tooltip: 'Back',
                )
              : null),
      actions: [
        ...?actions,
        // Notification icon with badge
        if (showNotificationBadge)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: foregroundColor ?? colorScheme.primary,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/medication-reminders');
                  },
                  tooltip: 'Notifications',
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        notificationCount > 99
                            ? '99+'
                            : notificationCount.toString(),
                        style: GoogleFonts.roboto(
                          color: theme.colorScheme.onError,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        // Profile/Settings icon
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: Icon(
              Icons.person_outline_rounded,
              color: foregroundColor ?? colorScheme.primary,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/profile-settings');
            },
            tooltip: 'Profile',
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Variant of CustomAppBar for dashboard/home screen
class CustomDashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String greeting;
  final String userName;
  final bool showNotificationBadge;
  final int notificationCount;

  const CustomDashboardAppBar({
    super.key,
    this.greeting = 'Good Morning',
    required this.userName,
    this.showNotificationBadge = true,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: theme.textTheme.bodyMedium?.color,
              letterSpacing: 0.25,
            ),
          ),
          Text(
            userName,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
              letterSpacing: 0.15,
            ),
          ),
        ],
      ),
      actions: [
        // Quick access to appointment booking
        IconButton(
          icon: Icon(
            Icons.calendar_today_outlined,
            color: colorScheme.primary,
            size: 24,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/appointment-booking');
          },
          tooltip: 'Book Appointment',
        ),
        // Notification icon with badge
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: colorScheme.primary,
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/medication-reminders');
                },
                tooltip: 'Notifications',
              ),
              if (showNotificationBadge && notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      notificationCount > 99
                          ? '99+'
                          : notificationCount.toString(),
                      style: GoogleFonts.roboto(
                        color: colorScheme.onError,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Profile icon
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: Icon(
              Icons.person_outline_rounded,
              color: colorScheme.primary,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/profile-settings');
            },
            tooltip: 'Profile',
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
