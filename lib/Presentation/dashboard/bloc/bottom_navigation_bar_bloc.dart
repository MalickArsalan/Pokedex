import 'package:bloc/bloc.dart';

part 'bottom_navigation_bar_event.dart';
part 'bottom_navigation_bar_state.dart';

enum BottomNavigationBarItems { Pokemon, Favorites }

class BottomNavigationBarBloc
    extends Bloc<BottomNavigationBarEvent, BottomNavigationBarState> {
  BottomNavigationBarBloc()
      : super(const BottomNavigationBarInitial(tabIndex: 0)) {
    on<BottomNavigationBarEvent>((event, emit) {
      if (event is TabChange) {
        print(event.tabIndex);
        emit(BottomNavigationBarInitial(tabIndex: event.tabIndex));
      }
    });
  }
}
