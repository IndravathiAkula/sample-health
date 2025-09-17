import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SpecialtyFilterWidget extends StatefulWidget {
  final Function(String) onSpecialtySelected;
  final String selectedSpecialty;

  const SpecialtyFilterWidget({
    Key? key,
    required this.onSpecialtySelected,
    required this.selectedSpecialty,
  }) : super(key: key);

  @override
  State<SpecialtyFilterWidget> createState() => _SpecialtyFilterWidgetState();
}

class _SpecialtyFilterWidgetState extends State<SpecialtyFilterWidget> {
  final List<Map<String, dynamic>> specialties = [
    {"name": "All", "icon": "medical_services"},
    {"name": "Primary Care", "icon": "local_hospital"},
    {"name": "Cardiology", "icon": "favorite"},
    {"name": "Dermatology", "icon": "face"},
    {"name": "Orthopedics", "icon": "accessibility"},
    {"name": "Pediatrics", "icon": "child_care"},
    {"name": "Neurology", "icon": "psychology"},
    {"name": "Gynecology", "icon": "pregnant_woman"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: specialties.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final specialty = specialties[index];
          final isSelected = widget.selectedSpecialty == specialty["name"];

          return GestureDetector(
            onTap: () => widget.onSpecialtySelected(specialty["name"]),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: specialty["icon"],
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.primaryColor,
                    size: 18,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    specialty["name"],
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
