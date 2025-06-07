import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/family.dart';
import '../controllers/family_controller.dart';

class FamilySwitcher extends StatelessWidget {
  final bool showAsModal;
  
  const FamilySwitcher({
    Key? key,
    this.showAsModal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FamilyController>(
      builder: (controller) {
        if (showAsModal) {
          return _buildModalSwitcher(context, controller);
        } else {
          return _buildDropdownSwitcher(controller);
        }
      },
    );
  }

  Widget _buildDropdownSwitcher(FamilyController controller) {
    return Obx(() {
      if (controller.families.isEmpty) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'No families available',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedFamilyId,
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
            dropdownColor: Colors.white,
            style: TextStyle(color: Colors.white, fontSize: 16),
            items: controller.families.map((Family family) {
              return DropdownMenuItem<String>(
                value: family.id,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(family.imageUrl),
                      backgroundColor: AppColors.greyLight,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        family.name,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.switchFamilyById(newValue);
              }
            },
          ),
        ),
      );
    });
  }

  Widget _buildModalSwitcher(BuildContext context, FamilyController controller) {
    return Container(
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
          
          // Title
          Text(
            'Switch Family',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          
          // Family list
          Obx(() {
            if (controller.families.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No families available',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              itemCount: controller.families.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final family = controller.families[index];
                final isSelected = family.id == controller.selectedFamilyId;
                
                return ListTile(
                  leading: CircleAvatar(
                    radius: 24,
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
                  subtitle: Text(
                    family.description,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    controller.switchFamily(family);
                    Get.back();
                  },
                );
              },
            );
          }),
          
          SizedBox(height: 16),
          
          // Add family button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Get.back();
                _showAddFamilyDialog();
              },
              icon: Icon(Icons.add),
              label: Text('Add New Family'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: AppColors.primary),
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddFamilyDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Add New Family'),
        content: Text('This feature will be implemented in the next version.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Helper function to show family switcher modal
void showFamilySwitcherModal() {
  Get.bottomSheet(
    FamilySwitcher(showAsModal: true),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}