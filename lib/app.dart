import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_snap/camera/camera_page.dart';
import 'package:secure_snap/set_pin/set_pin_page.dart';
import 'package:secure_snap/utils/dialog_page.dart';

import 'enter_pin/enter_pin_page.dart';
import 'gallery/gallery_page.dart';
import 'home/home_page.dart';
import 'l10n/l10n.dart';

part 'go_router.dart';

class SecureSnapMobile extends StatelessWidget {
  const SecureSnapMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const _NavigationRoot();
  }
}

/// We don't want to constantly rebuild GoRouter.
/// Especially during development, because it will reset the active location.
/// Therefore, this widget is only responsible for storing an instance of _goRouter,
/// which depends on the AuthController declared above.
class _NavigationRoot extends StatefulWidget {
  const _NavigationRoot();

  @override
  State<_NavigationRoot> createState() => _NavigationRootState();
}

class _NavigationRootState extends State<_NavigationRoot>
    with WidgetsBindingObserver {
  late final _goRouter = _prepareGoRouter();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            supportedLocales: const [Locale('en', '')],
            localizationsDelegates: const [
              L10n.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: _goRouter,
            theme: theme,
          );
        },
      ),
    );
  }
}
