import 'package:flutter_riverpod/flutter_riverpod.dart';

class HandelFabStateNotifier extends StateNotifier<bool> {
  HandelFabStateNotifier() : super(false);

  void toggleFab() {
    state = !state;
  }
}

class BottomNavBarStateNotifier extends StateNotifier<int> {
  BottomNavBarStateNotifier() : super(0);

  void toggleActiveIndex(int activeIndex) {
    state = activeIndex;
  }
}
