import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../controllers/family_controller.dart';
import '../../controllers/main_controller.dart';
import '../../widgets/family_context_banner.dart';
import '../family_tree/family_tree_screen.dart';
import '../gallery/gallery_screen.dart';
import '../map/map_screen.dart';
import '../chat/chat_screen.dart';
import '../event/event_screen.dart';
import 'widgets/custom_drawer.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.find<MainController>();
    final FamilyController familyController = Get.find<FamilyController>();

    return Scaffold(
      drawer: CustomDrawer(),
      body: Column(
        children: [
          // Family context banner
          FamilyContextBanner(),
          
          // Main content
          Expanded(
            child: Obx(() {
              return IndexedStack(
                index: mainController.selectedIndex,
                children: [
                  FamilyTreeScreen(),
                  GalleryScreen(),
                  MapScreen(),
                  ChatScreen(),
                  EventScreen(),
                ],
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: mainController.selectedIndex,
          onTap: mainController.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey,
          elevation: 8,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_tree),
              activeIcon: Icon(Icons.account_tree),
              label: 'Family Tree',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_library),
              activeIcon: Icon(Icons.photo_library),
              label: 'Gallery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              activeIcon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              activeIcon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              activeIcon: Icon(Icons.event),
              label: 'Events',
            ),
          ],
        );
      }),
    );
  }
}