import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../db/category_db.dart';
import '../models/category/category_model.dart';

class IncomeCategory extends StatelessWidget {
  const IncomeCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDb().incomeList,
      builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
        return ListView.separated(
          itemBuilder: (ctx, index) {
            final category = newList[index];
            return Slidable(
              endActionPane:
                  ActionPane(motion: const ScrollMotion(), children: [
                SlidableAction(
                  backgroundColor: Colors.red,
                  onPressed: (BuildContext context) {
                    CategoryDb.instance.delete(category.id);
                  },
                  icon: Icons.delete,
                ),
              ]),
              child: Card(
                child: ListTile(
                  leading: Text(category.name),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: newList.length,
        );
      },
    );
  }
}
