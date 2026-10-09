import 'package:flutter/material.dart';
import 'core/theme/cosmic_theme.dart';
import 'features/navigation/main_scaffold.dart';

/// Root application widget for Cosmic Mythology AR Explorer.
class CosmicMythologyApp extends StatelessWidget {
  const CosmicMythologyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic Mythology AR Explorer',
      debugShowCheckedModeBanner: false,
      theme: CosmicTheme.darkTheme,
      home: const MainScaffold(),
    );
  }
}
