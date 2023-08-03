import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bottom_sheet_bloc.dart';

List<BottomNavigationBarItem> bottomNavItems = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.list_alt_outlined),
    label: 'Pokemon',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.favorite_outlined),
    label: 'Favorites',
  ),
];

const List<Widget> bottomNavScreen = <Widget>[
  Center(child: Text('Index 0: Pokemon')),
  Center(child: Text('Index 1: Category')),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomSheetBloc, BottomSheetState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.tabIndex,
            children: bottomNavScreen,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavItems,
            currentIndex: state.tabIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              BlocProvider.of<BottomSheetBloc>(context)
                  .add(TabChange(tabIndex: index));
            },
          ),
        );
      },
    );
  }
}
