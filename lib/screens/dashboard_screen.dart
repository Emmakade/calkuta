import 'package:calkuta/models/contributor.dart';
import 'package:calkuta/screens/dash_list.dart';
import 'package:calkuta/screens/registration_screen.dart';
import 'package:calkuta/screens/transaction_input_screen.dart';
import 'package:calkuta/util/database_helper.dart';
import 'package:calkuta/util/my_color.dart';
import 'package:calkuta/util/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double totalBalance = 0;
  String totalBalanceString = '';
  DatabaseHelper databaseHelper = DatabaseHelper();
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

  Future<void> calculateTotalBalance() async {
    double balance = await databaseHelper.getTotalBalance();
    NumberFormat myformat = NumberFormat.decimalPattern('en_us');
    totalBalance = balance;

    if (mounted) {
      setState(() {
        totalBalanceString = '₦';
        //totalBalanceString += myformat.format(totalBalance);

        if (totalBalance == 0.0 || totalBalance == 0) {
          totalBalanceString += '0';
        } else {
          totalBalanceString += myformat.format(totalBalance);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));

    calculateTotalBalance().whenComplete(() => hideSendingProgressBar());

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(220),
          child: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            centerTitle: true,
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/bg.png"),
                      opacity: 0.9,
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30.0),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(
                      flex: 3,
                    ),
                    const Text(
                      'Grand Total Savings',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      totalBalanceString,
                      style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: MyColor.mytheme),
                    ),
                    const Spacer(),
                  ],
                )),
            title: const Text(
              "DASHBOARD",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: MyColor.mytheme,
              ),
            ),
            automaticallyImplyLeading: false,
            actions: [
              PopupMenuButton<int>(
                itemBuilder: ((context) => [
                      const PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: MyColor.mytheme,
                                radius: 15,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Update'),
                            ],
                          )),
                      const PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: MyColor.mytheme,
                                radius: 15,
                                child: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Import/Export'),
                            ],
                          )),
                    ]),
                offset: const Offset(0, 50),
                color: Colors.white,
                elevation: 2,
                onSelected: (value) {
                  if (value == 1) {
                    //Navigator.pushNamed(context, '/update');
                  } else {
                    Navigator.pushNamed(context, '/databasescreen');
                  }
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: IconButton(
                      icon: const Icon(Icons.person_add),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationScreen(
                                    appBarTitle: 'REGISTRATION',
                                    contributor: Contributor())));
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      color: Colors.white,
                      onPressed: () {
                        //Navigator.pushNamed(context, '/transaction-input');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionInputScreen(
                                      transactionStat: true,
                                      totalBal: totalBalance,
                                    )));
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      color: Colors.white,
                      onPressed: () {
                        //Navigator.pushNamed(context, '/transaction-input');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionInputScreen(
                                      transactionStat: false,
                                      totalBal: totalBalance,
                                    )));
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Transaction List',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                            color: MyColor.mytheme, width: 1.0)),
                    icon: const Icon(Icons.arrow_circle_right,
                        color: Color.fromARGB(255, 127, 98, 132), size: 20),
                    label: const Text(
                      'View All',
                      style: TextStyle(
                          color: Color.fromARGB(255, 127, 98, 132),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/trans');
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: totalBalance > 0 ? const DashList() : Container(),
              )
            ],
          ),
        ));
  }
}
