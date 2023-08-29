import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:notched_navigation_bar/presentation/screen/dashboard_with_bottom_nav_bar.dart';
import 'package:notched_navigation_bar/presentation/screen/home_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _profileKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _transactionsKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _budgetKey = GlobalKey<NavigatorState>();

final GoRouter goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/homeScreen',
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    dashboardRoutes,
  ],
);

final dashboardRoutes = StatefulShellRoute.indexedStack(
  branches: <StatefulShellBranch>[
    StatefulShellBranch(
      navigatorKey: _homeKey,
      routes: <RouteBase>[
        GoRoute(
          path: '/homeScreen',
          builder: (
            final BuildContext context,
            final GoRouterState state,
          ) =>
              const HomeScreen(),
        ),
      ],
    ),
    StatefulShellBranch(
      navigatorKey: _transactionsKey,
      routes: <RouteBase>[
        GoRoute(
          path: '/transactionsScreen',
          builder: (
            final BuildContext context,
            final GoRouterState state,
          ) =>
              const TransactionsScreen(),
        ),
      ],
    ),
    StatefulShellBranch(
      navigatorKey: _budgetKey,
      routes: <RouteBase>[
        GoRoute(
          path: '/budgetScreen',
          builder: (
            final BuildContext context,
            final GoRouterState state,
          ) =>
              const BudgetScreen(),
        ),
      ],
    ),
    StatefulShellBranch(
      navigatorKey: _profileKey,
      routes: <RouteBase>[
        GoRoute(
          path: '/profileScreen',
          builder: (
            final BuildContext context,
            final GoRouterState state,
          ) =>
              const ProfileScreen(),
        ),
      ],
    ),
  ],
  builder: (
    final BuildContext context,
    final GoRouterState state,
    final StatefulNavigationShell navigationShell,
  ) {
    return DashboardWithBottomNavigation(navigationShell: navigationShell);
  },
);
