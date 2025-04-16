import 'package:flutter/material.dart';
import 'package:flutter_learning2/pages/homepage.dart';
import 'package:flutter_learning2/pages/welcomepage.dart';
import 'package:flutter_learning2/pages/wishlist_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WishlistProvider())],
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
      home: const HomePage(), // Bisa diganti dengan WelcomePage() jika perlu
    );
  }
}
