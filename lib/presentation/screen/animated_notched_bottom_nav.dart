import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notched_navigation_bar/presentation/components/circular_notched_rectangle_clipper.dart';

/// Signature for a function that creates a widget for a given index & state.
/// Used by [AnimatedBottomNavigationBar.builder].
typedef IndexedWidgetBuilder = Widget Function(int index, bool isActive);

class AnimatedBottomNavigationBar extends StatefulWidget {
  /// Widgets to render in the tab bar.
  final IndexedWidgetBuilder? tabBuilder;

  /// Total item count.
  final int? itemCount;

  /// Icon data to render in the tab bar.
  final List<IconData>? icons;

  /// Handler which is passed every updated active index.
  final Function(int) onTap;

  /// Current index of selected tab bar item.
  final int activeIndex;

  /// Optional custom size for each tab bar icon. Default is 24.
  final double? iconSize;

  /// Optional custom tab bar height. Default is 56.
  final double? height;

  /// Optional custom notch margin for Floating. Default is 8.
  final double notchMargin;

  /// Optional custom maximum spread radius for splash selection animation. Default is 24.
  final double splashRadius;

  /// Optional custom splash selection animation speed. Default is 300 milliseconds.
  final int? splashSpeedInMilliseconds;

  /// Optional custom tab bar top-left corner radius. Default is 0.
  final double? leftCornerRadius;

  /// Optional custom tab bar top-right corner radius. Useless with [GapLocation.end]. Default is 0.
  final double? rightCornerRadius;

  /// Optional custom tab bar background color. Default is [Colors.white].
  final Color? backgroundColor;

  /// Optional custom splash selection animation color. Default is [Colors.purple].
  final Color? splashColor;

  /// Optional custom currently selected tab bar [IconData] color. Default is [Colors.deepPurpleAccent]
  final Color? activeColor;

  /// Optional custom currently unselected tab bar [IconData] color. Default is [Colors.black]
  final Color? inactiveColor;

  /// Optional custom [Animation] to animate corners and notch appearing.
  final Animation<double>? notchAndCornersAnimation;

  /// Optional custom type of notch. Default is [NotchSmoothness.defaultEdge].
  final NotchSmoothness? notchSmoothness;

  /// Location of the free space between tab bar items for notch.
  /// Must have the same location if [FloatingActionButtonLocation.centerDocked] or [FloatingActionButtonLocation.endDocked].
  /// Default is [GapLocation.end].
  final GapLocation? gapLocation;

  /// Free space width between tab bar items. The preferred width is equal to total width of [FloatingActionButton] and double [notchMargin].
  /// Default is 72.
  final double? gapWidth;

  /// Optional custom tab bar elevation. Default is 8.
  final double? elevation;

  /// Optional custom shadow around the navigation bar.
  final Shadow? shadow;

  /// Specifies whether to avoid system intrusions for specific sides
  final SafeAreaValues safeAreaValues;

  ///The [Curve] that the hide animation will follow.
  ///Defaults to [Curves.fastOutSlowIn],
  final Curve? hideAnimationCurve;

  /// Optional custom border color around the navigation bar. Default is [Colors.transparent].
  final Color? borderColor;

  /// Optional custom border width around the navigation bar. Default is 2.0.
  final double? borderWidth;

  /// Optional hide bottom bar animation controller
  final AnimationController? hideAnimationController;

  /// Optional background gradient.
  ///
  /// If this is specified, [backgroundColor] has no effect.
  final Gradient? backgroundGradient;

  /// Whether blur effect should be applied.
  ///
  /// Makes sense only if [backgroundColor] opacity is < 1.
  final bool blurEffect;

  // Notch position
  final NotchPosition notchPosition;

  static const _defaultSplashRadius = 24.0;
  static const double _defaultNotchMargin = 15;

  AnimatedBottomNavigationBar._internal({
    Key? key,
    required this.activeIndex,
    required this.onTap,
    required this.notchPosition,
    this.tabBuilder,
    this.itemCount,
    this.icons,
    this.height,
    this.splashRadius = _defaultSplashRadius,
    this.splashSpeedInMilliseconds,
    this.notchMargin = _defaultNotchMargin,
    this.backgroundColor,
    this.splashColor,
    this.activeColor,
    this.inactiveColor,
    this.notchAndCornersAnimation,
    this.leftCornerRadius,
    this.rightCornerRadius,
    this.iconSize,
    this.notchSmoothness,
    this.gapLocation,
    this.gapWidth,
    this.elevation,
    this.shadow,
    this.borderColor,
    this.borderWidth,
    this.safeAreaValues = const SafeAreaValues(),
    this.hideAnimationCurve,
    this.hideAnimationController,
    this.backgroundGradient,
    this.blurEffect = false,
  })  : assert(icons != null || itemCount != null),
        assert(
          ((itemCount ?? icons!.length) >= 2) &&
              ((itemCount ?? icons!.length) <= 6),
        ),
        super(key: key) {
    if (gapLocation == GapLocation.end) {
      if (rightCornerRadius != 0) {
        throw NonAppropriatePathException(
            'RightCornerRadius along with ${GapLocation.end} or/and ${FloatingActionButtonLocation.endDocked} causes render issue => '
            'consider set rightCornerRadius to 0.');
      }
    }
    if (gapLocation == GapLocation.center) {
      final iconsCountIsOdd = (itemCount ?? icons!.length).isOdd;
      if (iconsCountIsOdd) {
        throw NonAppropriatePathException(
            'Odd count of icons along with $gapLocation causes render issue => '
            'consider set gapLocation to ${GapLocation.end}');
      }
    }
  }

  AnimatedBottomNavigationBar({
    Key? key,
    required List<IconData> icons,
    required int activeIndex,
    required Function(int) onTap,
    required NotchPosition notchPosition,
    double? height,
    double? splashRadius,
    int? splashSpeedInMilliseconds,
    double notchMargin = _defaultNotchMargin,
    Color? backgroundColor,
    Color? splashColor,
    Color? activeColor,
    Color? inactiveColor,
    Animation<double>? notchAndCornersAnimation,
    double? leftCornerRadius,
    double? rightCornerRadius,
    double? iconSize,
    NotchSmoothness? notchSmoothness,
    GapLocation? gapLocation,
    double? gapWidth,
    double? elevation,
    Shadow? shadow,
    Color? borderColor,
    double? borderWidth,
    SafeAreaValues safeAreaValues = const SafeAreaValues(),
    Curve? hideAnimationCurve,
    AnimationController? hideAnimationController,
    Gradient? backgroundGradient,
    bool blurEffect = false,
  }) : this._internal(
          key: key,
          icons: icons,
          activeIndex: activeIndex,
          onTap: onTap,
          height: height,
          splashRadius: splashRadius ?? _defaultSplashRadius,
          splashSpeedInMilliseconds: splashSpeedInMilliseconds,
          notchMargin: notchMargin,
          backgroundColor: backgroundColor,
          splashColor: splashColor,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          notchAndCornersAnimation: notchAndCornersAnimation,
          leftCornerRadius: leftCornerRadius ?? 0,
          rightCornerRadius: rightCornerRadius ?? 0,
          iconSize: iconSize,
          notchSmoothness: notchSmoothness,
          gapLocation: gapLocation ?? GapLocation.end,
          gapWidth: gapWidth,
          elevation: elevation,
          shadow: shadow,
          borderColor: borderColor,
          borderWidth: borderWidth,
          safeAreaValues: safeAreaValues,
          hideAnimationCurve: hideAnimationCurve,
          hideAnimationController: hideAnimationController,
          backgroundGradient: backgroundGradient,
          blurEffect: blurEffect,
          notchPosition: notchPosition,
        );

  AnimatedBottomNavigationBar.builder({
    Key? key,
    required int itemCount,
    required IndexedWidgetBuilder tabBuilder,
    required int activeIndex,
    required Function(int) onTap,
    required NotchPosition notchPosition,
    double? height,
    double? splashRadius,
    int? splashSpeedInMilliseconds,
    double notchMargin = _defaultNotchMargin,
    Color? backgroundColor,
    Color? splashColor,
    Animation<double>? notchAndCornersAnimation,
    double? leftCornerRadius,
    double? rightCornerRadius,
    NotchSmoothness? notchSmoothness,
    GapLocation? gapLocation,
    double? gapWidth,
    double? elevation,
    Shadow? shadow,
    Color? borderColor,
    double? borderWidth,
    SafeAreaValues safeAreaValues = const SafeAreaValues(),
    Curve? hideAnimationCurve,
    AnimationController? hideAnimationController,
    Gradient? backgroundGradient,
    bool blurEffect = false,
  }) : this._internal(
          key: key,
          tabBuilder: tabBuilder,
          itemCount: itemCount,
          activeIndex: activeIndex,
          onTap: onTap,
          height: height,
          splashRadius: splashRadius ?? _defaultSplashRadius,
          splashSpeedInMilliseconds: splashSpeedInMilliseconds,
          notchMargin: notchMargin,
          backgroundColor: backgroundColor,
          splashColor: splashColor,
          notchAndCornersAnimation: notchAndCornersAnimation,
          leftCornerRadius: leftCornerRadius ?? 0,
          rightCornerRadius: rightCornerRadius ?? 0,
          notchSmoothness: notchSmoothness,
          gapLocation: gapLocation ?? GapLocation.none,
          gapWidth: gapWidth,
          elevation: elevation,
          shadow: shadow,
          borderColor: borderColor,
          borderWidth: borderWidth,
          safeAreaValues: safeAreaValues,
          hideAnimationCurve: hideAnimationCurve,
          hideAnimationController: hideAnimationController,
          backgroundGradient: backgroundGradient,
          blurEffect: blurEffect,
          notchPosition: notchPosition,
        );

  @override
  AnimatedBottomNavigationBarState createState() =>
      AnimatedBottomNavigationBarState();
}

class AnimatedBottomNavigationBarState
    extends State<AnimatedBottomNavigationBar> with TickerProviderStateMixin {
  late ValueListenable<ScaffoldGeometry> geometryListenable;

  late AnimationController _bubbleController;

  double _bubbleRadius = 0;
  double _iconScale = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    geometryListenable = Scaffold.geometryOf(context);

    widget.notchAndCornersAnimation?.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(AnimatedBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeIndex != oldWidget.activeIndex) {
      _startBubbleAnimation();
    }
  }

  _startBubbleAnimation() {
    _bubbleController = AnimationController(
      duration: Duration(milliseconds: widget.splashSpeedInMilliseconds ?? 300),
      vsync: this,
    );

    final bubbleCurve = CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.linear,
    );

    Tween<double>(begin: 0, end: 1).animate(bubbleCurve).addListener(() {
      setState(() {
        _bubbleRadius = widget.splashRadius * bubbleCurve.value;
        if (_bubbleRadius == widget.splashRadius) {
          _bubbleRadius = 0;
        }

        if (bubbleCurve.value < 0.5) {
          _iconScale = 1 + bubbleCurve.value;
        } else {
          _iconScale = 2 - bubbleCurve.value;
        }
      });
    });

    if (_bubbleController.isAnimating) {
      _bubbleController.reset();
    }
    _bubbleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final clipper = CircularNotchedAndCorneredRectangleClipper(
      shape: CircularNotchedAndCorneredRectangle(
        notchMargin: widget.notchMargin,
        animation: widget.notchAndCornersAnimation,
        notchSmoothness: widget.notchSmoothness ?? NotchSmoothness.defaultEdge,
        gapLocation: widget.gapLocation ?? GapLocation.end,
        leftCornerRadius: widget.leftCornerRadius ?? 0.0,
        rightCornerRadius: widget.rightCornerRadius ?? 0.0,
        notchPosition: widget.notchPosition,
      ),
      geometry: geometryListenable,
      notchMargin: 7,
    );

    return PhysicalShape(
      elevation: widget.elevation ?? 8,
      color: Colors.transparent,
      clipper: clipper,
      child: AroundCustomPainter(
        clipper: clipper,
        shadow: widget.shadow,
        borderColor: widget.borderColor ?? Colors.transparent,
        borderWidth: widget.borderWidth ?? 2,
        child: widget.hideAnimationController != null
            ? VisibleAnimator(
                showController: widget.hideAnimationController!,
                curve: widget.hideAnimationCurve ?? Curves.fastOutSlowIn,
                child: _buildBottomBar(),
              )
            : _buildBottomBar(),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Material(
      clipBehavior: Clip.antiAlias,
      color: widget.backgroundColor ?? Colors.white,
      child: SafeArea(
        left: widget.safeAreaValues.left,
        top: widget.safeAreaValues.top,
        right: widget.safeAreaValues.right,
        bottom: widget.safeAreaValues.bottom,
        child: widget.blurEffect
            ? ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 10),
                  child: _buildBody(),
                ),
              )
            : _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      height: widget.height ?? kBottomNavigationBarHeight,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        gradient: widget.backgroundGradient,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: _buildItems(),
      ),
    );
  }

  List<Widget> _buildItems() {
    final gapWidth = widget.gapWidth ?? 72;
    final gapItemWidth = widget.notchAndCornersAnimation != null
        ? gapWidth * widget.notchAndCornersAnimation!.value
        : gapWidth;
    final itemCount = widget.itemCount ?? widget.icons!.length;

    final items = <Widget>[];
    for (var i = 0; i < itemCount; i++) {
      final isActive = i == widget.activeIndex;

      if (widget.gapLocation == GapLocation.center && i == itemCount / 2) {
        items.add(GapItem(width: gapItemWidth));
      }

      items.add(
        NavigationBarItem(
          isActive: isActive,
          bubbleRadius: _bubbleRadius,
          maxBubbleRadius: widget.splashRadius,
          bubbleColor: widget.splashColor,
          activeColor: widget.activeColor,
          inactiveColor: widget.inactiveColor,
          iconData: widget.icons?.elementAt(i),
          iconScale: _iconScale,
          iconSize: widget.iconSize,
          onTap: () => widget.onTap(i),
          child: widget.tabBuilder?.call(i, isActive),
        ),
      );

      if (widget.gapLocation == GapLocation.end && i == itemCount - 1) {
        items.add(GapItem(width: gapItemWidth));
      }
    }
    return items;
  }
}

class SafeAreaValues {
  final bool left;
  final bool top;
  final bool right;
  final bool bottom;

  const SafeAreaValues({
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
  });
}

class NavigationBarItem extends StatelessWidget {
  final bool isActive;
  final double bubbleRadius;
  final double maxBubbleRadius;
  final Color? bubbleColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final IconData? iconData;
  final double iconScale;
  final double? iconSize;
  final VoidCallback onTap;
  final Widget? child;

  const NavigationBarItem({
    super.key,
    required this.isActive,
    required this.bubbleRadius,
    required this.maxBubbleRadius,
    required this.bubbleColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.iconData,
    required this.iconScale,
    required this.iconSize,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: BubblePainter(
            bubbleRadius: isActive ? bubbleRadius : 0,
            bubbleColor: bubbleColor,
            maxBubbleRadius: maxBubbleRadius,
          ),
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: onTap,
            child: Transform.scale(
              scale: isActive ? iconScale : 1,
              child: TabItem(
                isActive: isActive,
                iconData: iconData,
                iconSize: iconSize,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final IconData? iconData;
  final double? iconSize;
  final bool isActive;
  final Color? activeColor;
  final Color? inactiveColor;
  final Widget? child;

  const TabItem({
    Key? key,
    required this.isActive,
    this.iconData,
    this.iconSize = 24,
    this.activeColor = Colors.deepPurpleAccent,
    this.inactiveColor = Colors.black,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => child ?? _buildDefaultTab();

  Widget _buildDefaultTab() {
    return Icon(
      iconData,
      color: isActive ? activeColor : inactiveColor,
      size: iconSize,
    );
  }
}

class BubblePainter extends CustomPainter {
  final double bubbleRadius;
  final double maxBubbleRadius;
  final Color? bubbleColor;
  final Color? endColor;

  BubblePainter({
    required this.bubbleRadius,
    required this.maxBubbleRadius,
    this.bubbleColor = Colors.purple,
  })  : endColor = Color.lerp(bubbleColor, Colors.white, 0.8),
        super();

  @override
  void paint(Canvas canvas, Size size) {
    if (bubbleRadius == maxBubbleRadius) return;

    var animationProgress = bubbleRadius / maxBubbleRadius;

    double strokeWidth = bubbleRadius < maxBubbleRadius * 0.5
        ? bubbleRadius
        : maxBubbleRadius - bubbleRadius;

    final paint = Paint()
      ..color = Color.lerp(bubbleColor, endColor, animationProgress)!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      bubbleRadius,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class GapItem extends StatelessWidget {
  final double width;

  const GapItem({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: width,
      );
}

class AroundCustomPainter extends StatelessWidget {
  final CustomClipper<Path> clipper;

  final Shadow? shadow;

  final double borderWidth;
  final Color borderColor;

  final Widget child;

  const AroundCustomPainter({
    super.key,
    required this.clipper,
    required this.borderWidth,
    required this.borderColor,
    required this.child,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: UniqueKey(),
      painter: _AroundCustomPainter(
        clipper: clipper,
        shadow: shadow,
        borderColor: borderColor,
        borderWidth: borderWidth,
      ),
      child: ClipPath(
        clipper: clipper,
        child: child,
      ),
    );
  }
}

class _AroundCustomPainter extends CustomPainter {
  final CustomClipper<Path> clipper;

  final Shadow? shadow;
  final double borderWidth;
  final Color borderColor;

  _AroundCustomPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.clipper,
    this.shadow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final clipPath = clipper.getClip(size);

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    final shadowPaint = shadow?.toPaint();

    if (size.height != 0) {
      if (borderPaint.color.value != Colors.transparent.value) {
        canvas.drawPath(clipPath, borderPaint);
      }
      if (shadow != null && shadow!.color.value != Colors.transparent.value) {
        canvas.drawPath(clipPath.shift(shadow!.offset), shadowPaint!);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class VisibleAnimator extends StatefulWidget {
  const VisibleAnimator({
    Key? key,
    required this.child,
    required this.showController,
    required this.curve,
  }) : super(key: key);

  final Widget child;
  final Curve curve;

  final AnimationController showController;

  @override
  State<VisibleAnimator> createState() => _VisibleAnimatorState();
}

class _VisibleAnimatorState extends State<VisibleAnimator> {
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: widget.showController, curve: widget.curve),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: -1,
      sizeFactor: _animation,
      child: widget.child,
    );
  }
}

class GapLocationException implements Exception {
  final String _cause;

  GapLocationException(this._cause) : super();

  @override
  String toString() => _cause;
}

class NonAppropriatePathException implements Exception {
  final String _cause;

  NonAppropriatePathException(this._cause) : super();

  @override
  String toString() => _cause;
}

class IllegalFloatingActionButtonSizeException implements Exception {
  final String _cause;

  IllegalFloatingActionButtonSizeException(this._cause) : super();

  @override
  String toString() => _cause;
}
