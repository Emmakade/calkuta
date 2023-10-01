import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calkuta/models/contributor.dart';
import 'package:calkuta/screens/registration_screen.dart';
import 'package:calkuta/screens/trans.dart';
import 'package:calkuta/util/database_helper.dart';
import 'package:calkuta/util/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.contributor}) : super(key: key);
  final Contributor contributor;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  late Contributor contributorProfile;
  Map<String, dynamic> profileMaps = {};
  List<Transaction> userTransaction = [];
  int? id;
  String? myName;
  String myBalance = '';
  String? profileImage;
  bool isImageNull = false;

  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    contributorProfile = widget.contributor;
    getProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    var color2 = Colors.grey;
    id = widget.contributor.id;
    myName = contributorProfile.name;
    isImageNull = profileImage == null ? true : false;

    return Scaffold(
      backgroundColor: color2,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('USER\'S PROFILE'),
        shadowColor: Colors.transparent,
        backgroundColor: color2,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegistrationScreen(
                          appBarTitle: 'EDIT USER',
                          contributor: contributorProfile,
                        )),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Edit User\'s Profile',
          )
        ],
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/logo.png"),
              opacity: 0.1,
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(1),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 65,
                          child: isImageNull
                              ? CircleAvatar(
                                  backgroundImage: const AssetImage(
                                    'assets/smart.jpg',
                                  ),
                                  onBackgroundImageError:
                                      (exception, stackTrace) {
                                    setState(() {
                                      isImageNull = true;
                                    });
                                  },
                                  radius: 60,
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(
                                      File(profileImage!),
                                      scale: 1.0),
                                  onBackgroundImageError:
                                      (exception, stackTrace) {
                                    setState(() {
                                      isImageNull = true;
                                    });
                                  },
                                  radius: 60,
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${contributorProfile.name}',
                          style: const TextStyle(
                            color: MyColor.mytheme,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${contributorProfile.id}',
                          style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(columnSpacing: 10, columns: [
                      const DataColumn(
                          label: Text(
                        'Balance',
                        style: TextStyle(color: Colors.white),
                      )),
                      DataColumn(
                          label: Text(myBalance,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900)))
                    ], rows: [
                      DataRow(cells: [
                        const DataCell(Text('Bank:',
                            style: TextStyle(color: Colors.white))),
                        DataCell(Text('${contributorProfile.bankName}',
                            style: const TextStyle(color: Colors.white)))
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Account Number:',
                            style: TextStyle(color: Colors.white))),
                        DataCell(Text('${contributorProfile.bankAcctNo}',
                            style: const TextStyle(color: Colors.white)))
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Gender:',
                            style: TextStyle(color: Colors.white))),
                        DataCell(Text('${contributorProfile.gender}',
                            style: const TextStyle(color: Colors.white)))
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Phone:',
                            style: TextStyle(color: Colors.white))),
                        DataCell(Text('${contributorProfile.phone}',
                            style: const TextStyle(color: Colors.white)))
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Email:',
                            style: TextStyle(color: Colors.white))),
                        DataCell(Text(
                          '${contributorProfile.email}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ))
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Address:',
                            style: TextStyle(color: Colors.white))),
                        DataCell(Text('${contributorProfile.addr}',
                            style: const TextStyle(color: Colors.white)))
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('DateJoined:',
                            style: TextStyle(color: Colors.white))),
                        DataCell(Text('${contributorProfile.dateJoined}',
                            style: const TextStyle(color: Colors.white)))
                      ]),
                    ]),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: MyColor.mytheme),
                      onPressed: () {
                        showOverlay(context);
                      },
                      child: const Text(
                        'View my transaction',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ))),
    );
  }

  void getProfileDetails() async {
    final profileMapList =
        await databaseHelper.getUserMapList(widget.contributor.id!);
    double pBalance = 0;
    NumberFormat myformat = NumberFormat.decimalPattern('en_us');
    List<Map<String, dynamic>> resultList = profileMapList.toList();
    profileMaps = convertQueryResultSet(resultList);
    //print("profileMaps: $profileMaps");

    setState(() {
      contributorProfile = Contributor.fromMapObject(profileMaps);
      pBalance = profileMaps['balance'];
      profileImage = profileMaps['imageDp'];
      myBalance = myformat.format(pBalance);
    });
  }

  Map<String, dynamic> convertQueryResultSet(
      List<Map<String, dynamic>> queryResult) {
    Map<String, dynamic> resultMap = {};

    for (var map in queryResult) {
      resultMap.addAll(map);
    }

    return resultMap;
  }

  DateTime parseDate(String dateString) {
    return DateFormat.yMd().add_jm().parse(dateString);
  }

  Future<void> showOverlay(BuildContext context) async {
    Map<String, dynamic> userTransactionDetails =
        await databaseHelper.getUserTransactionDetails(id!);
    List<Map<String, dynamic>> transactions =
        userTransactionDetails['transactions'];
    NumberFormat myformat = NumberFormat.decimalPattern('en_us');

    double totalAmount = userTransactionDetails['totalAmount'];
    String total = myformat.format(totalAmount);

    setState(() {
      userTransaction = List.generate(transactions.length, (index) {
        return Transaction.fromMapObject(transactions[index]);
      });
    });
    final sortedTransactions = userTransaction
      ..sort((a, b) => parseDate(b.date!).compareTo(parseDate(a.date!)));

    overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Container(
              color: Colors.deepPurple.withOpacity(0.8),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                    itemCount: sortedTransactions.length,
                    itemBuilder: ((context, index) {
                      final trans = sortedTransactions[index];

                      Color color =
                          trans.type == 'deposit' ? Colors.green : Colors.red;
                      Icon icon = trans.type == 'deposit'
                          ? Icon(Icons.arrow_downward, color: color)
                          : Icon(Icons.arrow_upward, color: color);
                      double transAmount = trans.amount!;

                      String amount = myformat.format(transAmount);

                      String? remark = trans.remark;
                      remark ??= '';

                      return Card(
                        child: ListTile(
                          leading: icon,
                          title: Text(
                            '₦$amount',
                            style: TextStyle(color: color),
                          ),
                          subtitle: Text("${trans.date!}\n $remark"),
                          trailing: GestureDetector(
                            onTap: (() {}),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      );
                    })),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: Row(
                children: [
                  Text(
                    "Total: $total",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    iconSize: 30,
                    onPressed: () {
                      removeOverlay(overlayEntry!);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });

    Overlay.of(context).insert(overlayEntry!);
  }

  void removeOverlay(OverlayEntry? overlayEntry) {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }
}
