# 👨‍👩‍👧‍👦 Family App - Flutter Clean Architecture

A comprehensive family-focused mobile application built with Flutter, implementing Clean Architecture principles and GetX for state management. The app supports multiple families with seamless switching and provides essential family management features.

## ✨ Features

### 🏠 Core Family Features
- **Multi-Family Support** - Manage multiple families with easy switching
- **Family Tree Visualization** - Interactive family tree with member relationships
- **Photo Gallery** - Shared family photo gallery with categories and filters
- **Location Map** - Real-time family member locations with status indicators
- **Group Chat** - Family group messaging with attachments and media sharing
- **Event Management** - Family events, birthdays, and calendar integration

### 🎯 Key Highlights
- **Family Switcher** - Seamless family switching on all screens
- **Reactive UI** - Real-time updates when family context changes
- **Clean Architecture** - Scalable and maintainable code structure
- **Material Design 3** - Modern and consistent UI/UX
- **Responsive Design** - Optimized for different screen sizes

## 🏗️ Architecture

### Clean Architecture Layers
```
├── Presentation Layer (UI + Controllers)
├── Domain Layer (Entities + Use Cases)
└── Data Layer (Models + Repositories)
```

### State Management
- **GetX** for reactive state management
- **Dependency Injection** with Get.put()
- **Route Management** with named routes
- **Reactive Programming** with Obx widgets

## 📱 Screenshots

### Main Navigation
- Bottom Navigation with 5 pillar menus
- Navigation Drawer with global options
- Family Context Banner showing current family

### Family Features
- Family Tree with interactive member cards
- Gallery with grid layout and photo details
- Map with member locations and status
- Chat with message bubbles and attachments
- Events with upcoming and recent displays

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/family-app.git
   cd family-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6                    # State management & navigation
  google_fonts: ^6.1.0          # Typography
  cached_network_image: ^3.3.0  # Image caching
  intl: ^0.19.0                 # Internationalization
  cupertino_icons: ^1.0.6      # iOS icons
```

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants
│   └── theme/             # Theme configuration
├── data/
│   ├── models/            # Data models
│   └── repositories/      # Data repositories
├── domain/
│   ├── entities/          # Business entities
│   └── usecases/         # Business logic
├── presentation/
│   ├── controllers/       # GetX controllers
│   ├── screens/          # UI screens
│   └── widgets/          # Reusable widgets
├── routes/
│   ├── app_pages.dart    # Route definitions
│   └── app_routes.dart   # Route constants
└── main.dart             # App entry point
```

## 🎨 Design System

### Color Palette
- **Primary**: Indigo (#6366F1)
- **Secondary**: Emerald (#10B981)
- **Accent**: Amber (#F59E0B)
- **Error**: Red (#EF4444)
- **Success**: Green (#10B981)

### Typography
- **Font Family**: Google Fonts Inter
- **Hierarchical Sizing**: 10px - 24px
- **Font Weights**: 400, 500, 600, 700

### Spacing System
- **Small**: 8px
- **Default**: 16px
- **Large**: 24px
- **Border Radius**: 8px, 12px, 16px

## 🔧 Key Components

### Family Controller
```dart
class FamilyController extends GetxController {
  final RxList<Family> _families = <Family>[].obs;
  final Rx<Family?> _selectedFamily = Rx<Family?>(null);
  
  void switchFamily(Family family) {
    _selectedFamily.value = family;
    _notifyFamilySwitch();
  }
}
```

### Family Switcher Widget
```dart
class FamilySwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FamilyController>(
      builder: (controller) => Obx(() {
        return DropdownButton<String>(
          value: controller.selectedFamilyId,
          items: controller.families.map((family) {
            return DropdownMenuItem(
              value: family.id,
              child: Text(family.name),
            );
          }).toList(),
          onChanged: (id) => controller.switchFamilyById(id!),
        );
      }),
    );
  }
}
```

## 📱 Screens Overview

### 1. Family Tree Screen
- Interactive family tree visualization
- Member statistics and information
- Add/edit family members
- Family relationship mapping

### 2. Gallery Screen
- Grid layout photo display
- Category filters (All, Recent, Favorites)
- Photo detail view with zoom
- Upload from camera/gallery

### 3. Map Screen
- Family member location tracking
- Status indicators (online/offline/away)
- Location details and directions
- Map controls and customization

### 4. Chat Screen
- Real-time family group chat
- Message bubbles with timestamps
- Attachment support (photos, documents, location)
- Online status indicators

### 5. Event Screen
- Upcoming events carousel
- Event categories and statistics
- Birthday reminders
- Calendar integration

### 6. Profile Screen
- User profile management
- Family membership display
- Account statistics
- Settings and preferences

### 7. Settings Screen
- Theme and appearance options
- Notification preferences
- Privacy and security settings
- Account management

## 🔄 Family Switching Flow

1. **User taps family switcher** (dropdown or modal)
2. **FamilyController updates** selected family
3. **All screens react** via Obx reactive widgets
4. **Content refreshes** automatically for new family
5. **Context banner updates** to show current family
6. **Navigation persists** current screen position

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent formatting

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **GetX Team** for the powerful state management solution
- **Google Fonts** for beautiful typography
- **Material Design** for design guidelines

## 📞 Support

For support, email support@familyapp.com or join our [Discord community](https://discord.gg/familyapp).

## 🗺️ Roadmap

### Version 1.1
- [ ] Real backend integration
- [ ] Push notifications
- [ ] Offline support
- [ ] Advanced photo editing

### Version 1.2
- [ ] Video calling
- [ ] Calendar sync
- [ ] Location sharing
- [ ] Advanced privacy controls

### Version 2.0
- [ ] AI-powered family insights
- [ ] Multi-language support
- [ ] Advanced analytics
- [ ] Premium features

---

**Built with ❤️ using Flutter and GetX**