import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/database/drift_database.dart';
import '../data/transit_service.dart';
import 'widgets/skeleton_shimmer.dart';
import 'widgets/liquid_route_card.dart';

class CupertinoRouteListView extends StatefulWidget {
  final TransitService transitService;

  const CupertinoRouteListView({super.key, required this.transitService});

  @override
  State<CupertinoRouteListView> createState() => _CupertinoRouteListViewState();
}

class _CupertinoRouteListViewState extends State<CupertinoRouteListView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initSync();
  }

  Future<void> _initSync() async {
    await widget.transitService.syncRemoteTransitData();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF000000),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450.0),
          child: StreamBuilder<Terminal>(
            stream: widget.transitService.db.watchTerminal(1),
            builder: (context, terminalSnapshot) {
              final terminal = terminalSnapshot.data;
              final isDelayed = terminal?.status == 'Delayed';
              final navColor = isDelayed 
                  ? CupertinoColors.systemOrange.withOpacity(0.8) 
                  : const Color(0xFF000000);

              return CustomScrollView(
                slivers: [
                  CupertinoSliverNavigationBar(
                    largeTitle: Text(
                      terminal?.terminalName ?? 'Loading Terminal...',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.0,
                        color: CupertinoColors.white,
                      ),
                    ),
                    backgroundColor: navColor,
                    border: null,
                  ),
                  _isLoading
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => const SkeletonShimmer(),
                            childCount: 5,
                          ),
                        )
                      : StreamBuilder<List<Route>>(
                          stream: widget.transitService.db.watchRoutes(1),
                          builder: (context, routesSnapshot) {
                            final routes = routesSnapshot.data ?? [];
                            if (routes.isEmpty) {
                              return SliverFillRemaining(
                                child: Center(
                                  child: Text(
                                    'No routes available.',
                                    style: GoogleFonts.inter(color: CupertinoColors.systemGrey),
                                  ),
                                ),
                              );
                            }
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final route = routes[index];
                                  return LiquidGlassRouteCard(
                                    routeName: route.routeName,
                                    origin: route.origin,
                                    destination: route.destination,
                                    fare: route.fare,
                                    onTap: () {
                                      // Handle route selection
                                    },
                                  );
                                },
                                childCount: routes.length,
                              ),
                            );
                          },
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
