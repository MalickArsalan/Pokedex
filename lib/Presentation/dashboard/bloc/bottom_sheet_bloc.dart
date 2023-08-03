import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_sheet_event.dart';
part 'bottom_sheet_state.dart';

enum BottomSheetItems { Pokemon, Favorites }

class BottomSheetBloc extends Bloc<BottomSheetEvent, BottomSheetState> {
  BottomSheetBloc() : super(const BottomSheetInitial(tabIndex: 0)) {
    on<BottomSheetEvent>((event, emit) {
      if (event is TabChange) {
        print(event.tabIndex);
        emit(BottomSheetInitial(tabIndex: event.tabIndex));
      }
    });
  }
}
