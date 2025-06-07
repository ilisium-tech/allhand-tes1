import 'package:get/get.dart';

import '../presentation/screens/main/main_screen.dart';
import '../presentation/screens/family_tree/family_tree_screen.dart';
import '../presentation/screens/gallery/gallery_screen.dart';
import '../presentation/screens/map/map_screen.dart';
import '../presentation/screens/chat/chat_screen.dart';
import '../presentation/screens/event/event_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.main,
      page: () => MainScreen(),
    ),
    GetPage(
      name: AppRoutes.familyTree,
      page: () => FamilyTreeScreen(),
    ),
    GetPage(
      name: AppRoutes.gallery,
      page: () => GalleryScreen(),
    ),
    GetPage(
      name: AppRoutes.map,
      page: () => MapScreen(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => ChatScreen(),
    ),
    GetPage(
      name: AppRoutes.event,
      page: () => EventScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingsScreen(),
    ),
  ];
}