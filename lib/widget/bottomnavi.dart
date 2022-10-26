import 'package:flutter/material.dart';
import '../Screens/home_screen.dart';

class BottomNavigations extends StatelessWidget {
  const BottomNavigations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeScreen.selectedIndex,
      builder: (BuildContext ctx, int updatedIndex, Widget? _) {
        return BottomNavigationBar(
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
          currentIndex: updatedIndex,
          onTap: (newIndex) {
            HomeScreen.selectedIndex.value = newIndex;
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Transaction"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.category,
                ),
                label: "Category"),
          ],
        );
      },
    );
  }
}
