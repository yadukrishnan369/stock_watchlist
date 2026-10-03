import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:stock_watchlist/providers/stock_provider.dart';
import 'package:stock_watchlist/providers/watchlist_provider.dart';
import 'package:stock_watchlist/screens/main_screen.dart';

Future<void> main() async {
  // Required before using async code before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive local storage
  await Hive.initFlutter();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StockProvider()),
        ChangeNotifierProvider(
          create: (_) => WatchlistProvider()..initializeWatchlist(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Watchlist',
      home: const MainScreen(),
    );
  }
}
