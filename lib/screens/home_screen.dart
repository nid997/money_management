import 'package:flutter/material.dart';
import 'package:money_management/category/add_category.dart';
import 'package:money_management/transactions/transactionbutton.dart';
import 'package:money_management/widget/bottomnavi.dart';
import 'package:money_management/category/catergory_screen.dart';

import '../transactions/transactions_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static ValueNotifier<int> selectedIndex = ValueNotifier(0);

  final _pages = const [
    TransactionScreen(),
    CategoryScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 84, 123),
        title: const Text(
          "Money Manager",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      bottomSheet: const BottomNavigations(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndex,
          builder: (BuildContext ctx, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 60,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          onPressed: () {
            if (selectedIndex.value == 0) {
              Navigator.of(context).pushNamed(TransactionAddButton.routeName);
            } else {
              addCategory(context);
            }
          },
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
