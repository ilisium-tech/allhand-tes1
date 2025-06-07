import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/family_controller.dart';
import '../../widgets/family_switcher.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FamilyController familyController = Get.find<FamilyController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('${familyController.selectedFamilyName} Events')),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () => showFamilySwitcherModal(),
            tooltip: 'Switch Family',
          ),
          IconButton(
            icon: Icon(Icons.calendar_view_month),
            onPressed: () => _showCalendarView(),
            tooltip: 'Calendar View',
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
              _buildEventHeader(),
              _buildUpcomingEvents(),
              _buildEventCategories(),
              _buildRecentEvents(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateEventDialog(),
        child: Icon(Icons.add),
        tooltip: 'Create Event',
      ),
    );
  }

  Widget _buildNoFamilySelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event,
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
            'Please select a family to view events',
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

  Widget _buildEventHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'This Month',
                    '8',
                    Icons.calendar_today,
                    AppColors.primary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Upcoming',
                    '3',
                    Icons.schedule,
                    AppColors.secondary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Birthdays',
                    '2',
                    Icons.cake,
                    AppColors.accent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Quick actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showCreateEventDialog(),
                    icon: Icon(Icons.add_circle_outline),
                    label: Text('New Event'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showBirthdayReminders(),
                    icon: Icon(Icons.cake),
                    label: Text('Birthdays'),
                  ),
                ),
              ],
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

  Widget _buildUpcomingEvents() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            child: Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              itemCount: _getUpcomingEvents().length,
              itemBuilder: (context, index) {
                final event = _getUpcomingEvents()[index];
                return _buildUpcomingEventCard(event);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventCard(Map<String, dynamic> event) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            event['color'].withOpacity(0.8),
            event['color'],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: event['color'].withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    event['icon'],
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Spacer(),
                Text(
                  _formatEventDate(event['date']),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              event['title'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Text(
              event['description'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Row(
              children: [
                Icon(
                  Icons.people,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  '${event['attendees']} attending',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => _showEventDetails(event),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'View',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCategories() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            child: Text(
              'Event Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              children: [
                _buildCategoryCard('Birthdays', Icons.cake, AppColors.accent, 5),
                _buildCategoryCard('Reunions', Icons.family_restroom, AppColors.primary, 2),
                _buildCategoryCard('Holidays', Icons.celebration, AppColors.secondary, 8),
                _buildCategoryCard('Anniversaries', Icons.favorite, AppColors.error, 3),
                _buildCategoryCard('Graduations', Icons.school, AppColors.info, 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color, int count) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '$count events',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEvents() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            child: Text(
              'Recent Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: 12),
          ..._getRecentEvents().map((event) => _buildRecentEventCard(event)),
          SizedBox(height: 100), // Bottom padding for FAB
        ],
      ),
    );
  }

  Widget _buildRecentEventCard(Map<String, dynamic> event) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 6,
      ),
      child: Card(
        child: ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: event['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              event['icon'],
              color: event['color'],
            ),
          ),
          title: Text(
            event['title'],
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event['description']),
              SizedBox(height: 4),
              Text(
                _formatEventDate(event['date']),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () => _showEventDetails(event),
            icon: Icon(Icons.more_vert),
          ),
          onTap: () => _showEventDetails(event),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getUpcomingEvents() {
    return [
      {
        'id': '1',
        'title': 'Family Reunion 2024',
        'description': 'Annual family gathering at Grandma\'s house',
        'date': DateTime.now().add(Duration(days: 15)),
        'icon': Icons.family_restroom,
        'color': AppColors.primary,
        'attendees': 12,
      },
      {
        'id': '2',
        'title': 'Sarah\'s Birthday',
        'description': 'Sweet 16 birthday party',
        'date': DateTime.now().add(Duration(days: 8)),
        'icon': Icons.cake,
        'color': AppColors.accent,
        'attendees': 8,
      },
      {
        'id': '3',
        'title': 'Christmas Dinner',
        'description': 'Traditional family Christmas celebration',
        'date': DateTime.now().add(Duration(days: 45)),
        'icon': Icons.celebration,
        'color': AppColors.secondary,
        'attendees': 15,
      },
    ];
  }

  List<Map<String, dynamic>> _getRecentEvents() {
    return [
      {
        'id': '4',
        'title': 'Mike\'s Graduation',
        'description': 'High school graduation ceremony',
        'date': DateTime.now().subtract(Duration(days: 10)),
        'icon': Icons.school,
        'color': AppColors.info,
      },
      {
        'id': '5',
        'title': 'Wedding Anniversary',
        'description': 'John & Jane\'s 20th anniversary',
        'date': DateTime.now().subtract(Duration(days: 25)),
        'icon': Icons.favorite,
        'color': AppColors.error,
      },
      {
        'id': '6',
        'title': 'Easter Brunch',
        'description': 'Family Easter celebration',
        'date': DateTime.now().subtract(Duration(days: 60)),
        'icon': Icons.celebration,
        'color': AppColors.secondary,
      },
    ];
  }

  String _formatEventDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    if (difference > 0 && difference < 7) return 'In ${difference} days';
    if (difference < 0 && difference > -7) return '${-difference} days ago';
    
    return DateFormat('MMM d, yyyy').format(date);
  }

  void _showEventDetails(Map<String, dynamic> event) {
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
            
            // Event header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: event['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    event['icon'],
                    color: event['color'],
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatEventDate(event['date']),
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
            
            // Event description
            Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              event['description'],
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            
            if (event['attendees'] != null) ...[
              SizedBox(height: 16),
              Text(
                'Attendees',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${event['attendees']} family members attending',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            
            SizedBox(height: 24),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Edit',
                        'Edit event functionality will be implemented soon!',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: Icon(Icons.edit),
                    label: Text('Edit'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Reminder',
                        'Reminder set for this event!',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: Icon(Icons.notifications),
                    label: Text('Remind Me'),
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

  void _showCreateEventDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Create New Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Event Title',
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
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Date & Time',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {
                // Show date picker
              },
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
                'Event created successfully!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showCalendarView() {
    Get.snackbar(
      'Calendar',
      'Calendar view will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showBirthdayReminders() {
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
            
            Text(
              'Upcoming Birthdays',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            
            _buildBirthdayItem('Sarah Smith', DateTime.now().add(Duration(days: 8))),
            _buildBirthdayItem('Mike Smith', DateTime.now().add(Duration(days: 23))),
            _buildBirthdayItem('Grandma Rose', DateTime.now().add(Duration(days: 45))),
            
            SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildBirthdayItem(String name, DateTime date) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.accent.withOpacity(0.1),
        child: Icon(Icons.cake, color: AppColors.accent),
      ),
      title: Text(name),
      subtitle: Text(_formatEventDate(date)),
      trailing: IconButton(
        onPressed: () {
          Get.snackbar(
            'Reminder',
            'Birthday reminder set for $name!',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        icon: Icon(Icons.notifications_none),
      ),
    );
  }
}