import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/family_controller.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FamilyController familyController = Get.find<FamilyController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: () => _showEditProfileDialog(),
            icon: Icon(Icons.edit),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 24),
            _buildProfileStats(),
            SizedBox(height: 24),
            _buildFamiliesSection(familyController),
            SizedBox(height: 24),
            _buildProfileActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _changeProfilePicture(),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'john.doe@email.com',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Family Admin',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Families',
            '3',
            Icons.family_restroom,
            AppColors.primary,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Photos',
            '127',
            Icons.photo,
            AppColors.secondary,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Events',
            '23',
            Icons.event,
            AppColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamiliesSection(FamilyController familyController) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Families',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            Obx(() {
              return Column(
                children: familyController.families.map((family) {
                  final isSelected = family.id == familyController.selectedFamilyId;
                  return Container(
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected ? Border.all(color: AppColors.primary.withOpacity(0.3)) : null,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(family.imageUrl),
                        backgroundColor: AppColors.greyLight,
                      ),
                      title: Text(
                        family.name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text('${family.memberIds.length} members'),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: AppColors.primary)
                          : Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => familyController.switchFamily(family),
                    ),
                  );
                }).toList(),
              );
            }),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showCreateFamilyDialog(),
                icon: Icon(Icons.add),
                label: Text('Create New Family'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileActions() {
    return Column(
      children: [
        _buildActionCard(
          'Personal Information',
          'Update your personal details',
          Icons.person_outline,
          () => _showPersonalInfoDialog(),
        ),
        _buildActionCard(
          'Privacy Settings',
          'Manage your privacy preferences',
          Icons.privacy_tip_outlined,
          () => _showPrivacySettings(),
        ),
        _buildActionCard(
          'Notification Settings',
          'Configure your notifications',
          Icons.notifications_outlined,
          () => _showNotificationSettings(),
        ),
        _buildActionCard(
          'Account Security',
          'Change password and security settings',
          Icons.security_outlined,
          () => _showSecuritySettings(),
        ),
        _buildActionCard(
          'Help & Support',
          'Get help or contact support',
          Icons.help_outline,
          () => _showHelpSupport(),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showLogoutDialog(),
            icon: Icon(Icons.logout, color: AppColors.error),
            label: Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _changeProfilePicture() {
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
          children: [
            Text(
              'Change Profile Picture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
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
            ListTile(
              leading: Icon(Icons.delete, color: AppColors.error),
              title: Text('Remove Photo', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Removed',
                  'Profile picture removed',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _showEditProfileDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: 'John Doe'),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: 'john.doe@email.com'),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: '+1 234 567 8900'),
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
                'Profile updated successfully!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showCreateFamilyDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Create New Family'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Family Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
                'Family created successfully!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showPersonalInfoDialog() {
    Get.snackbar(
      'Personal Information',
      'Personal information settings will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showPrivacySettings() {
    Get.snackbar(
      'Privacy Settings',
      'Privacy settings will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showNotificationSettings() {
    Get.snackbar(
      'Notification Settings',
      'Notification settings will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showSecuritySettings() {
    Get.snackbar(
      'Security Settings',
      'Security settings will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showHelpSupport() {
    Get.snackbar(
      'Help & Support',
      'Help & support will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/main');
              Get.snackbar(
                'Logout',
                'You have been logged out successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}