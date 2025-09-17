import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/medical_record_card_widget.dart';
import './widgets/record_type_tab_widget.dart';
import './widgets/search_filter_widget.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};
  bool _isSearchExpanded = false;
  List<Map<String, dynamic>> _filteredRecords = [];

  final List<String> _recordTypes = [
    'All Records',
    'Hormone Levels',
    'Medications',
    'Ultrasounds',
    'Cycle Notes',
    'Treatment Plans'
  ];

  final List<Map<String, dynamic>> _mockRecords = [
    {
      "id": 1,
      "title": "Estradiol & FSH Levels",
      "type": "Hormone Levels",
      "provider": "Advanced Fertility Center",
      "date": "07/25/2025",
      "status": "new",
      "summary":
          "Day 3 hormone panel showing good ovarian reserve and estradiol response.",
      "keyFindings":
          "Estradiol: 180 pg/mL (optimal), FSH: 8.2 mIU/mL (normal), AMH: 2.8 ng/mL",
      "thumbnail":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=300&fit=crop",
    },
    {
      "id": 2,
      "title": "Follicle Development Ultrasound",
      "type": "Ultrasounds",
      "provider": "Reproductive Medicine Clinic",
      "date": "07/20/2025",
      "status": "reviewed",
      "summary":
          "Transvaginal ultrasound monitoring follicle growth during stimulation cycle.",
      "keyFindings":
          "3 dominant follicles (18mm, 16mm, 15mm), endometrial lining: 9.2mm",
      "thumbnail":
          "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400&h=300&fit=crop",
    },
    {
      "id": 3,
      "title": "Gonal-F Prescription",
      "type": "Medications",
      "provider": "Fertility Specialists",
      "date": "07/18/2025",
      "status": "action required",
      "summary":
          "Follicle stimulating hormone medication for ovarian stimulation protocol.",
      "keyFindings":
          "225 IU nightly injections, start cycle day 3, monitor with ultrasound.",
      "thumbnail": null,
    },
    {
      "id": 4,
      "title": "IVF Cycle Planning Notes",
      "type": "Cycle Notes",
      "provider": "IVF Coordinator",
      "date": "07/15/2025",
      "status": "reviewed",
      "summary":
          "Comprehensive IVF cycle planning with timeline and medication protocol.",
      "keyFindings":
          "Antagonist protocol selected, expected retrieval date: Aug 5th, 2025",
      "thumbnail": null,
    },
    {
      "id": 5,
      "title": "Embryo Transfer Protocol",
      "type": "Treatment Plans",
      "provider": "Reproductive Endocrinologist",
      "date": "07/10/2025",
      "status": "reviewed",
      "summary": "Frozen embryo transfer preparation and protocol guidelines.",
      "keyFindings":
          "Single embryo transfer planned, progesterone support 5 days prior",
      "thumbnail": null,
    },
    {
      "id": 6,
      "title": "Progesterone Levels",
      "type": "Hormone Levels",
      "provider": "Advanced Fertility Center",
      "date": "07/08/2025",
      "status": "reviewed",
      "summary":
          "Post-ovulation progesterone assessment for luteal phase support.",
      "keyFindings":
          "Progesterone: 22.4 ng/mL (excellent), confirms ovulation occurred",
      "thumbnail":
          "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400&h=300&fit=crop",
    },
    {
      "id": 7,
      "title": "Saline Sonogram",
      "type": "Ultrasounds",
      "provider": "Reproductive Medicine Clinic",
      "date": "07/05/2025",
      "status": "new",
      "summary":
          "Saline infusion sonogram to evaluate uterine cavity before transfer.",
      "keyFindings":
          "Normal uterine cavity, no polyps or fibroids detected, optimal for transfer",
      "thumbnail":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=300&fit=crop",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _recordTypes.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _filteredRecords = List.from(_mockRecords);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
      _filterRecords();
    }
  }

  void _filterRecords() {
    setState(() {
      _filteredRecords = _mockRecords.where((record) {
        // Filter by selected tab
        if (_selectedTabIndex > 0) {
          final selectedType = _recordTypes[_selectedTabIndex];
          if ((record['type'] as String) != selectedType) {
            return false;
          }
        }

        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final title = (record['title'] as String).toLowerCase();
          final provider = (record['provider'] as String).toLowerCase();
          final summary = (record['summary'] as String? ?? '').toLowerCase();

          if (!title.contains(query) &&
              !provider.contains(query) &&
              !summary.contains(query)) {
            return false;
          }
        }

        // Filter by active filters
        if (_activeFilters.isNotEmpty) {
          if (_activeFilters['recordType'] != null &&
              _activeFilters['recordType'] != 'All Types' &&
              (record['type'] as String) != _activeFilters['recordType']) {
            return false;
          }

          if (_activeFilters['provider'] != null &&
              _activeFilters['provider'] != 'All Providers' &&
              (record['provider'] as String) != _activeFilters['provider']) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  int _getRecordCountForType(String type) {
    if (type == 'All Records') {
      return _mockRecords.length;
    }
    return _mockRecords
        .where((record) => (record['type'] as String) == type)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Records',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              'Patient ID: IVF-2025-7891',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
              });
            },
            icon: CustomIconWidget(
              iconName: _isSearchExpanded ? 'close' : 'search',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'sync':
                  _syncRecords();
                  break;
                case 'export':
                  _exportRecords();
                  break;
                case 'settings':
                  _showSettings();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'sync',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'sync',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Sync Records'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'download',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Export All'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          if (_isSearchExpanded)
            SearchFilterWidget(
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
                _filterRecords();
              },
              onFilterChanged: (filters) {
                setState(() {
                  _activeFilters = filters;
                });
                _filterRecords();
              },
            ),

          // Record Type Tabs
          Container(
            height: 12.h,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicator: const BoxDecoration(),
              dividerColor: Colors.transparent,
              labelPadding: EdgeInsets.symmetric(horizontal: 2.w),
              tabs: _recordTypes.asMap().entries.map((entry) {
                final index = entry.key;
                final type = entry.value;
                return RecordTypeTabWidget(
                  title: type,
                  count: _getRecordCountForType(type),
                  isSelected: _selectedTabIndex == index,
                  onTap: () {
                    _tabController.animateTo(index);
                  },
                );
              }).toList(),
            ),
          ),

          // Records List
          Expanded(
            child: _filteredRecords.isEmpty
                ? EmptyStateWidget(
                    onRequestRecords: _requestRecords,
                  )
                : RefreshIndicator(
                    onRefresh: _refreshRecords,
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 12.h),
                      itemCount: _filteredRecords.length,
                      itemBuilder: (context, index) {
                        final record = _filteredRecords[index];
                        return MedicalRecordCardWidget(
                          record: record,
                          onTap: () => _viewRecord(record),
                          onDownload: () => _downloadRecord(record),
                          onShare: () => _shareRecord(record),
                          onAddToHealth: () => _addToHealthApp(record),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _uploadDocument,
        icon: CustomIconWidget(
          iconName: 'upload_file',
          color: Colors.white,
          size: 24,
        ),
        label: Text('Upload'),
      ),
    );
  }

  Future<void> _refreshRecords() async {
    // Simulate API call to refresh records
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fertility records updated successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    }
  }

  void _viewRecord(Map<String, dynamic> record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              record['title'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: CustomIconWidget(
                              iconName: 'close',
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      _buildDetailRow('Provider', record['provider'] as String),
                      _buildDetailRow('Date', record['date'] as String),
                      _buildDetailRow('Type', record['type'] as String),
                      _buildDetailRow('Status', record['status'] as String),
                      SizedBox(height: 3.h),
                      if (record['summary'] != null) ...[
                        Text(
                          'Summary',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          record['summary'] as String,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 3.h),
                      ],
                      if (record['keyFindings'] != null) ...[
                        Text(
                          'Key Findings',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.tertiary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.tertiary
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            record['keyFindings'] as String,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        SizedBox(height: 3.h),
                      ],
                      if (record['thumbnail'] != null) ...[
                        Text(
                          'Document Preview',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          width: double.infinity,
                          height: 30.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CustomImageWidget(
                              imageUrl: record['thumbnail'] as String,
                              width: double.infinity,
                              height: 30.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _downloadRecord(record),
                              icon: CustomIconWidget(
                                iconName: 'download',
                                color: Colors.white,
                                size: 20,
                              ),
                              label: Text('Download'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12), // reduce vertical padding
                                alignment: Alignment.center, // ensure text+icon stay centered
                                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _shareRecord(record),
                              icon: CustomIconWidget(
                                iconName: 'share',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              label: Text('Share'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                alignment: Alignment.center,
                                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _downloadRecord(Map<String, dynamic> record) {
    // Simulate download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${record['title']}...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _shareRecord(Map<String, dynamic> record) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Medical Record',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Email to Doctor'),
              onTap: () {
                Navigator.pop(context);
                _shareViaEmail(record);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Send via Message'),
              onTap: () {
                Navigator.pop(context);
                _shareViaMessage(record);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'cloud_upload',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Upload to Portal'),
              onTap: () {
                Navigator.pop(context);
                _uploadToPortal(record);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareViaEmail(Map<String, dynamic> record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening email to share ${record['title']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _shareViaMessage(Map<String, dynamic> record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening messages to share ${record['title']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _uploadToPortal(Map<String, dynamic> record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Uploading ${record['title']} to patient portal'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _addToHealthApp(Map<String, dynamic> record) {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Health app integration not available on web'),
          backgroundColor: AppTheme.warningLight,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Adding ${record['title']} to Health app'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _uploadDocument() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upload Medical Document',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Take Photo'),
              subtitle: Text('Capture document with camera'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Choose from Gallery'),
              subtitle: Text('Select existing photo'),
              onTap: () {
                Navigator.pop(context);
                _chooseFromGallery();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'attach_file',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Select File'),
              subtitle: Text('Choose PDF or document file'),
              onTap: () {
                Navigator.pop(context);
                _selectFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _takePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening camera to capture fertility document'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _chooseFromGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening gallery to select document'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _selectFile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening file picker to select document'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _syncRecords() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Syncing fertility records from healthcare systems...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _exportRecords() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting all fertility records...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Medical Records Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            SwitchListTile(
              title: Text('Auto-sync Records'),
              subtitle:
                  Text('Automatically sync from fertility clinic providers'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Health App Integration'),
              subtitle: Text('Share fertility data with device health apps'),
              value: false,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Cycle Notification Reminders'),
              subtitle: Text('Get notified about new fertility records'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  void _requestRecords() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request Medical Records'),
        content: Text(
          'Would you like to send a request to your fertility clinic providers to share your IVF records with this app?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Record request sent to your fertility care providers'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              );
            },
            child: Text('Send Request'),
          ),
        ],
      ),
    );
  }
}
