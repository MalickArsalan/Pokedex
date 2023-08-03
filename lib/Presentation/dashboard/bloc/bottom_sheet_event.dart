part of 'bottom_sheet_bloc.dart';

abstract class BottomSheetEvent {}

class TabChange extends BottomSheetEvent {
  final int tabIndex;

  TabChange({required this.tabIndex});
}
