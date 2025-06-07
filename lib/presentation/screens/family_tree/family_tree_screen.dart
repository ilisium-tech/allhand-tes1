import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/family_controller.dart';
import '../../widgets/family_switcher.dart';

class FamilyTreeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FamilyController familyController = Get.find<FamilyController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(familyController.selectedFamilyName)),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () => showFamilySwitcherModal(),
            tooltip: 'Switch Family',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => familyController.refreshFamilyData(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (familyController.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (familyController.selectedFamily == null) {
          return _buildNoFamilySelected();
        }

        return RefreshIndicator(
          onRefresh: () => familyController.refreshFamilyData(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFamilyHeader(familyController),
                SizedBox(height: 24),
                _buildFamilyTreeView(),
                SizedBox(height: 24),
                _buildFamilyStats(familyController),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMemberDialog(),
        child: Icon(Icons.person_add),
        tooltip: 'Add Family Member',
      ),
    );
  }

  Widget _buildNoFamilySelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.family_restroom,
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
            'Please select a family to view the family tree',
            style: TextStyle(
              color: AppColors.textTertiary,
            ),
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

  Widget _buildFamilyHeader(FamilyController familyController) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage(familyController.selectedFamily!.imageUrl),
              backgroundColor: AppColors.greyLight,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    familyController.selectedFamily!.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    familyController.selectedFamily!.description,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${familyController.selectedFamily!.memberIds.length} members',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyTreeView() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Family Tree',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            
            // Mock family tree structure
            _buildFamilyMember('John Smith', 'Father', true),
            _buildFamilyConnection(),
            _buildFamilyMember('Jane Smith', 'Mother', true),
            _buildFamilyConnection(),
            Row(
              children: [
                Expanded(child: _buildFamilyMember('Mike Smith', 'Son', false)),
                SizedBox(width: 16),
                Expanded(child: _buildFamilyMember('Sarah Smith', 'Daughter', false)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyMember(String name, String relation, bool isParent) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isParent ? AppColors.primary.withOpacity(0.1) : AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: isParent ? AppColors.primary.withOpacity(0.3) : AppColors.secondary.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isParent ? AppColors.primary : AppColors.secondary,
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            relation,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyConnection() {
    return Container(
      height: 20,
      child: Center(
        child: Container(
          width: 2,
          height: 20,
          color: AppColors.greyLight,
        ),
      ),
    );
  }

  Widget _buildFamilyStats(FamilyController familyController) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Family Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Members',
                    '${familyController.selectedFamily!.memberIds.length}',
                    Icons.people,
                    AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Generations',
                    '3',
                    Icons.timeline,
                    AppColors.secondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Created',
                    '${familyController.selectedFamily!.createdAt.year}',
                    Icons.calendar_today,
                    AppColors.accent,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Photos',
                    '127',
                    Icons.photo,
                    AppColors.info,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAddMemberDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Add Family Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Relation',
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
                'Family member added successfully!',
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