import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inkscribe/firebase_options.dart';
import 'package:inkscribe/pages/splash_screen.dart';
import 'package:inkscribe/providers/theme_provier.dart';
import 'package:inkscribe/theme/palette.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeState = ref.watch(themesProvider);
    return MaterialApp(
      title: 'InkScribe',
      debugShowCheckedModeBanner: false,
      theme: Palette.lightTheme,
      darkTheme: Palette.darkTheme,
      themeMode: themeModeState,
      home: SplashScreen(themeColor: Theme.of(context).primaryColor),
    );
  }
}
