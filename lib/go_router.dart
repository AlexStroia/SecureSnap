part of 'app.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter _prepareGoRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    debugLogDiagnostics: kDebugMode,
    routes: [home],
  );
}

// region home
final home = GoRoute(
  name: 'home',
  path: '/home',
  builder: (context, state) {
    var args = const HomeArgs();

    final extra = state.extra;
    if (extra is HomeArgs) {
      args = extra;
    }
    return HomePage(args: args);
  },
  routes: [
    GoRoute(
      name: 'camera',
      path: 'camera',
      builder: (context, state) {
        var args = const CameraArgs();

        final extra = state.extra;
        if (extra is CameraArgs) {
          args = extra;
        }
        return CameraPage(args: args);
      },
    ),
    GoRoute(
      name: 'gallery',
      path: 'gallery',
      builder: (context, state) {
        var args = const GalleryArgs();

        final extra = state.extra;
        if (extra is GalleryArgs) {
          args = extra;
        }
        return GalleryPage(args: args);
      },
    ),
  ],
);
// endregion

class HomeArgs {
  const HomeArgs();
}

class GalleryArgs {
  const GalleryArgs();
}

class CameraArgs {
  const CameraArgs();
}

class SetPinArgs {
  const SetPinArgs();
}

class EnterPinArgs {
  const EnterPinArgs();
}
