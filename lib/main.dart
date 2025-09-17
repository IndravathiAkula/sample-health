import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import './l10n/app_localizations.dart';
import './services/localization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize localization service
  await LocalizationService().initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return ListenableBuilder(
          listenable: LocalizationService(),
          builder: (context, child) {
            return MaterialApp(
                title: 'Healthcare Connect',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                locale: LocalizationService().currentLocale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                builder: (context, child) {
                  return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.linear(1.0)),
                      child: child!);
                },
                initialRoute: AppRoutes.initial,
                routes: AppRoutes.routes);
          });
    });
  }
}
