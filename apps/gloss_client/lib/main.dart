import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ui_kit/ui_kit.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    try {
      await Firebase.initializeApp(options: firebaseOptions);
    } catch (_) {}
  } else {
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'demo',
          appId: 'demo',
          messagingSenderId: 'demo',
          projectId: 'demo',
        ),
      );
    } catch (_) {}
  }

  runApp(const ProviderScope(child: GlossApp()));
}

class GlossApp extends ConsumerWidget {
  const GlossApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Gloss',
      debugShowCheckedModeBanner: false,
      locale: const Locale('uz'),
      supportedLocales: const [Locale('uz'), Locale('ru'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: ref.watch(routerProvider),
      theme: AppTheme.light,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.light,
    );
  }
}
