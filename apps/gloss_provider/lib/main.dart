import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ui_kit/ui_kit.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(const ProviderScope(child: GlossProviderApp()));
}

class GlossProviderApp extends ConsumerWidget {
  const GlossProviderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Gloss Provider',
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
        colorSchemeSeed: GlossColors.green,
        useMaterial3: true,
        brightness: Brightness.dark,
        extensions: const [GlossTheme.light],
      ),
      themeMode: ThemeMode.light,
    );
  }
}
