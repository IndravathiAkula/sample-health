import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchFilterWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(Map<String, dynamic>) onFilterChanged;

  const SearchFilterWidget({
    super.key,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDateRange = 'All Time';
  String _selectedRecordType = 'All Types';
  String _selectedProvider = 'All Providers';

  final List<String> _dateRanges = [
    'All Time',
    'Last 30 Days',
    'Last 3 Months',
    'Last 6 Months',
    'Last Year',
    'Custom Range'
  ];

  final List<String> _recordTypes = [
    'All Types',
    'Lab Results',
    'Prescriptions',
    'Imaging',
    'Visit Notes',
    'Immunizations'
  ];

  final List<String> _providers = [
    'All Providers',
    'City General Hospital',
    'MedCare Clinic',
    'HealthFirst Center',
    'Wellness Medical Group',
    'Downtown Family Practice'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search records, providers, conditions...',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.7),
                    ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearchChanged('');
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Filter Options
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Date Range',
                  value: _selectedDateRange,
                  items: _dateRanges,
                  onChanged: (value) {
                    setState(() => _selectedDateRange = value!);
                    _updateFilters();
                  },
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Type',
                  value: _selectedRecordType,
                  items: _recordTypes,
                  onChanged: (value) {
                    setState(() => _selectedRecordType = value!);
                    _updateFilters();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Provider',
                  value: _selectedProvider,
                  items: _providers,
                  onChanged: (value) {
                    setState(() => _selectedProvider = value!);
                    _updateFilters();
                  },
                ),
              ),
              SizedBox(width: 2.w),
              ElevatedButton.icon(
                onPressed: _resetFilters,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: Colors.white,
                  size: 16,
                ),
                label: Text(
                  'Reset',
                  style: TextStyle(fontSize: 12.sp),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  minimumSize: Size(0, 5.h),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 0.5.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.5),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              isExpanded: true,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 12.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _updateFilters() {
    widget.onFilterChanged({
      'dateRange': _selectedDateRange,
      'recordType': _selectedRecordType,
      'provider': _selectedProvider,
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedDateRange = 'All Time';
      _selectedRecordType = 'All Types';
      _selectedProvider = 'All Providers';
    });
    _updateFilters();
  }
}
