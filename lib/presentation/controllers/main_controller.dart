import 'package:get/get.dart';

class MainController extends GetxController {
  // Observable variables
  final RxInt _selectedIndex = 0.obs;
  final RxBool _isDrawerOpen = false.obs;

  // Getters
  int get selectedIndex => _selectedIndex.value;
  bool get isDrawerOpen => _isDrawerOpen.value;

  // Bottom navigation items
  final List<BottomNavItem> bottomNavItems = [
    BottomNavItem(
      icon: 'assets/icons/family_tree.svg',
      label: 'Family Tree',
      route: '/family-tree',
    ),
    BottomNavItem(
      icon: 'assets/icons/gallery.svg',
      label: 'Gallery',
      route: '/gallery',
    ),
    BottomNavItem(
      icon: 'assets/icons/map.svg',
      label: 'Map',
      route: '/map',
    ),
    BottomNavItem(
      icon: 'assets/icons/chat.svg',
      label: 'Chat',
      route: '/chat',
    ),
    BottomNavItem(
      icon: 'assets/icons/event.svg',
      label: 'Events',
      route: '/event',
    ),
  ];

  // Drawer menu items
  final List<DrawerMenuItem> drawerMenuItems = [
    DrawerMenuItem(
      icon: 'assets/icons/home.svg',
      label: 'Home',
      route: '/main',
    ),
    DrawerMenuItem(
      icon: 'assets/icons/profile.svg',
      label: 'Profile',
      route: '/profile',
    ),
    DrawerMenuItem(
      icon: 'assets/icons/settings.svg',
      label: 'Settings',
      route: '/settings',
    ),
    DrawerMenuItem(
      icon: 'assets/icons/subscription.svg',
      label: 'Subscription',
      route: '/subscription',
    ),
    DrawerMenuItem(
      icon: 'assets/icons/logout.svg',
      label: 'Logout',
      route: '/logout',
      isLogout: true,
    ),
  ];

  // Change bottom navigation index
  void changeTabIndex(int index) {
    if (index >= 0 && index < bottomNavItems.length) {
      _selectedIndex.value = index;
    }
  }

  // Toggle drawer
  void toggleDrawer() {
    _isDrawerOpen.value = !_isDrawerOpen.value;
  }

  // Open drawer
  void openDrawer() {
    _isDrawerOpen.value = true;
  }

  // Close drawer
  void closeDrawer() {
    _isDrawerOpen.value = false;
  }

  // Handle drawer item tap
  void onDrawerItemTap(DrawerMenuItem item) {
    closeDrawer();
    
    if (item.isLogout) {
      _handleLogout();
    } else {
      Get.toNamed(item.route);
    }
  }

  // Handle logout
  void _handleLogout() {
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
              // Implement logout logic here
              Get.snackbar(
                'Logout',
                'You have been logged out successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  // Called when family is changed
  void onFamilyChanged() {
    // Refresh current screen data when family changes
    // This can trigger updates in the current screen
    update();
  }

  // Get current screen title
  String getCurrentScreenTitle() {
    if (_selectedIndex.value < bottomNavItems.length) {
      return bottomNavItems[_selectedIndex.value].label;
    }
    return 'Family App';
  }
}

class BottomNavItem {
  final String icon;
  final String label;
  final String route;

  BottomNavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class DrawerMenuItem {
  final String icon;
  final String label;
  final String route;
  final bool isLogout;

  DrawerMenuItem({
    required this.icon,
    required this.label,
    required this.route,
    this.isLogout = false,
  });
}