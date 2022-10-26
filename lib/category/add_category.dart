import 'package:flutter/material.dart';
import 'package:money_management/db/category_db.dart';
import 'package:money_management/models/category/category_model.dart';

ValueNotifier<CategoryType> selectedType = ValueNotifier(CategoryType.income);
Future<void> addCategory(BuildContext context) async {
  final _namecontroller = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text(
            "Add Category",
            textAlign: TextAlign.center,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _namecontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Add Category",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: const [
                  RadioButton(
                    title: "Income",
                    type: CategoryType.income,
                  ),
                  RadioButton(
                    title: "Expense",
                    type: CategoryType.expense,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  final name = _namecontroller.text;
                  if (name.isEmpty) {
                    return;
                  } else {
                    final _type = selectedType.value;
                    final category = CategoryModel(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        name: name,
                        type: _type);
                    CategoryDb.instance.insertCategory(category);
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text(
                  "Add",
                ),
              ),
            ),
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  const RadioButton({Key? key, required this.title, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedType,
            builder: (BuildContext ctx, CategoryType newCategory, _) {
              return Radio<CategoryType>(
                value: type,
                groupValue: newCategory,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selectedType.value = value;
                  selectedType.notifyListeners();
                },
              );
            }),
        Text(title),
      ],
    );
  }
}
