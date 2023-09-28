import 'package:calkuta/screens/trans.dart';
import 'package:calkuta/util/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashList extends StatefulWidget {
  const DashList({super.key});

  @override
  State<DashList> createState() => _DashListState();
}

class _DashListState extends State<DashList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    getTransactionList();
  }

  @override
  Widget build(BuildContext context) {
    String? remark;
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        Transaction transaction = transactions[index];
        Color? color;
        Icon? icon;
        double? transAmount;
        String? amount;
        if (transactions != []) {
          // Determine the color and icon based on transaction type
          color = transaction.type == 'deposit' ? Colors.green : Colors.red;
          icon = transaction.type == 'deposit'
              ? Icon(Icons.arrow_downward, color: color)
              : Icon(Icons.arrow_upward, color: color);

          transAmount = transaction.amount;

          NumberFormat myformat = NumberFormat.decimalPattern('en_us');

          amount = myformat.format(transAmount);
          remark = transaction.remark;
          remark ??= '';
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: ListTile(
              leading: icon,
              title: Text(transaction.name!),
              subtitle: Text("${transaction.date}\n $remark "),
              trailing: Text(
                '₦$amount',
                style: TextStyle(color: color),
              ),
            ),
          ),
        );
      },
    );
  }

  void getTransactionList() async {
    final transactionMaps = await databaseHelper.getTenTransactionMapList();

    if (mounted) {
      setState(() {
        transactions = List.generate(transactionMaps.length, (index) {
          return Transaction.fromMapObject(transactionMaps[index]);
        });
      });
    }
  }
}
