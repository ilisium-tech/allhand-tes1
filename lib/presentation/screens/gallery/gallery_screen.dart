import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/family_controller.dart';
import '../../widgets/family_switcher.dart';

class GalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FamilyController familyController = Get.find<FamilyController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('${familyController.selectedFamilyName} Gallery')),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () => showFamilySwitcherModal(),
            tooltip: 'Switch Family',
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
            tooltip: 'Search Photos',
          ),
        ],
      ),
      body: Obx(() {
        if (familyController.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (familyController.selectedFamily == null) {
          return _buildNoFamilySelected();
        }

        return RefreshIndicator(
          onRefresh: () => familyController.refreshFamilyData(),
          child: CustomScrollView(
            slivers: [
              _buildGalleryHeader(),
              _buildPhotoGrid(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPhotoDialog(),
        child: Icon(Icons.add_a_photo),
        tooltip: 'Add Photo',
      ),
    );
  }

  Widget _buildNoFamilySelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library,
            size: 64,
            color: AppColors.greyLight,
          ),
          SizedBox(height: 16),
          Text(
            'No Family Selected',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please select a family to view photos',
            style: TextStyle(color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => showFamilySwitcherModal(),
            child: Text('Select Family'),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gallery stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total Photos', '127', Icons.photo, AppColors.primary),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('This Month', '23', Icons.calendar_today, AppColors.secondary),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Favorites', '45', Icons.favorite, AppColors.error),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Filter tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', true),
                  _buildFilterChip('Recent', false),
                  _buildFilterChip('Favorites', false),
                  _buildFilterChip('Events', false),
                  _buildFilterChip('People', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Handle filter selection
        },
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
      ),
    );
  }

  Widget _buildPhotoGrid() {
    // Mock photo data
    final photos = List.generate(20, (index) => {
      'id': index,
      'url': 'https://picsum.photos/300/300?random=$index',
      'title': 'Family Photo ${index + 1}',
      'date': DateTime.now().subtract(Duration(days: index)),
      'isFavorite': index % 3 == 0,
    });

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final photo = photos[index];
            return _buildPhotoCard(photo);
          },
          childCount: photos.length,
        ),
      ),
    );
  }

  Widget _buildPhotoCard(Map<String, dynamic> photo) {
    return GestureDetector(
      onTap: () => _showPhotoDetail(photo),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Photo
              Image.network(
                photo['url'],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.greyLight.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.greyLight.withOpacity(0.3),
                    child: Icon(
                      Icons.broken_image,
                      color: AppColors.grey,
                      size: 32,
                    ),
                  );
                },
              ),
              
              // Gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Photo info
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      photo['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _formatDate(photo['date']),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Favorite icon
              if (photo['isFavorite'])
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: AppColors.error,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '${difference}d ago';
    if (difference < 30) return '${(difference / 7).floor()}w ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showPhotoDetail(Map<String, dynamic> photo) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            // Photo
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                child: Image.network(
                  photo['url'],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            // Close button
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Search Photos'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Search by name, date, or event...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Search',
                'Search functionality will be implemented soon!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showAddPhotoDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Add Photo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take Photo'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Camera',
                  'Camera functionality will be implemented soon!',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Gallery',
                  'Gallery picker will be implemented soon!',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}