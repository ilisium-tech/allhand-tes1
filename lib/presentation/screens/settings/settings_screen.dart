import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('General'),
            _buildSettingsGroup([
              _buildSettingItem(
                'Theme',
                'Light',
                Icons.palette_outlined,
                () => _showThemeDialog(),
              ),
              _buildSettingItem(
                'Language',
                'English',
                Icons.language_outlined,
                () => _showLanguageDialog(),
              ),
              _buildSwitchItem(
                'Dark Mode',
                'Enable dark theme',
                Icons.dark_mode_outlined,
                false,
                (value) => _toggleDarkMode(value),
              ),
            ]),
            
            SizedBox(height: 24),
            _buildSectionHeader('Notifications'),
            _buildSettingsGroup([
              _buildSwitchItem(
                'Push Notifications',
                'Receive push notifications',
                Icons.notifications_outlined,
                true,
                (value) => _toggleNotifications(value),
              ),
              _buildSwitchItem(
                'Email Notifications',
                'Receive email updates',
                Icons.email_outlined,
                true,
                (value) => _toggleEmailNotifications(value),
              ),
              _buildSwitchItem(
                'Event Reminders',
                'Get reminded about family events',
                Icons.event_outlined,
                true,
                (value) => _toggleEventReminders(value),
              ),
              _buildSwitchItem(
                'Birthday Alerts',
                'Get notified about birthdays',
                Icons.cake_outlined,
                true,
                (value) => _toggleBirthdayAlerts(value),
              ),
            ]),
            
            SizedBox(height: 24),
            _buildSectionHeader('Privacy & Security'),
            _buildSettingsGroup([
              _buildSettingItem(
                'Privacy Policy',
                'View our privacy policy',
                Icons.privacy_tip_outlined,
                () => _showPrivacyPolicy(),
              ),
              _buildSettingItem(
                'Terms of Service',
                'View terms and conditions',
                Icons.description_outlined,
                () => _showTermsOfService(),
              ),
              _buildSettingItem(
                'Data & Storage',
                'Manage your data',
                Icons.storage_outlined,
                () => _showDataSettings(),
              ),
              _buildSwitchItem(
                'Location Sharing',
                'Share location with family',
                Icons.location_on_outlined,
                false,
                (value) => _toggleLocationSharing(value),
              ),
            ]),
            
            SizedBox(height: 24),
            _buildSectionHeader('Family Settings'),
            _buildSettingsGroup([
              _buildSettingItem(
                'Family Permissions',
                'Manage family member permissions',
                Icons.admin_panel_settings_outlined,
                () => _showFamilyPermissions(),
              ),
              _buildSettingItem(
                'Invitation Settings',
                'Configure family invitations',
                Icons.person_add_outlined,
                () => _showInvitationSettings(),
              ),
              _buildSwitchItem(
                'Auto-approve Members',
                'Automatically approve new members',
                Icons.how_to_reg_outlined,
                false,
                (value) => _toggleAutoApprove(value),
              ),
            ]),
            
            SizedBox(height: 24),
            _buildSectionHeader('Support'),
            _buildSettingsGroup([
              _buildSettingItem(
                'Help Center',
                'Get help and support',
                Icons.help_outline,
                () => _showHelpCenter(),
              ),
              _buildSettingItem(
                'Contact Us',
                'Send feedback or report issues',
                Icons.contact_support_outlined,
                () => _showContactUs(),
              ),
              _buildSettingItem(
                'Rate App',
                'Rate us on the app store',
                Icons.star_outline,
                () => _rateApp(),
              ),
            ]),
            
            SizedBox(height: 24),
            _buildSectionHeader('About'),
            _buildSettingsGroup([
              _buildSettingItem(
                'App Version',
                AppConstants.appVersion,
                Icons.info_outline,
                () => _showAppInfo(),
              ),
              _buildSettingItem(
                'Check for Updates',
                'Look for app updates',
                Icons.system_update_outlined,
                () => _checkForUpdates(),
              ),
              _buildSettingItem(
                'Licenses',
                'View open source licenses',
                Icons.article_outlined,
                () => _showLicenses(),
              ),
            ]),
            
            SizedBox(height: 32),
            _buildDangerZone(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Card(
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildDangerZone() {
    return Card(
      color: AppColors.error.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(AppConstants.defaultPadding),
            child: Text(
              'Danger Zone',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete_forever, color: AppColors.error, size: 20),
            ),
            title: Text(
              'Delete Account',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.error,
              ),
            ),
            subtitle: Text('Permanently delete your account and all data'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.error),
            onTap: () => _showDeleteAccountDialog(),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('Light'),
              value: 'light',
              groupValue: 'light',
              onChanged: (value) {
                Get.back();
                Get.snackbar(
                  'Theme',
                  'Light theme selected',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            RadioListTile<String>(
              title: Text('Dark'),
              value: 'dark',
              groupValue: 'light',
              onChanged: (value) {
                Get.back();
                Get.snackbar(
                  'Theme',
                  'Dark theme selected',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            RadioListTile<String>(
              title: Text('System'),
              value: 'system',
              groupValue: 'light',
              onChanged: (value) {
                Get.back();
                Get.snackbar(
                  'Theme',
                  'System theme selected',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('English'),
              value: 'en',
              groupValue: 'en',
              onChanged: (value) {
                Get.back();
                Get.snackbar(
                  'Language',
                  'English selected',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            RadioListTile<String>(
              title: Text('Spanish'),
              value: 'es',
              groupValue: 'en',
              onChanged: (value) {
                Get.back();
                Get.snackbar(
                  'Language',
                  'Spanish selected',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            RadioListTile<String>(
              title: Text('French'),
              value: 'fr',
              groupValue: 'en',
              onChanged: (value) {
                Get.back();
                Get.snackbar(
                  'Language',
                  'French selected',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleDarkMode(bool value) {
    Get.snackbar(
      'Dark Mode',
      value ? 'Dark mode enabled' : 'Dark mode disabled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _toggleNotifications(bool value) {
    Get.snackbar(
      'Notifications',
      value ? 'Push notifications enabled' : 'Push notifications disabled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _toggleEmailNotifications(bool value) {
    Get.snackbar(
      'Email Notifications',
      value ? 'Email notifications enabled' : 'Email notifications disabled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _toggleEventReminders(bool value) {
    Get.snackbar(
      'Event Reminders',
      value ? 'Event reminders enabled' : 'Event reminders disabled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _toggleBirthdayAlerts(bool value) {
    Get.snackbar(
      'Birthday Alerts',
      value ? 'Birthday alerts enabled' : 'Birthday alerts disabled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showPrivacyPolicy() {
    Get.snackbar(
      'Privacy Policy',
      'Privacy policy will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showTermsOfService() {
    Get.snackbar(
      'Terms of Service',
      'Terms of service will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showDataSettings() {
    Get.snackbar(
      'Data Settings',
      'Data settings will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _toggleLocationSharing(bool value) {
    Get.snackbar(
      'Location Sharing',
      value ? 'Location sharing enabled' : 'Location sharing disabled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showFamilyPermissions() {
    Get.snackbar(
      'Family Permissions',
      'Family permissions will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showInvitationSettings() {
    Get.snackbar(
      'Invitation Settings',
      'Invitation settings will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _toggleAutoApprove(bool value) {
    Get.snackbar(
      'Auto-approve',
      value ? 'Auto-approve enabled' : 'Auto-approve disabled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showHelpCenter() {
    Get.snackbar(
      'Help Center',
      'Help center will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showContactUs() {
    Get.dialog(
      AlertDialog(
        title: Text('Contact Us'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: support@familyapp.com'),
            SizedBox(height: 8),
            Text('Phone: +1 (555) 123-4567'),
            SizedBox(height: 8),
            Text('Website: www.familyapp.com'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Email',
                'Email app will open soon!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Send Email'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    Get.snackbar(
      'Rate App',
      'App store will open soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showAppInfo() {
    Get.dialog(
      AlertDialog(
        title: Text('App Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Name: ${AppConstants.appName}'),
            SizedBox(height: 8),
            Text('Version: ${AppConstants.appVersion}'),
            SizedBox(height: 8),
            Text('Build: 1.0.0+1'),
            SizedBox(height: 8),
            Text('Developer: Family App Team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates() {
    Get.snackbar(
      'Updates',
      'Checking for updates...',
      snackPosition: SnackPosition.BOTTOM,
    );
    
    Future.delayed(Duration(seconds: 2), () {
      Get.snackbar(
        'Updates',
        'You have the latest version!',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  void _showLicenses() {
    Get.snackbar(
      'Licenses',
      'Open source licenses will be shown soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Account',
          style: TextStyle(color: AppColors.error),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. This will permanently delete your account and remove all your data from our servers.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: 16),
            Text(
              'Please type "DELETE" to confirm:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type DELETE here',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Account Deletion',
                'Account deletion will be implemented soon!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}