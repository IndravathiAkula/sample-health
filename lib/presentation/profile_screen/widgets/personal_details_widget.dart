import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PersonalDetailsWidget extends StatefulWidget {
  final Map<String, dynamic> personalDetails;
  final Function(Map<String, dynamic>) onUpdateDetails;

  const PersonalDetailsWidget({
    super.key,
    required this.personalDetails,
    required this.onUpdateDetails,
  });

  @override
  State<PersonalDetailsWidget> createState() => _PersonalDetailsWidgetState();
}

class _PersonalDetailsWidgetState extends State<PersonalDetailsWidget> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _emergencyController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  /// 🔄 Reinitialize controllers when parent passes new details
  @override
  void didUpdateWidget(covariant PersonalDetailsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.personalDetails != widget.personalDetails) {
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    _nameController =
        TextEditingController(text: widget.personalDetails['name'] ?? '');
    _emailController =
        TextEditingController(text: widget.personalDetails['email'] ?? '');
    _phoneController =
        TextEditingController(text: widget.personalDetails['phone'] ?? '');
    _dobController =
        TextEditingController(text: widget.personalDetails['dob'] ?? '');
    _emergencyController = TextEditingController(
        text: widget.personalDetails['emergencyContact'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });

    // If cancelling edit → reset controllers with latest details
    if (!_isEditing) {
      _initializeControllers();
    }
  }

  void _saveDetails() {
    final updatedDetails = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'dob': _dobController.text,
      'emergencyContact': _emergencyController.text,
    };

    widget.onUpdateDetails(updatedDetails);

    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personal Details',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: _toggleEdit,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _isEditing
                        ? AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _isEditing ? 'close' : 'edit',
                    size: 5.w,
                    color: _isEditing
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Fields
          _buildDetailField(
            label: 'Full Name',
            controller: _nameController,
            icon: 'person',
          ),
          SizedBox(height: 2.h),
          _buildDetailField(
            label: 'Email Address',
            controller: _emailController,
            icon: 'email',
          ),
          SizedBox(height: 2.h),
          _buildDetailField(
            label: 'Phone Number',
            controller: _phoneController,
            icon: 'phone',
          ),
          SizedBox(height: 2.h),
          _buildDetailField(
            label: 'Date of Birth',
            controller: _dobController,
            icon: 'cake',
          ),
          SizedBox(height: 2.h),
          _buildDetailField(
            label: 'Emergency Contact',
            controller: _emergencyController,
            icon: 'emergency',
          ),

          // Action buttons when editing
          if (_isEditing) ...[
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _toggleEdit,
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveDetails,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailField({
    required String label,
    required TextEditingController controller,
    required String icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: _isEditing
                ? AppTheme.lightTheme.colorScheme.surface
                : AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isEditing
                  ? AppTheme.lightTheme.colorScheme.outline
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            readOnly: !_isEditing, // ✅ Shows text always, editable only in edit mode
            style: AppTheme.lightTheme.textTheme.bodyLarge,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: icon,
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 3.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
