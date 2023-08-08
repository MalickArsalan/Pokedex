part of 'bottom_navigation_bar_bloc.dart';

abstract class BottomNavigationBarEvent {}

class TabChange extends BottomNavigationBarEvent {
  final int tabIndex;

  TabChange({required this.tabIndex});
}
