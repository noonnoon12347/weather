import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weather/Provider/theme_provider.dart';
import 'package:weather/Theme/theme.dart';
import 'package:weather/View/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dgbnxanoezggrhyheloe.supabase.co',       // ← ใส่จาก Supabase Dashboard
    anonKey: 'sb_publishable_xzSozVJFDGt_zy0zlT_qXw_BB8MRfNg', // ← ใส่จาก Supabase Dashboard
  );

  runApp(ProviderScope(child: const MyApp()));
}

// Global helper เรียกใช้ได้ทุกที่
final supabase = Supabase.instance.client;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}