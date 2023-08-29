import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notched_navigation_bar/common/color_constants.dart';
import 'package:notched_navigation_bar/presentation/components/circular_notched_rectangle_clipper.dart';
import 'package:notched_navigation_bar/presentation/screen/animated_notched_bottom_nav.dart';
import 'package:notched_navigation_bar/presentation/screen/state_notifiers/handel_fab_state_notifier.dart';
import 'dart:math' as math;

enum ExpandedFabType {
  vertical,
  circular,
}

final fabProvider = StateNotifierProvider<HandelFabStateNotifier, bool>(
  (ref) => HandelFabStateNotifier(),
);
final bottomNavProvider = StateNotifierProvider<BottomNavBarStateNotifier, int>(
  (ref) => BottomNavBarStateNotifier(),
);

(FloatingActionButtonLocation, AlignmentGeometry) getFabLocation(
  NotchPosition position,
) {
  switch (position) {
    case NotchPosition.center:
      return (
        FloatingActionButtonLocation.centerDocked,
        Alignment.bottomCenter,
      );
    case NotchPosition.left:
      return (
        FloatingActionButtonLocation.startDocked,
        Alignment.bottomLeft,
      );
    case NotchPosition.right:
      return (
        FloatingActionButtonLocation.endDocked,
        Alignment.bottomRight,
      );
  }
}

const NotchPosition notchPosition = NotchPosition.center;
const double fabSize = 54;

class DashboardWithBottomNavigation extends ConsumerWidget {
  const DashboardWithBottomNavigation({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  /// Need to adjust [Padding] manually. [gapWidth] is provided.
  static List<Widget> _itemsWidget(BuildContext context) {
    final gapWidth = MediaQuery.of(context).size.width -
        ((fabSize / 2) + kFloatingActionButtonMargin);
    return <Widget>[
      const Icon(
        Icons.home_outlined,
        color: ColorConstants.cC6C6C6,
      ),
      Padding(
        padding: EdgeInsets.only(right: gapWidth / 8),
        child: const Icon(
          Icons.attach_money_outlined,
          color: ColorConstants.cC6C6C6,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: gapWidth / 8),
        child: const Icon(
          Icons.account_balance_outlined,
          color: ColorConstants.cC6C6C6,
        ),
      ),
      const Icon(
        Icons.person_2_outlined,
        color: ColorConstants.cC6C6C6,
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = ref.watch(bottomNavProvider);
    // final showFab = ref.watch(fabProvider);
    // final fabNotifier = ref.read(fabProvider.notifier);
    return Scaffold(
      body: navigationShell,
      floatingActionButtonLocation: getFabLocation(notchPosition).$1,
      floatingActionButton: ExpandableFloatingActionButton(
        expandedFabType: ExpandedFabType.circular,
        notchPosition: NotchPosition.center,
        children: List.generate(
          5,
          (index) => ExpandedFabChildWidget(
            onTap: () {},
            icon: const Icon(Icons.safety_check),
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        backgroundColor: Colors.black,
        itemCount: _itemsWidget(context).length,
        tabBuilder: (index, isActive) {
          return _itemsWidget(context)[index];
        },
        activeIndex: activeIndex,
        onTap: (index) {
          ref.read(bottomNavProvider.notifier).toggleActiveIndex(index);
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        notchSmoothness: NotchSmoothness.defaultEdge,
        notchMargin: 6,
        notchPosition: notchPosition,
      ),
    );
  }
}

/// This Floating action button is used along with its children to create
/// a expanded FAB when tapped on the [floatingActionButtonChild].
/// If [floatingActionButtonChild] is not provided, [Icons.add] default value is provided
/// The [children] is a List of [ExpandedFabChildWidget] which has its separate
/// onTap methods.
/// To achieve circular expanded FAB [ExpandedFabType.circular] at least 4 child
/// elements are required.
class ExpandableFloatingActionButton extends StatefulWidget {
  const ExpandableFloatingActionButton({
    super.key,
    this.floatingActionButtonChild = const Icon(Icons.add),
    this.expandedFabType = ExpandedFabType.vertical,
    required this.children,
    required this.notchPosition,
  });
  final Widget floatingActionButtonChild;
  final ExpandedFabType expandedFabType;
  final List<ExpandedFabChildWidget> children;
  final NotchPosition notchPosition;

  @override
  State<ExpandableFloatingActionButton> createState() =>
      _ExpandableFloatingActionButtonState();
}

class _ExpandableFloatingActionButtonState
    extends State<ExpandableFloatingActionButton> {
  bool _open = false;
  bool get _getIsOpen => _open;

  void _toggle() {
    setState(() {
      _open = !_open;
    });
  }

  Widget getExpandedFab({
    required ExpandedFabType expandedFabPosition,
    required List<ExpandedFabChildWidget> children,
  }) {
    switch (expandedFabPosition) {
      case ExpandedFabType.circular:
        return _CircularExpandedFab(
          notchPosition: widget.notchPosition,
          children: children,
        );

      case ExpandedFabType.vertical:
        return _VerticalExpandedFab(
          children: children,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          _getIsOpen ? const EdgeInsets.only(bottom: 28.0) : EdgeInsets.zero,
      child: Stack(
        alignment: getFabLocation(notchPosition).$2,
        children: [
          _getIsOpen
              ? getExpandedFab(
                  expandedFabPosition: widget.expandedFabType,
                  children: widget.children,
                ).animate().fadeIn().moveY(
                    end: -40,
                    begin: 0,
                    duration: const Duration(milliseconds: 150),
                  )
              : const SizedBox(),
          SizedBox(
            width: fabSize,
            height: fabSize,
            child: FloatingActionButton(
              elevation: 0,
              child: _getIsOpen
                  ? widget.floatingActionButtonChild.animate().rotate(
                        begin: 0,
                        end: 0.38,
                        curve: Curves.decelerate,
                      )
                  : widget.floatingActionButtonChild,
              onPressed: () {
                _toggle();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandedFabChildWidget extends StatelessWidget {
  const ExpandedFabChildWidget({
    super.key,
    required this.onTap,
    required this.icon,
  });
  final void Function() onTap;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 28,
        child: icon,
      ),
    );
  }
}

class _CircularExpandedFab extends StatelessWidget {
  const _CircularExpandedFab({
    required this.children,
    required this.notchPosition,
  });

  final List<ExpandedFabChildWidget> children;
  final NotchPosition notchPosition;

  ({double bottom, double left}) getPosition(
    NotchPosition notchPosition,
    BuildContext context,
    int i,
  ) {
    final double centerX = MediaQuery.of(context).size.width / 2.3;
    final double centerY = MediaQuery.of(context).size.height / 6;
    const double radius = 100;
    switch (notchPosition) {
      case NotchPosition.right:
        return (
          bottom: centerY -
              radius * math.cos((i * math.pi) / (children.length - 1)),
          left: centerX -
              radius * math.sin((i * math.pi) / (children.length - 1)),
        );
      case NotchPosition.left:
        return (bottom: 0, left: 0);

      case NotchPosition.center:
        return (
          bottom: radius * math.sin((i * math.pi) / (children.length - 1)),
          left: centerX -
              radius * math.cos((i * math.pi) / (children.length - 1)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    const int delay = 50;
    return Stack(
      fit: StackFit.loose,
      alignment: getFabLocation(notchPosition).$2,
      children: [
        for (int i = 0; i < children.length; i++)
          Positioned(
            bottom: getPosition(notchPosition, context, i).bottom,
            left: getPosition(notchPosition, context, i).left,
            child: children[i],
          ).animate().fadeIn(
                delay: Duration(milliseconds: delay * i),
              )
      ],
    );
  }
}

class _VerticalExpandedFab extends StatelessWidget {
  final List<ExpandedFabChildWidget> children;

  const _VerticalExpandedFab({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: children.map(
            (e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: e,
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
