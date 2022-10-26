import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_management/db/category_db.dart';
import 'package:money_management/db/transaction_db.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CategoryDb.instance.refreshUi();
    TransactionDb.instance.refresh();

    return ValueListenableBuilder(
      valueListenable: TransactionDb.instance.transactionListNotifier,
      builder:
          (BuildContext context1, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemBuilder: (ctx, int index) {
            final _value = newList[index];
            return Slidable(
              startActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) async {
                      return showDialog(
                        context: ctx,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              "Confirm delete",
                            ),
                            content: const Text(
                              "Do you want to delete your transaction?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  TransactionDb.instance
                                      .deleteTransaction(_value.id!);
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Yes",
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "No",
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    label: "Delete",
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
              key: Key(_value.id!),
              child: Card(
                borderOnForeground: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                elevation: 0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _value.type == CategoryType.income
                        ? Colors.green
                        : Colors.red,
                    radius: 50,
                    child: Text(
                      parseDate(_value.date),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    "Rs:${_value.amount}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    _value.category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext ctx, int index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: newList.length,
        );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitedDate = _date.split(" ");
    final _result = "${_splitedDate.last}\n${_splitedDate.first}";
    return _result;
  }
}
