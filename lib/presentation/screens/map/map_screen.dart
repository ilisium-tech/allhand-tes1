import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/family_controller.dart';
import '../../widgets/family_switcher.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FamilyController familyController = Get.find<FamilyController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('${familyController.selectedFamilyName} Map')),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () => showFamilySwitcherModal(),
            tooltip: 'Switch Family',
          ),
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () => _centerOnUserLocation(),
            tooltip: 'My Location',
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

        return Stack(
          children: [
            // Map placeholder (would be replaced with actual map widget)
            _buildMapPlaceholder(),
            
            // Family members list overlay
            _buildMembersOverlay(),
            
            // Map controls
            _buildMapControls(),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLocationDialog(),
        child: Icon(Icons.add_location),
        tooltip: 'Add Location',
      ),
    );
  }

  Widget _buildNoFamilySelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map,
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
            'Please select a family to view locations',
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

  Widget _buildMapPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.1),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Grid pattern to simulate map
          CustomPaint(
            size: Size.infinite,
            painter: GridPainter(),
          ),
          
          // Mock family member locations
          ..._buildMockLocations(),
        ],
      ),
    );
  }

  List<Widget> _buildMockLocations() {
    final locations = [
      {'name': 'John Smith', 'lat': 0.3, 'lng': 0.4, 'status': 'online'},
      {'name': 'Jane Smith', 'lat': 0.6, 'lng': 0.3, 'status': 'offline'},
      {'name': 'Mike Smith', 'lat': 0.2, 'lng': 0.7, 'status': 'online'},
      {'name': 'Sarah Smith', 'lat': 0.8, 'lng': 0.6, 'status': 'away'},
    ];

    return locations.map((location) {
      return Positioned(
        left: MediaQuery.of(Get.context!).size.width * location['lng'] as double,
        top: MediaQuery.of(Get.context!).size.height * location['lat'] as double,
        child: _buildLocationMarker(location),
      );
    }).toList();
  }

  Widget _buildLocationMarker(Map<String, dynamic> location) {
    Color statusColor;
    switch (location['status']) {
      case 'online':
        statusColor = AppColors.success;
        break;
      case 'away':
        statusColor = AppColors.warning;
        break;
      default:
        statusColor = AppColors.grey;
    }

    return GestureDetector(
      onTap: () => _showMemberLocationDetail(location),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: statusColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.person,
          color: statusColor,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMembersOverlay() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Card(
        child: Container(
          height: 120,
          padding: EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Family Members',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildMemberChip('John Smith', AppColors.success, true),
                    _buildMemberChip('Jane Smith', AppColors.grey, false),
                    _buildMemberChip('Mike Smith', AppColors.success, true),
                    _buildMemberChip('Sarah Smith', AppColors.warning, true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberChip(String name, Color statusColor, bool isVisible) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 6),
          Text(
            name.split(' ').first,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          if (!isVisible) ...[
            SizedBox(width: 4),
            Icon(
              Icons.visibility_off,
              size: 12,
              color: AppColors.textSecondary,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      bottom: 100,
      right: 16,
      child: Column(
        children: [
          FloatingActionButton.small(
            onPressed: () => _zoomIn(),
            child: Icon(Icons.add),
            heroTag: 'zoom_in',
          ),
          SizedBox(height: 8),
          FloatingActionButton.small(
            onPressed: () => _zoomOut(),
            child: Icon(Icons.remove),
            heroTag: 'zoom_out',
          ),
          SizedBox(height: 8),
          FloatingActionButton.small(
            onPressed: () => _toggleMapType(),
            child: Icon(Icons.layers),
            heroTag: 'map_type',
          ),
        ],
      ),
    );
  }

  void _showMemberLocationDetail(Map<String, dynamic> location) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.largeBorderRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Member info
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Status: ${location['status']}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Location details
            _buildLocationDetail('Last seen', '2 minutes ago'),
            _buildLocationDetail('Location', 'Downtown Coffee Shop'),
            _buildLocationDetail('Address', '123 Main St, City, State'),
            
            SizedBox(height: 16),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Message',
                        'Message feature will be implemented soon!',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: Icon(Icons.message),
                    label: Text('Message'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Directions',
                        'Navigation will be implemented soon!',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: Icon(Icons.directions),
                    label: Text('Directions'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildLocationDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _centerOnUserLocation() {
    Get.snackbar(
      'Location',
      'Centering on your location...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _zoomIn() {
    Get.snackbar(
      'Map',
      'Zooming in...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _zoomOut() {
    Get.snackbar(
      'Map',
      'Zooming out...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _toggleMapType() {
    Get.snackbar(
      'Map',
      'Switching map type...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showAddLocationDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Add Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Location Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
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
                'Success',
                'Location added successfully!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.greyLight.withOpacity(0.3)
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}