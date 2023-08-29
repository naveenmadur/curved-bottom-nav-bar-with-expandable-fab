import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notched_navigation_bar/presentation/screen/animated_notched_bottom_nav.dart';

import '../screen/dashboard_with_bottom_nav_bar.dart';

/* class TrialClipper extends CustomClipper<Path> {
  TrialClipper({
    required this.itemsLength,
    required this.startingLocation,
    required this.textDirection,
  });

  final int itemsLength;
  final double startingLocation;
  final TextDirection textDirection;
  late double loc;
  late double s;

  @override
  Path getClip(Size size) {
    final span = 1.0 / itemsLength;
    s = 0.2;
    double l = startingLocation + (span - s) / 2;
    loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
    return Path()
      ..moveTo(0, 0)
      ..lineTo((loc - 0.1) * size.width, 0)
      ..cubicTo(
        (loc + s * 0.20) * size.width,
        size.height * 0.05,
        loc * size.width,
        size.height * 0.60,
        (loc + s * 0.50) * size.width,
        size.height * 0.60,
      )
      ..cubicTo(
        (loc + s) * size.width,
        size.height * 0.60,
        (loc + s - s * 0.20) * size.width,
        size.height * 0.05,
        (loc + s + 0.1) * size.width,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return this != oldClipper;
  }
} */

/* class CircularNotchedRectangleClipper extends CustomClipper<Path> {
  final double? notchMargin;
  final GapLocation? gapLocation;

  const CircularNotchedRectangleClipper(this.gapLocation,
      {this.notchMargin = 7});

  @override
  getClip(Size size) {
    double notchRadius = (54 + (notchMargin ?? 7 * 2)) / 2.0;
    double padding = 15;
    const double s1 = 15.0;
    const double s2 = 1.0;

    double r = notchRadius;
    double a = -1.0 * r - s2;
    // final double b = host.top - guest.center.dy;
    const double b = 0; //- 0;

    final double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = math.sqrt(r * r - p2xA * p2xA);
    final double p2yB = math.sqrt(r * r - p2xB * p2xB);

    final List<Offset> p =
        List<Offset>.filled(6, const Offset(0, 0), growable: false);

    // p0, p1, and p2 are the control points for segment A.
    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    const double cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    // p3, p4, and p5 are the control points for segment B, which is a mirror
    // of segment A around the y axis.
    p[3] = Offset(-1.0 * p[2].dx, p[2].dy);
    p[4] = Offset(-1.0 * p[1].dx, p[1].dy);
    p[5] = Offset(-1.0 * p[0].dx, p[0].dy);

    // translate all points back to the absolute coordinate system.
    for (int i = 0; i < p.length; i += 1) {
      p[i] = p[i] +
          Offset(
              gapLocation == GapLocation.none
                  ? padding + padding + padding
                  : gapLocation == GapLocation.center
                      ? size.width / 2
                      : size.width - padding - padding - padding,
              0);
    }

    return Path()
      ..moveTo(0, 0)
      ..lineTo(p[0].dx, p[0].dy)
      ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
      ..arcToPoint(
        p[3],
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
} */

class CircularNotchedAndCorneredRectangleClipper extends CustomClipper<Path> {
  final ValueListenable<ScaffoldGeometry> geometry;
  final NotchedShape shape;
  final double notchMargin;

  CircularNotchedAndCorneredRectangleClipper({
    required this.geometry,
    required this.shape,
    required this.notchMargin,
  }) : super(reclip: geometry);

  @override
  Path getClip(Size size) {
    final Rect? button = geometry.value.floatingActionButtonArea?.translate(
      0.0,
      geometry.value.bottomNavigationBarTop! * -1.0,
    );

    return shape.getOuterPath(Offset.zero & size, button?.inflate(notchMargin));
  }

  @override
  bool shouldReclip(CircularNotchedAndCorneredRectangleClipper oldClipper) {
    return oldClipper.geometry != geometry ||
        oldClipper.shape != shape ||
        oldClipper.notchMargin != notchMargin;
  }
}

class CircularNotchedAndCorneredRectangle extends NotchedShape {
  final Animation<double>? animation;
  final NotchSmoothness notchSmoothness;
  final GapLocation gapLocation;
  final double leftCornerRadius;
  final double rightCornerRadius;
  final double notchMargin;
  final NotchPosition notchPosition;

  CircularNotchedAndCorneredRectangle({
    required this.notchSmoothness,
    required this.gapLocation,
    required this.leftCornerRadius,
    required this.rightCornerRadius,
    required this.notchMargin,
    required this.notchPosition,
    this.animation,
  });

  Rect getGuest(NotchPosition notchPosition, Rect host) {
    switch (notchPosition) {
      case NotchPosition.center:
        return Rect.fromCenter(
          center: Offset(host.width / 2, 0),
          width: fabSize + (notchMargin * 2),
          height: 10,
        );

      case NotchPosition.left:
        return Rect.fromCenter(
          center: const Offset(
            ((fabSize / 2) + kFloatingActionButtonMargin),
            0,
          ),
          width: fabSize + (notchMargin * 2),
          height: 10,
        );

      case NotchPosition.right:
        return Rect.fromCenter(
          center: Offset(
            host.width - ((fabSize / 2) + kFloatingActionButtonMargin),
            0,
          ),
          width: fabSize + (notchMargin * 2),
          height: 10,
        );
    }
  }

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    guest = getGuest(notchPosition, host);
    if (!host.overlaps(guest)) {
      if (this.rightCornerRadius > 0 || this.leftCornerRadius > 0) {
        double leftCornerRadius =
            this.leftCornerRadius * (animation?.value ?? 1);
        double rightCornerRadius =
            this.rightCornerRadius * (animation?.value ?? 1);
        return Path()
          ..moveTo(host.left, host.bottom)
          ..lineTo(host.left, host.top + leftCornerRadius)
          ..arcToPoint(
            Offset(host.left + leftCornerRadius, host.top),
            radius: Radius.circular(leftCornerRadius),
            clockwise: true,
          )
          ..lineTo(host.right - rightCornerRadius, host.top)
          ..arcToPoint(
            Offset(host.right, host.top + rightCornerRadius),
            radius: Radius.circular(rightCornerRadius),
            clockwise: true,
          )
          ..lineTo(host.right, host.bottom)
          ..lineTo(host.left, host.bottom)
          ..close();
      }
      return Path()..addRect(host);
    }

    final guestCenterDx = guest.center.dx.toInt();
    final halfOfHostWidth = host.width ~/ 2;

    if (guestCenterDx == halfOfHostWidth) {
      if (gapLocation == GapLocation.end) {
        throw GapLocationException(
            'Wrong gap location in $AnimatedBottomNavigationBar towards FloatingActionButtonLocation => '
            'consider use ${GapLocation.center} instead of $gapLocation or change FloatingActionButtonLocation');
      }
    }

    if (guestCenterDx != halfOfHostWidth) {
      if (gapLocation == GapLocation.center) {
        throw GapLocationException(
            'Wrong gap location in $AnimatedBottomNavigationBar towards FloatingActionButtonLocation => '
            'consider use ${GapLocation.end} instead of $gapLocation or change FloatingActionButtonLocation');
      }
    }

    // The guest's shape is a circle bounded by the guest rectangle.
    // So the guest's radius is half the guest width.
    double notchRadius = guest.width / 2 * (animation?.value ?? 1);
    // double notchRadius = fabSize / 2 * (animation?.value ?? 1);
    double leftCornerRadius = this.leftCornerRadius * (animation?.value ?? 1);
    double rightCornerRadius = this.rightCornerRadius * (animation?.value ?? 1);

    // We build a path for the notch from 3 segments:
    // Segment A - a Bezier curve from the host's top edge to segment B.
    // Segment B - an arc with radius notchRadius.
    // Segment C - a Bezier curve from segment B back to the host's top edge.
    //
    // A detailed explanation and the derivation of the formulas below is
    // available at: https://goo.gl/Ufzrqn

    final double s1 = notchSmoothness.s1;
    final double s2 = notchSmoothness.s2;

    double r = notchRadius;
    double a = -1.0 * r - s2;
    double b = host.top - guest.center.dy;
    // double b = host.bottom + fabSize + 12;

    double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    double p2yA = math.sqrt(r * r - p2xA * p2xA);
    double p2yB = math.sqrt(r * r - p2xB * p2xB);

    List<Offset> p = List.filled(6, Offset.zero, growable: true);

    // p0, p1, and p2 are the control points for segment A.
    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    double cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    // p3, p4, and p5 are the control points for segment B, which is a mirror
    // of segment A around the y axis.
    p[3] = Offset(-1.0 * p[2].dx, p[2].dy);
    p[4] = Offset(-1.0 * p[1].dx, p[1].dy);
    p[5] = Offset(-1.0 * p[0].dx, p[0].dy);

    // translate all points back to the absolute coordinate system.
    for (int i = 0; i < p.length; i += 1) {
      p[i] += guest.center;
    }

    return Path()
      ..moveTo(host.left, host.bottom)
      ..lineTo(host.left, host.top + leftCornerRadius)
      ..arcToPoint(
        Offset(host.left + leftCornerRadius, host.top),
        radius: Radius.circular(leftCornerRadius),
        clockwise: true,
      )
      ..lineTo(p[0].dx, p[0].dy)
      ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
      ..arcToPoint(
        p[3],
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
      ..lineTo(host.right - rightCornerRadius, host.top)
      ..arcToPoint(
        Offset(host.right, host.top + rightCornerRadius),
        radius: Radius.circular(rightCornerRadius),
        clockwise: true,
      )
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}
// class CircularNotchedAndCorneredRectangle extends NotchedShape {
//   final Animation<double>? animation;
//   final NotchSmoothness notchSmoothness;
//   final GapLocation gapLocation;
//   final double leftCornerRadius;
//   final double rightCornerRadius;
//
//   CircularNotchedAndCorneredRectangle({
//     required this.notchSmoothness,
//     required this.gapLocation,
//     required this.leftCornerRadius,
//     required this.rightCornerRadius,
//     this.animation,
//   });
//
//   @override
//   Path getOuterPath(Rect host, Rect? guest) {
//     if (guest == null || !host.overlaps(guest)) {
//       if (this.rightCornerRadius > 0 || this.leftCornerRadius > 0) {
//         double leftCornerRadius =
//             this.leftCornerRadius * (animation?.value ?? 1);
//         double rightCornerRadius =
//             this.rightCornerRadius * (animation?.value ?? 1);
//         return Path()
//           ..moveTo(host.left, host.bottom)
//           ..lineTo(host.left, host.top + leftCornerRadius)
//           ..arcToPoint(
//             Offset(host.left + leftCornerRadius, host.top),
//             radius: Radius.circular(leftCornerRadius),
//             clockwise: true,
//           )
//           ..lineTo(host.right - rightCornerRadius, host.top)
//           ..arcToPoint(
//             Offset(host.right, host.top + rightCornerRadius),
//             radius: Radius.circular(rightCornerRadius),
//             clockwise: true,
//           )
//           ..lineTo(host.right, host.bottom)
//           ..lineTo(host.left, host.bottom)
//           ..close();
//       }
//       return Path()..addRect(host);
//     }
//
//     final guestCenterDx = guest.center.dx.toInt();
//     final halfOfHostWidth = host.width ~/ 2;
//
//     if (guestCenterDx == halfOfHostWidth) {
//       if (gapLocation == GapLocation.end) {
//         throw GapLocationException(
//             'Wrong gap location in $AnimatedBottomNavigationBar towards FloatingActionButtonLocation => '
//             'consider use ${GapLocation.center} instead of $gapLocation or change FloatingActionButtonLocation');
//       }
//     }
//
//     if (guestCenterDx != halfOfHostWidth) {
//       if (gapLocation == GapLocation.center) {
//         throw GapLocationException(
//             'Wrong gap location in $AnimatedBottomNavigationBar towards FloatingActionButtonLocation => '
//             'consider use ${GapLocation.end} instead of $gapLocation or change FloatingActionButtonLocation');
//       }
//     }
//
//     // The guest's shape is a circle bounded by the guest rectangle.
//     // So the guest's radius is half the guest width.
//     double notchRadius = guest.width / 2 * (animation?.value ?? 1);
//     double leftCornerRadius = this.leftCornerRadius * (animation?.value ?? 1);
//     double rightCornerRadius = this.rightCornerRadius * (animation?.value ?? 1);
//
//     // We build a path for the notch from 3 segments:
//     // Segment A - a Bezier curve from the host's top edge to segment B.
//     // Segment B - an arc with radius notchRadius.
//     // Segment C - a Bezier curve from segment B back to the host's top edge.
//     //
//     // A detailed explanation and the derivation of the formulas below is
//     // available at: https://goo.gl/Ufzrqn
//
//     final double s1 = notchSmoothness.s1;
//     final double s2 = notchSmoothness.s2;
//
//     double r = notchRadius;
//     double a = -1.0 * r - s2;
//     double b = host.top - guest.center.dy;
//
//     double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
//     double p2xA = ((a * r * r) - n2) / (a * a + b * b);
//     double p2xB = ((a * r * r) + n2) / (a * a + b * b);
//     double p2yA = math.sqrt(r * r - p2xA * p2xA);
//     double p2yB = math.sqrt(r * r - p2xB * p2xB);
//
//     List<Offset> p = List.filled(6, Offset.zero, growable: true);
//
//     // p0, p1, and p2 are the control points for segment A.
//     p[0] = Offset(a - s1, b);
//     p[1] = Offset(a, b);
//     double cmp = b < 0 ? -1.0 : 1.0;
//     p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);
//
//     // p3, p4, and p5 are the control points for segment B, which is a mirror
//     // of segment A around the y axis.
//     p[3] = Offset(-1.0 * p[2].dx, p[2].dy);
//     p[4] = Offset(-1.0 * p[1].dx, p[1].dy);
//     p[5] = Offset(-1.0 * p[0].dx, p[0].dy);
//
//     // translate all points back to the absolute coordinate system.
//     for (int i = 0; i < p.length; i += 1) {
//       p[i] += guest.center;
//     }
//
//     return Path()
//       ..moveTo(host.left, host.bottom)
//       ..lineTo(host.left, host.top + leftCornerRadius)
//       ..arcToPoint(
//         Offset(host.left + leftCornerRadius, host.top),
//         radius: Radius.circular(leftCornerRadius),
//         clockwise: true,
//       )
//       ..lineTo(p[0].dx, p[0].dy)
//       ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
//       ..arcToPoint(
//         p[3],
//         radius: Radius.circular(notchRadius),
//         clockwise: false,
//       )
//       ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
//       ..lineTo(host.right - rightCornerRadius, host.top)
//       ..arcToPoint(
//         Offset(host.right, host.top + rightCornerRadius),
//         radius: Radius.circular(rightCornerRadius),
//         clockwise: true,
//       )
//       ..lineTo(host.right, host.bottom)
//       ..lineTo(host.left, host.bottom)
//       ..close();
//   }
// }

enum NotchSmoothness {
  sharpEdge,
  defaultEdge,
  softEdge,
  smoothEdge,
  verySmoothEdge
}

enum GapLocation { none, center, end }

extension on NotchSmoothness? {
  static const curveS1 = {
    NotchSmoothness.sharpEdge: 0.0,
    NotchSmoothness.defaultEdge: 15.0,
    NotchSmoothness.softEdge: 20.0,
    NotchSmoothness.smoothEdge: 30.0,
    NotchSmoothness.verySmoothEdge: 40.0,
  };

  static const curveS2 = {
    NotchSmoothness.sharpEdge: 0.1,
    NotchSmoothness.defaultEdge: 1.0,
    NotchSmoothness.softEdge: 5.0,
    NotchSmoothness.smoothEdge: 15.0,
    NotchSmoothness.verySmoothEdge: 25.0,
  };

  double get s1 => curveS1[this] ?? 15.0;

  double get s2 => curveS2[this] ?? 1.0;
}

enum NotchPosition {
  center,
  left,
  right,
}
