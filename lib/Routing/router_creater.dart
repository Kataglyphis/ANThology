import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:anthology/Pages/ErrorPage/error_page.dart';
import 'package:anthology/Pages/Footer/default_footer_pages.dart';
import 'package:anthology/Pages/Footer/footer.dart';
import 'package:anthology/Pages/Footer/footer_page.dart';
import 'package:anthology/Pages/Footer/open_source_licenses_page.dart';
import 'package:anthology/Pages/Home/home.dart';
import 'package:anthology/Pages/markdown_content_page.dart';

import 'package:anthology/app_attributes.dart';
import 'package:anthology/blog_page_config.dart';
import 'package:anthology/my_two_cents_config.dart';
import 'package:anthology/Pages/stateful_branch_info_provider.dart';

abstract class RoutesCreator {
  final _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: "_rootNavigatorKey",
  );

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>(
    debugLabel: "scaffoldKey",
  );

  String _getInitialLocation(
    AppAttributes appAttributes,
    int currentPageIndex,
  ) {
    List<(Widget, StatefulBranchInfoProvider)> allPages =
        getAllPagesWithConfigs(appAttributes);
    return allPages[currentPageIndex].$2.getRoutingName();
  }

  List<(Widget, StatefulBranchInfoProvider)> getAllPagesWithConfigs(
    AppAttributes appAttributes,
  );

  /// The footer under every page: the app's footer pages and the user's links.
  Footer getFooter(AppAttributes appAttributes) {
    return Footer(
      footerPagesConfigs: appAttributes.screenConfigurations
          .getFooterPagesConfig(),
      userSettings: appAttributes.userSettings,
      footerConfig: appAttributes.footerConfig,
    );
  }

  /// [pages] paired with [configs] in order; both lists must be equally long.
  List<(Widget, StatefulBranchInfoProvider)> pairPagesWithConfigs(
    List<Widget> pages,
    List<StatefulBranchInfoProvider> configs,
  ) {
    assert(
      pages.length == configs.length,
      '${pages.length} pages for ${configs.length} configs',
    );
    return [for (int i = 0; i < pages.length; i++) (pages[i], configs[i])];
  }

  /// A [FooterPage] per footer config, and [OpenSourceLicensesPage] on [openSourceLicensesRoute].
  List<(Widget, StatefulBranchInfoProvider)> footerPagesWithConfigs(
    AppAttributes appAttributes,
  ) {
    return appAttributes.screenConfigurations.getFooterPagesConfig().map((
      pageConfig,
    ) {
      final Widget page = pageConfig.getRoutingName() == openSourceLicensesRoute
          ? OpenSourceLicensesPage(
              footer: getFooter(appAttributes),
              appAttributes: appAttributes,
            )
          : FooterPage(
              footer: getFooter(appAttributes),
              appAttributes: appAttributes,
              filePathDe: pageConfig.getFilePathDe(),
              filePathEn: pageConfig.getFilePathEn(),
            );
      return (page, pageConfig);
    }).toList();
  }

  /// A [MarkdownContentPage] per blog post.
  List<(Widget, StatefulBranchInfoProvider)> blogPagesWithConfigs(
    AppAttributes appAttributes,
    List<BlogPageConfig> configs,
  ) => _markdownPagesWithConfigs(appAttributes, configs, (config) => config);

  /// A [MarkdownContentPage] per media review.
  List<(Widget, StatefulBranchInfoProvider)> mediaCriticsPagesWithConfigs(
    AppAttributes appAttributes,
    List<MyTwoCentsConfig> configs,
  ) => _markdownPagesWithConfigs(appAttributes, configs, (config) => config);

  List<(Widget, StatefulBranchInfoProvider)>
  _markdownPagesWithConfigs<C extends StatefulBranchInfoProvider>(
    AppAttributes appAttributes,
    List<C> configs,
    MarkdownContentConfig Function(C) content,
  ) {
    return configs
        .map(
          (pageConfig) => (
            MarkdownContentPage(
              footer: getFooter(appAttributes),
              appAttributes: appAttributes,
              config: content(pageConfig),
            ),
            pageConfig,
          ),
        )
        .toList();
  }

  /// An [ErrorPage] per error config; the router redirects unknown routes to the first.
  List<(Widget, StatefulBranchInfoProvider)> errorPagesWithConfigs(
    AppAttributes appAttributes,
  ) {
    final List<StatefulBranchInfoProvider> configs = appAttributes
        .screenConfigurations
        .getErrorPagesConfig();
    return pairPagesWithConfigs(<Widget>[
      for (final _ in configs)
        ErrorPage(
          footer: getFooter(appAttributes),
          appAttributes: appAttributes,
        ),
    ], configs);
  }

  GoRouter getRouterConfig(
    AppAttributes appAttributes,
    AnimationController controller,
    final void Function(int value) handleChangedPageIndex,
    int currentPageIndex,
  ) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: _getInitialLocation(appAttributes, currentPageIndex),
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
          builder:
              (
                BuildContext context,
                GoRouterState state,
                StatefulNavigationShell navigationShell,
              ) {
                // navigationShell lets Home switch branches while keeping each branch's state.
                return Home(
                  handleChangedPageIndex: handleChangedPageIndex,
                  scaffoldKey: scaffoldKey,
                  footer: getFooter(appAttributes),
                  appAttributes: appAttributes,
                  controller: controller,
                  navigationShell: navigationShell,
                );
              },
          branches: createBranches(appAttributes),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        var allValidRoutes = appAttributes.screenConfigurations
            .getAllValidRoutes();
        if (!allValidRoutes.contains(state.fullPath)) {
          return appAttributes.screenConfigurations
              .getErrorPagesConfig()
              .first
              .getRoutingName();
        }
        // no need to redirect at all
        return null;
      },
    );
  }

  GoRoute buildGoRouteForSPA(
    (Widget, StatefulBranchInfoProvider) allPagesWithConfigs,
    AppAttributes appAttributes,
  ) {
    return GoRoute(
      path: allPagesWithConfigs.$2.getRoutingName(),
      pageBuilder: (context, state) {
        return NoTransitionPage(child: allPagesWithConfigs.$1);
      },
    );
  }

  List<StatefulShellBranch> createStatefulShellBranches(
    AppAttributes appAttributes,
    List<(Widget, StatefulBranchInfoProvider)> allPagesWithConfigs,
  ) {
    List<StatefulShellBranch> branches = [];
    for (int i = 0; i < allPagesWithConfigs.length; i++) {
      final pageWithConfig = allPagesWithConfigs[i];

      branches.add(
        StatefulShellBranch(
          routes: <RouteBase>[
            buildGoRouteForSPA(pageWithConfig, appAttributes),
          ],
        ),
      );
    }
    return branches;
  }

  List<StatefulShellBranch> createBranches(AppAttributes appAttributes) {
    List<(Widget, StatefulBranchInfoProvider)> allPagesWithConfigs =
        getAllPagesWithConfigs(appAttributes);
    return createStatefulShellBranches(appAttributes, allPagesWithConfigs);
  }
}
