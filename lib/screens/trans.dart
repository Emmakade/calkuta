import 'package:calkuta/util/database_helper.dart';
import 'package:calkuta/util/my_color.dart';
import 'package:calkuta/util/progress.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Transaction> transactions = [];
  late ProgressBar _sendingMsgProgressBar;

  @override
  void initState() {
    super.initState();
    _sendingMsgProgressBar = ProgressBar();
    showSendingProgressBar();
  }

  @override
  void dispose() {
    _sendingMsgProgressBar.hide();
    super.dispose();
  }

  void showSendingProgressBar() {
    Future.delayed(Duration.zero, () async {
      _sendingMsgProgressBar.show(context);
    });
  }

  void hideSendingProgressBar() {
    Future.delayed(Duration.zero, () async {
      _sendingMsgProgressBar.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    getTransactionList().whenComplete(() => hideSendingProgressBar());
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: MyColor.mytheme),
          title: const Text(
            'Transaction List',
            style: TextStyle(color: MyColor.mytheme),
          ),
          backgroundColor: Colors.white,
          shadowColor: MyColor.mytheme,
          elevation: 4.0,
          bottom: const TabBar(
            labelColor: MyColor.mytheme,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Deposit'),
              Tab(text: 'Withdraw'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAllTab(),
            _buildDepositTab(),
            _buildWithdrawTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllTab() {
    // Replace this with your actual list of transactions

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        Transaction transaction = transactions[index];

        // Determine the color and icon based on transaction type
        Color color = transaction.type == 'deposit' ? Colors.green : Colors.red;
        Icon icon = transaction.type == 'deposit'
            ? Icon(Icons.arrow_downward, color: color)
            : Icon(Icons.arrow_upward, color: color);
        double transAmount = transaction.amount ?? 0;
        NumberFormat myformat = NumberFormat.decimalPattern('en_us');
        String amount = myformat.format(transAmount);

        String? remark = transaction.remark;
        remark ??= '';
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: ListTile(
              leading: icon,
              title: Text(transaction.name!),
              subtitle: Text("${transaction.date}\n $remark"),
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

  Widget _buildDepositTab() {
    // Replace this with your implementation for the deposit tab
    int length = transactions.length;
    List<Transaction> deposits = <Transaction>[];
    for (int i = 0; i < length; i++) {
      if (transactions[i].type == 'deposit') {
        deposits.add(transactions[i]);
      }
    }

    return ListView.builder(
      itemCount: deposits.length,
      itemBuilder: (context, index) {
        Transaction transaction = deposits[index];

        // Determine the color and icon based on transaction type
        Color color = transaction.type == 'deposit' ? Colors.green : Colors.red;
        Icon icon = transaction.type == 'deposit'
            ? Icon(Icons.arrow_downward, color: color)
            : Icon(Icons.arrow_upward, color: color);

        double transAmount = transaction.amount!;
        NumberFormat myformat = NumberFormat.decimalPattern('en_us');
        String amount = myformat.format(transAmount);

        String? remark = transaction.remark;
        remark ??= '';

        return Card(
          child: ListTile(
            leading: icon,
            title: Text(transaction.name!),
            subtitle: Text("${transaction.date}\n $remark"),
            trailing: Text(
              '₦$amount',
              style: TextStyle(color: color),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWithdrawTab() {
    // Replace this with your implementation for the withdraw tab
    int length = transactions.length;
    List<Transaction> withdraws = <Transaction>[];
    for (int i = 0; i < length; i++) {
      if (transactions[i].type == 'withdraw') {
        withdraws.add(transactions[i]);
      }
    }

    return ListView.builder(
      itemCount: withdraws.length,
      itemBuilder: (context, index) {
        Transaction transaction = withdraws[index];

        // Determine the color and icon based on transaction type
        Color color = transaction.type == 'deposit' ? Colors.green : Colors.red;
        Icon icon = transaction.type == 'deposit'
            ? Icon(Icons.arrow_downward, color: color)
            : Icon(Icons.arrow_upward, color: color);

        double transAmount = transaction.amount!;
        NumberFormat myformat = NumberFormat.decimalPattern('en_us');
        String amount = myformat.format(transAmount);

        String? remark = transaction.remark;
        remark ??= '';

        return Card(
          child: ListTile(
            leading: icon,
            title: Text(transaction.name!),
            subtitle: Text("${transaction.date}\n $remark"),
            trailing: Text(
              '₦$amount',
              style: TextStyle(color: color),
            ),
          ),
        );
      },
    );
  }

  Future<void> getTransactionList() async {
    final transactionMaps = await databaseHelper.getTransactionMapList();

    if (mounted) {
      setState(() {
        transactions = List.generate(transactionMaps.length, (index) {
          return Transaction.fromMapObject(transactionMaps[index]);
        });
      });
    }
  }
}

enum TransactionType { deposit, withdraw }

class Transaction {
  String? name;
  String? date;
  double? amount;
  String? type;
  String? remark;

  Transaction(this.name, this.date, this.amount, this.type, this.remark);

  Transaction.fromMapObject(Map<String, dynamic> map) {
    name = map['name'];
    amount = map['amount'];
    type = map['type'];
    date = map['date'];
    remark = map['remark'];
  }
}
