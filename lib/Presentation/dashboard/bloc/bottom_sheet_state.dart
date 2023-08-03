part of 'bottom_sheet_bloc.dart';

abstract class BottomSheetState {
  final int tabIndex;

  const BottomSheetState({required this.tabIndex});
}

class BottomSheetInitial extends BottomSheetState {
  const BottomSheetInitial({required super.tabIndex});
}
