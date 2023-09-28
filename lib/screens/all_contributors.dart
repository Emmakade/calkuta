import 'dart:io';

import 'package:calkuta/models/contributor.dart';
import 'package:calkuta/screens/profile.dart';
import 'package:calkuta/util/database_helper.dart';
import 'package:calkuta/util/my_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class AllContributors extends StatefulWidget {
  AllContributors({Key? key}) : super(key: key);

  @override
  State<AllContributors> createState() => _AllContributorsState();
}

class _AllContributorsState extends State<AllContributors> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Contributor>? contributorList;
  List<Map<String, dynamic>> contribute = [];
  int count = 0;
  String? userBal;
  bool isImageNull = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (contributorList == null) {
      contributorList = <Contributor>[];
      checkListView();
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'All Contributor\'s List',
          style: TextStyle(color: MyColor.mytheme),
        ),
        backgroundColor: Colors.white,
        shadowColor: MyColor.mytheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: count,
          itemBuilder: (context, index) {
            final contrib = contributorList![index];

            double balance = contrib.balance ?? 0;
            NumberFormat myformat = NumberFormat.decimalPattern('en_us');
            String bal = myformat.format(balance);
            String? dp = contrib.imageDp;

            bool isImagePresent = dp == null ? false : true;

            return Card(
              elevation: 2.0,
              child: ListTile(
                leading: isImagePresent
                    ? CircleAvatar(
                        backgroundImage: FileImage(
                            File(contrib.imageDp.toString()),
                            scale: 1.0),
                        onBackgroundImageError: (exception, stackTrace) {
                          setState(() {
                            isImageNull = true;
                          });
                        },
                        radius: 20,
                      )
                    : const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/smart.jpg',
                        ),
                        radius: 20,
                      ),
                title: Text(contrib.name!.toString()),
                subtitle:
                    Text('Joined: ${contrib.dateJoined} \nNo: ${contrib.id}'),
                onTap: () {
                  //Navigator.pushNamed(context, '/profile');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(contributor: contrib)),
                  );
                },
                trailing: Text(
                  '₦$bal',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void checkListView() {
    final Future<Database> dbFuture = databaseHelper.initDatabase();
    dbFuture.then((datbase) {
      Future<List<Contributor>> contriListFuture =
          databaseHelper.getContributorList();
      // contribute =
      //     databaseHelper.getContributorMapList() as List<Map<String, dynamic>>;
      contriListFuture.then((value) {
        if (mounted) {
          setState(() {
            contributorList = value;
            count = value.length;
          });
        }
      });
    });
  }
}
