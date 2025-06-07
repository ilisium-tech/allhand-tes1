import 'package:get/get.dart';
import '../../domain/entities/family.dart';
import '../../data/models/family_model.dart';

class FamilyController extends GetxController {
  // Observable variables
  final RxList<Family> _families = <Family>[].obs;
  final Rx<Family?> _selectedFamily = Rx<Family?>(null);
  final RxBool _isLoading = false.obs;

  // Getters
  List<Family> get families => _families;
  Family? get selectedFamily => _selectedFamily.value;
  String get selectedFamilyName => _selectedFamily.value?.name ?? 'No Family Selected';
  String get selectedFamilyId => _selectedFamily.value?.id ?? '';
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadMockFamilies();
  }

  // Load mock families for demonstration
  void _loadMockFamilies() {
    _isLoading.value = true;
    
    // Simulate API delay
    Future.delayed(Duration(milliseconds: 500), () {
      final mockFamilies = [
        FamilyModel(
          id: '1',
          name: 'The Smith Family',
          description: 'A loving family from California',
          imageUrl: 'https://via.placeholder.com/150',
          createdAt: DateTime.now().subtract(Duration(days: 365)),
          memberIds: ['user1', 'user2', 'user3', 'user4'],
          ownerId: 'user1',
        ),
        FamilyModel(
          id: '2',
          name: 'The Johnson Clan',
          description: 'Extended family from Texas',
          imageUrl: 'https://via.placeholder.com/150',
          createdAt: DateTime.now().subtract(Duration(days: 200)),
          memberIds: ['user1', 'user5', 'user6'],
          ownerId: 'user1',
        ),
        FamilyModel(
          id: '3',
          name: 'The Williams Dynasty',
          description: 'Multi-generational family',
          imageUrl: 'https://via.placeholder.com/150',
          createdAt: DateTime.now().subtract(Duration(days: 100)),
          memberIds: ['user1', 'user7', 'user8', 'user9', 'user10'],
          ownerId: 'user1',
        ),
      ];

      _families.assignAll(mockFamilies);
      if (mockFamilies.isNotEmpty) {
        _selectedFamily.value = mockFamilies.first;
      }
      _isLoading.value = false;
    });
  }

  // Switch to a different family
  void switchFamily(Family family) {
    if (_selectedFamily.value?.id != family.id) {
      _selectedFamily.value = family;
      
      // Trigger refresh for all dependent controllers
      _notifyFamilySwitch();
    }
  }

  // Switch family by ID
  void switchFamilyById(String familyId) {
    final family = _families.firstWhereOrNull((f) => f.id == familyId);
    if (family != null) {
      switchFamily(family);
    }
  }

  // Notify other controllers about family switch
  void _notifyFamilySwitch() {
    // This can be used to trigger updates in other controllers
    // For example, refresh gallery, chat, events, etc.
    Get.find<MainController>().onFamilyChanged();
  }

  // Refresh current family data
  Future<void> refreshFamilyData() async {
    if (_selectedFamily.value != null) {
      _isLoading.value = true;
      
      // Simulate API call to refresh family data
      await Future.delayed(Duration(milliseconds: 800));
      
      _isLoading.value = false;
    }
  }

  // Add a new family
  void addFamily(Family family) {
    _families.add(family);
  }

  // Remove a family
  void removeFamily(String familyId) {
    _families.removeWhere((family) => family.id == familyId);
    
    // If the removed family was selected, switch to another one
    if (_selectedFamily.value?.id == familyId) {
      if (_families.isNotEmpty) {
        _selectedFamily.value = _families.first;
      } else {
        _selectedFamily.value = null;
      }
    }
  }
}

// Extension for MainController to handle family changes
extension FamilyControllerExtension on FamilyController {
  void onFamilyChanged() {
    // This method can be called when family is switched
    // to perform any additional actions
  }
}