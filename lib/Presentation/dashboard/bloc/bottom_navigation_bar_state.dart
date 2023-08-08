part of 'bottom_navigation_bar_bloc.dart';

abstract class BottomNavigationBarState {
  final int tabIndex;

  const BottomNavigationBarState({required this.tabIndex});
}

class BottomNavigationBarInitial extends BottomNavigationBarState {
  const BottomNavigationBarInitial({required super.tabIndex});
}
