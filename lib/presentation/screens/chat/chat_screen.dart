import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/family_controller.dart';
import '../../widgets/family_switcher.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final FamilyController familyController = Get.find<FamilyController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('${familyController.selectedFamilyName} Chat')),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () => showFamilySwitcherModal(),
            tooltip: 'Switch Family',
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () => _startVideoCall(),
            tooltip: 'Video Call',
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _showChatInfo(),
            tooltip: 'Chat Info',
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

        return Column(
          children: [
            // Online members indicator
            _buildOnlineMembersBar(),
            
            // Messages list
            Expanded(
              child: _buildMessagesList(),
            ),
            
            // Message input
            _buildMessageInput(),
          ],
        );
      }),
    );
  }

  Widget _buildNoFamilySelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat,
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
            'Please select a family to start chatting',
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

  Widget _buildOnlineMembersBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyLight.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: AppColors.success,
            size: 12,
          ),
          SizedBox(width: 8),
          Text(
            '3 members online',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          _buildOnlineMemberAvatar('John', true),
          _buildOnlineMemberAvatar('Jane', true),
          _buildOnlineMemberAvatar('Mike', true),
          _buildOnlineMemberAvatar('Sarah', false),
        ],
      ),
    );
  }

  Widget _buildOnlineMemberAvatar(String name, bool isOnline) {
    return Container(
      margin: EdgeInsets.only(left: 4),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: Text(
              name[0],
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    final messages = _getMockMessages();

    return ListView.builder(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message['isMe'] as bool;
        final showAvatar = index == messages.length - 1 || 
                          messages[index + 1]['sender'] != message['sender'];

        return _buildMessageBubble(message, isMe, showAvatar);
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isMe, bool showAvatar) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && showAvatar) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.secondary,
              child: Text(
                message['sender'][0],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 8),
          ] else if (!isMe) ...[
            SizedBox(width: 40),
          ],
          
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe && showAvatar)
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      message['sender'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.primary : AppColors.greyLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18).copyWith(
                      bottomLeft: Radius.circular(isMe ? 18 : (showAvatar ? 4 : 18)),
                      bottomRight: Radius.circular(isMe ? (showAvatar ? 4 : 18) : 18),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['text'],
                        style: TextStyle(
                          color: isMe ? Colors.white : AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      if (message['type'] == 'image') ...[
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            message['imageUrl'],
                            width: 200,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                if (showAvatar)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      _formatMessageTime(message['timestamp']),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          if (isMe && showAvatar) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Text(
                'You'[0],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ] else if (isMe) ...[
            SizedBox(width: 40),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.greyLight.withOpacity(0.5),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () => _showAttachmentOptions(),
              icon: Icon(Icons.add),
              color: AppColors.primary,
            ),
            
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.greyLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            
            SizedBox(width: 8),
            
            GestureDetector(
              onTap: () => _sendMessage(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getMockMessages() {
    return [
      {
        'id': '1',
        'sender': 'John Smith',
        'text': 'Hey everyone! How was your day?',
        'timestamp': DateTime.now().subtract(Duration(hours: 2)),
        'isMe': false,
        'type': 'text',
      },
      {
        'id': '2',
        'sender': 'You',
        'text': 'Great! Just finished work. How about you?',
        'timestamp': DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
        'isMe': true,
        'type': 'text',
      },
      {
        'id': '3',
        'sender': 'Jane Smith',
        'text': 'I had a wonderful day at the park with the kids!',
        'timestamp': DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
        'isMe': false,
        'type': 'text',
      },
      {
        'id': '4',
        'sender': 'Jane Smith',
        'text': 'Look at this beautiful sunset!',
        'timestamp': DateTime.now().subtract(Duration(hours: 1, minutes: 25)),
        'isMe': false,
        'type': 'image',
        'imageUrl': 'https://picsum.photos/400/300?random=sunset',
      },
      {
        'id': '5',
        'sender': 'Mike Smith',
        'text': 'Wow, that\'s gorgeous! 😍',
        'timestamp': DateTime.now().subtract(Duration(hours: 1, minutes: 20)),
        'isMe': false,
        'type': 'text',
      },
      {
        'id': '6',
        'sender': 'You',
        'text': 'Beautiful! We should plan a family picnic soon.',
        'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
        'isMe': true,
        'type': 'text',
      },
      {
        'id': '7',
        'sender': 'Sarah Smith',
        'text': 'That sounds like a great idea! I\'m free this weekend.',
        'timestamp': DateTime.now().subtract(Duration(minutes: 15)),
        'isMe': false,
        'type': 'text',
      },
    ];
  }

  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return DateFormat('MMM d, HH:mm').format(timestamp);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      // Here you would typically send the message to your backend
      Get.snackbar(
        'Message Sent',
        _messageController.text.trim(),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );
      _messageController.clear();
    }
  }

  void _showAttachmentOptions() {
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
              'Send Attachment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  Icons.camera_alt,
                  'Camera',
                  AppColors.primary,
                  () => _takePhoto(),
                ),
                _buildAttachmentOption(
                  Icons.photo_library,
                  'Gallery',
                  AppColors.secondary,
                  () => _pickFromGallery(),
                ),
                _buildAttachmentOption(
                  Icons.location_on,
                  'Location',
                  AppColors.error,
                  () => _shareLocation(),
                ),
                _buildAttachmentOption(
                  Icons.insert_drive_file,
                  'Document',
                  AppColors.warning,
                  () => _pickDocument(),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Get.back();
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _takePhoto() {
    Get.snackbar(
      'Camera',
      'Camera functionality will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _pickFromGallery() {
    Get.snackbar(
      'Gallery',
      'Gallery picker will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _shareLocation() {
    Get.snackbar(
      'Location',
      'Location sharing will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _pickDocument() {
    Get.snackbar(
      'Document',
      'Document picker will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _startVideoCall() {
    Get.dialog(
      AlertDialog(
        title: Text('Start Video Call'),
        content: Text('Start a video call with all family members?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Video Call',
                'Video call feature will be implemented soon!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Start Call'),
          ),
        ],
      ),
    );
  }

  void _showChatInfo() {
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
              'Chat Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            
            _buildInfoRow('Total Messages', '1,247'),
            _buildInfoRow('Active Members', '4'),
            _buildInfoRow('Created', 'January 15, 2024'),
            _buildInfoRow('Last Activity', '2 minutes ago'),
            
            SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Mute',
                        'Chat muted for 1 hour',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: Icon(Icons.volume_off),
                    label: Text('Mute'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Settings',
                        'Chat settings will be implemented soon!',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}