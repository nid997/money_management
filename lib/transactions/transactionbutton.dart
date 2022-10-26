import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/db/category_db.dart';
import 'package:money_management/db/transaction_db.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';

class TransactionAddButton extends StatefulWidget {
  static const routeName = "Add-transaction";
  const TransactionAddButton({Key? key}) : super(key: key);

  @override
  State<TransactionAddButton> createState() => _TransactionAddButtonState();
}

class _TransactionAddButtonState extends State<TransactionAddButton> {
  CategoryType selectedCategoryType = CategoryType.income;
  DateTime? _selectedDate;
  CategoryModel? _selectedCategoryModel;
  final _formKey = GlobalKey<FormState>();

  String? categoryId;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();
  final _dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Add Transaction",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _purposeTextEditingController,
                  decoration: const InputDecoration(
                    hintText: " Purpose",
                  ),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return "Select purpose !";
                  //   } else {
                  //     return null;
                  //   }
                  // },
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: _amountTextEditingController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: " Amount",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Select amount !";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: _dateTimeController,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          hintText: "dd-mm-yyyy",
                          prefixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_month,
                              color: Colors.blue,
                            ),
                            onPressed: () async {
                              final _date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now().subtract(
                                  const Duration(
                                    days: 365 * 10,
                                  ),
                                ),
                                lastDate: DateTime.now(),
                              );

                              if (_date != null) {
                                setState(() {
                                  _selectedDate = _date;
                                  _dateTimeController.text =
                                      DateFormat("dd-MM-yyyy").format(
                                    _selectedDate!,
                                  );
                                });
                              }
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Select Date !";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Radio<CategoryType?>(
                          value: CategoryType.income,
                          groupValue: selectedCategoryType,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategoryType = CategoryType.income;
                              categoryId = null;
                            });
                          },
                        ),
                        const Text(
                          "Income",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<CategoryType>(
                          value: CategoryType.expense,
                          groupValue: selectedCategoryType,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategoryType = CategoryType.expense;
                              categoryId = null;
                            });
                          },
                        ),
                        const Text(
                          "Expense",
                        ),
                      ],
                    ),
                  ],
                ),
                DropdownButton<String>(
                  hint: const Text(
                    "Select Category",
                  ),
                  value: categoryId,
                  items: (selectedCategoryType == CategoryType.income
                          ? CategoryDb().incomeList.value
                          : CategoryDb().expenseList.value)
                      .map(
                    (e) {
                      return DropdownMenuItem(
                        onTap: () {
                          _selectedCategoryModel = e;
                        },
                        value: e.id,
                        child: Text(
                          e.name,
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (selectedValue) {
                    setState(() {
                      categoryId = selectedValue;
                    });
                  },
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        _formKey.currentState!.validate();
                        await addTransaction();
                      },
                      child: const Text(
                        "Submit",
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 181, 181, 181),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purpose = _purposeTextEditingController.text;
    final _amount = _amountTextEditingController.text;

    if (_selectedCategoryModel == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    final _parsedAmount = double.tryParse(_amount);
    if (_parsedAmount == null) {
      return;
    }

    final _transactionDetail = TransactionModel(
      purpose: _purpose,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: selectedCategoryType,
      category: _selectedCategoryModel!,
    );
    TransactionDb.instance.addTransaction(_transactionDetail);
    Navigator.of(context).pop();
    TransactionDb.instance.refresh();
  }
}
