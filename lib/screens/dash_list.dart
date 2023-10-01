import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calkuta/models/contributor.dart';
import 'package:calkuta/screens/profile.dart';
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
        final contrib = Contributor(id: transaction.contributorId);
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
              onTap: () {
                if (transaction.contributorId! > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(contributor: contrib)),
                  );
                }
              },
              onLongPress: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  animType: AnimType.topSlide,
                  title: 'Delete transaction?',
                  desc:
                      'Are you sure you want to delete this transaction? \n\n ${transaction.name} | ${transaction.amount} | ${transaction.remark}',
                  btnCancelText: 'No',
                  btnOkText: 'Yes',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () async {
                    await DatabaseHelper().deleteTransaction(transaction.id!);
                    Navigator.pushNamed(context, '/');
                  },
                ).show();
              },
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
