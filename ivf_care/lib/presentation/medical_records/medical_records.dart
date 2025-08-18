import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/document_card.dart';
import './widgets/document_category_chip.dart';
import './widgets/document_context_menu.dart';
import './widgets/document_upload_sheet.dart';
import './widgets/empty_state_widget.dart';

class MedicalRecords extends StatefulWidget {
  const MedicalRecords({super.key});

  @override
  State<MedicalRecords> createState() => _MedicalRecordsState();
}

class _MedicalRecordsState extends State<MedicalRecords>
    with TickerProviderStateMixin {
  int _currentBottomIndex = 2; // Records tab active
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isRefreshing = false;
  DateTime _lastUpdated = DateTime.now();

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock data for medical documents
  final List<Map<String, dynamic>> _allDocuments = [
    {
      "id": 1,
      "title": "Blood Test Results - Complete Panel",
      "type": "lab",
      "category": "Lab Results",
      "date": "15 Jan 2025",
      "fileSize": "2.4 MB",
      "status": "new",
      "thumbnail":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=400&fit=crop",
      "uploadDate": DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      "id": 2,
      "title": "Fertility Medication Prescription",
      "type": "prescription",
      "category": "Prescriptions",
      "date": "12 Jan 2025",
      "fileSize": "1.8 MB",
      "status": "viewed",
      "thumbnail": "",
      "uploadDate": DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      "id": 3,
      "title": "Ultrasound Scan - Follicle Monitoring",
      "type": "image",
      "category": "Images",
      "date": "10 Jan 2025",
      "fileSize": "3.2 MB",
      "status": "shared",
      "thumbnail":
          "https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?w=400&h=400&fit=crop",
      "uploadDate": DateTime.now().subtract(const Duration(days: 7)),
    },
    {
      "id": 4,
      "title": "IVF Treatment Plan Report",
      "type": "report",
      "category": "Reports",
      "date": "08 Jan 2025",
      "fileSize": "4.1 MB",
      "status": "viewed",
      "thumbnail": "",
      "uploadDate": DateTime.now().subtract(const Duration(days: 9)),
    },
    {
      "id": 5,
      "title": "Insurance Coverage Details",
      "type": "insurance",
      "category": "Insurance",
      "date": "05 Jan 2025",
      "fileSize": "1.2 MB",
      "status": "new",
      "thumbnail": "",
      "uploadDate": DateTime.now().subtract(const Duration(days: 12)),
    },
    {
      "id": 6,
      "title": "Hormone Level Analysis",
      "type": "lab",
      "category": "Lab Results",
      "date": "03 Jan 2025",
      "fileSize": "2.8 MB",
      "status": "viewed",
      "thumbnail": "",
      "uploadDate": DateTime.now().subtract(const Duration(days: 14)),
    },
  ];

  final List<String> _categories = [
    'All',
    'Lab Results',
    'Prescriptions',
    'Images',
    'Reports',
    'Insurance',
  ];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredDocuments {
    List<Map<String, dynamic>> filtered = _allDocuments;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((doc) => doc['category'] == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((doc) {
        final title = (doc['title'] as String).toLowerCase();
        final category = (doc['category'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || category.contains(query);
      }).toList();
    }

    // Sort by upload date (newest first)
    filtered.sort((a, b) =>
        (b['uploadDate'] as DateTime).compareTo(a['uploadDate'] as DateTime));

    return filtered;
  }

  int _getCategoryCount(String category) {
    if (category == 'All') return _allDocuments.length;
    return _allDocuments.where((doc) => doc['category'] == category).length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: CustomAppBar(
        title: 'Medical Records',
        actions: [
          // Search icon
          IconButton(
            onPressed: _showSearchDialog,
            icon: CustomIconWidget(
              iconName: 'search',
              color: colorScheme.primary,
              size: 6.w,
            ),
            tooltip: 'Search Documents',
          ),
          // Filter icon
          IconButton(
            onPressed: _showFilterDialog,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: colorScheme.primary,
              size: 6.w,
            ),
            tooltip: 'Filter Documents',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDocuments,
        color: colorScheme.primary,
        child: Column(
          children: [
            // Category chips
            Container(
              height: 8.h,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final count = _getCategoryCount(category);

                  return DocumentCategoryChip(
                    label: category,
                    isSelected: _selectedCategory == category,
                    count: count,
                    onTap: () => _selectCategory(category),
                  );
                },
              ),
            ),
            // Search results info
            if (_searchQuery.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'search',
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Showing ${_filteredDocuments.length} results for "$_searchQuery"',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _clearSearch,
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 4.w,
                      ),
                    ),
                  ],
                ),
              ),
            // Last updated info
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'sync',
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 3.5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Last updated: ${_formatLastUpdated(_lastUpdated)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
            // Documents list
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _filteredDocuments.isEmpty
                      ? EmptyStateWidget(
                          category: _selectedCategory,
                          onUploadPressed: _showUploadSheet,
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(bottom: 2.h),
                          itemCount: _filteredDocuments.length,
                          itemBuilder: (context, index) {
                            final document = _filteredDocuments[index];
                            return DocumentCard(
                              document: document,
                              onTap: () => _viewDocument(document),
                              onLongPress: () => _showContextMenu(document),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUploadSheet,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        tooltip: 'Upload Document',
        child: CustomIconWidget(
          iconName: 'add',
          color: colorScheme.onPrimary,
          size: 7.w,
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 2.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      height: 1.5.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _loadDocuments() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _lastUpdated = DateTime.now();
        });
      }
    });
  }

  Future<void> _refreshDocuments() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _lastUpdated = DateTime.now();
      });

      Fluttertoast.showToast(
        msg: "Documents refreshed successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search Documents'),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter document name or category...',
              prefixIcon: Icon(Icons.search),
            ),
            autofocus: true,
            onSubmitted: (value) {
              Navigator.pop(context);
              _performSearch(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _performSearch(_searchController.text);
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Documents'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _categories.map((category) {
              return RadioListTile<String>(
                title: Text(category),
                subtitle: Text('${_getCategoryCount(category)} documents'),
                value: category,
                groupValue: _selectedCategory,
                onChanged: (value) {
                  Navigator.pop(context);
                  _selectCategory(value!);
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _viewDocument(Map<String, dynamic> document) {
    // Mark as viewed
    setState(() {
      document['status'] = 'viewed';
    });

    // Show document viewer (placeholder)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(document['title'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if ((document['thumbnail'] as String).isNotEmpty)
              CustomImageWidget(
                imageUrl: document['thumbnail'] as String,
                width: 60.w,
                height: 30.h,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: 60.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'description',
                    color: Theme.of(context).colorScheme.primary,
                    size: 15.w,
                  ),
                ),
              ),
            SizedBox(height: 2.h),
            Text(
                'Document viewer would open here with full functionality including pinch-to-zoom, rotation, and sharing options.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(Map<String, dynamic> document) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DocumentContextMenu(
        document: document,
        onDownload: () => _downloadDocument(document),
        onShare: () => _shareDocument(document),
        onDelete: () => _deleteDocument(document),
        onAddNotes: () => _addNotesToDocument(document),
      ),
    );
  }

  void _showUploadSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DocumentUploadSheet(
        onFileSelected: _handleFileUpload,
      ),
    );
  }

  void _handleFileUpload(String source, dynamic file) {
    Fluttertoast.showToast(
      msg: "Document uploaded successfully from $source",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    // Add new document to list (mock)
    setState(() {
      _allDocuments.insert(0, {
        "id": _allDocuments.length + 1,
        "title": "New Document - ${DateTime.now().day}/${DateTime.now().month}",
        "type": "report",
        "category": "Reports",
        "date":
            "${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}",
        "fileSize": "1.5 MB",
        "status": "new",
        "thumbnail": "",
        "uploadDate": DateTime.now(),
      });
    });
  }

  void _downloadDocument(Map<String, dynamic> document) {
    Fluttertoast.showToast(
      msg: "Downloading ${document['title']}...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _shareDocument(Map<String, dynamic> document) {
    Fluttertoast.showToast(
      msg: "Sharing ${document['title']}...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _deleteDocument(Map<String, dynamic> document) {
    setState(() {
      _allDocuments.removeWhere((doc) => doc['id'] == document['id']);
    });

    Fluttertoast.showToast(
      msg: "Document deleted successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _addNotesToDocument(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController notesController = TextEditingController();
        return AlertDialog(
          title: Text('Add Notes'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                document['title'] as String,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  hintText: 'Add your personal notes...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "Notes added successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _currentBottomIndex) return;

    setState(() {
      _currentBottomIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard-home');
        break;
      case 1:
        Navigator.pushNamed(context, '/appointment-booking');
        break;
      case 2:
        // Current screen - do nothing
        break;
      case 3:
        Navigator.pushNamed(context, '/medication-reminders');
        break;
      case 4:
        Navigator.pushNamed(context, '/payment-processing');
        break;
    }
  }

  String _formatLastUpdated(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
