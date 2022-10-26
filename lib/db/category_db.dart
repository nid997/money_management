import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management/models/category/category_model.dart';

const categorydB = "category_db";

abstract class CategoryDbFunctions {
  Future<void> insertCategory(CategoryModel value);
  Future<List<CategoryModel>> getDetails();
  Future<void> delete(String categoryId);
}

class CategoryDb implements CategoryDbFunctions {
  CategoryDb.internal();

  static CategoryDb instance = CategoryDb.internal();
  factory CategoryDb() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeList = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseList = ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final categoryDb = await Hive.openBox<CategoryModel>(categorydB);
    categoryDb.put(value.id, value);
    refreshUi();
  }

  @override
  Future<List<CategoryModel>> getDetails() async {
    final categoryDb = await Hive.openBox<CategoryModel>(categorydB);
    return categoryDb.values.toList();
  }

  Future<void> refreshUi() async {
    final _allCategory = await getDetails();
    incomeList.value.clear();
    expenseList.value.clear();

    Future.forEach(
      _allCategory,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeList.value.add(category);
        } else {
          expenseList.value.add(category);
        }
      },
    );
    incomeList.notifyListeners();
    expenseList.notifyListeners();
  }

  @override
  Future<void> delete(String categoryId) async {
    final categoryDb = await Hive.openBox<CategoryModel>(categorydB);
    await categoryDb.delete(categoryId);
    refreshUi();
  }
}
