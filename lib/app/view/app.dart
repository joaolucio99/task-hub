import 'package:flutter/material.dart';
import 'package:task_hub/core/routes/routes.dart';
import 'package:task_hub/core/styles/styles.dart';
import 'package:task_hub/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.black.withOpacity(0.4),
        ),
      ),
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: goRouter,
    );
  }
}
