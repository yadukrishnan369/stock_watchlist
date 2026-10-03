import 'package:flutter/material.dart';
import 'package:stock_watchlist/screens/home_screen.dart';
import 'package:stock_watchlist/screens/watchlist_screen.dart';
import 'package:stock_watchlist/utils/app_colors.dart';
import 'package:stock_watchlist/widgets/custom_bottom_nav_bar.dart';

// Main Screen
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Store selected bottom navigation index
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  // Main application screens
  final List<Widget> _screens = const [HomeScreen(), WatchlistScreen()];

  // Change selected tab
  void _changeTab(int index) {
    _currentIndex.value = index;
  }

  @override
  void dispose() {
    // Dispose ValueNotifier
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, currentIndex, child) {
        return Scaffold(
          backgroundColor: AppColors.background,

          // Show selected screen
          body: _screens[currentIndex],

          // Bottom navigation
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: currentIndex,
            onTap: _changeTab,
          ),
        );
      },
    );
  }
}
