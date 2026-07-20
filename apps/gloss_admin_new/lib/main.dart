import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ui_kit/ui_kit.dart';
import 'app.dart';

void main() {
  runApp(const ProviderScope(child: GlossAdminApp()));
}

class GlossAdminApp extends ConsumerWidget {
  const GlossAdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Gloss Admin',
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
