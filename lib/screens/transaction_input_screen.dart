import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calkuta/models/contributor.dart';
import 'package:calkuta/models/transactions.dart';
import 'package:calkuta/util/database_helper.dart';
import 'package:calkuta/util/my_color.dart';
import 'package:calkuta/util/progress.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionInputScreen extends StatefulWidget {
  final bool transactionStat;
  const TransactionInputScreen({super.key, required this.transactionStat});

  @override
  _TransactionInputScreenState createState() => _TransactionInputScreenState();
}

class _TransactionInputScreenState extends State<TransactionInputScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //String? selectedName;
  int? selectedContributorId;

  bool isDeposit = true;
  DateTime? selectedDate;
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  String? status;
  double amount = 0.0;
  String sign = '';
  //String remark = '';

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Contributor> contributors = [];
  late ProgressBar _sendingMsgProgressBar;

  int count = 0;

  @override
  void initState() {
    super.initState();
    isDeposit = widget.transactionStat;
    getContributorsFromDatabase();
    _sendingMsgProgressBar = ProgressBar();
  }

  @override
  void dispose() {
    amountController.dispose();
    _sendingMsgProgressBar.hide();
    super.dispose();
  }

  void showSendingProgressBar() {
    _sendingMsgProgressBar.show(context);
  }

  void hideSendingProgressBar() {
    _sendingMsgProgressBar.hide();
  }

  @override
  Widget build(BuildContext context) {
    status = isDeposit ? 'deposit' : 'withdraw';
    FocusScopeNode currentFocus = FocusScope.of(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: AppBar(
            iconTheme: const IconThemeData(color: MyColor.mytheme),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/moneytrans.jpg"),
                      fit: BoxFit.fill)),
            ),
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            centerTitle: true,
            title: const Text(
              "TRANSACTION",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: MyColor.mytheme,
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: () {
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: ListView(
              children: [
                const Text(
                  'Enter the following information:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                // GestureDetector(
                //   onTap: () => _selectDate(context),
                //   child: Container(
                //     padding: const EdgeInsets.all(12),
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.grey),
                //       borderRadius: BorderRadius.circular(4),
                //     ),
                //     child: Text(
                //       selectedDate != null
                //           ? selectedDate.toString()
                //           : 'Select a date',
                //     ),
                //   ),
                // ),

                // const SizedBox(height: 16),
                // const Text('Name'),
                // Autocomplete<String>(
                //   optionsBuilder: (TextEditingValue value) {
                //     if (value.text.isEmpty) {
                //       return [];
                //     }
                //     return prePopulatedNames
                //         .where((name) =>
                //             name.toLowerCase().contains(value.text.toLowerCase()))
                //         .toList();
                //   },
                //   onSelected: (String name) {
                //     setState(() {
                //       selectedName = name;
                //     });
                //   },
                //   fieldViewBuilder: (BuildContext context,
                //       TextEditingController textEditingController,
                //       FocusNode focusNode,
                //       VoidCallback onFieldSubmitted) {
                //     return TextField(
                //       controller: textEditingController,
                //       focusNode: focusNode,
                //       onChanged: (value) {
                //         // Add your own logic here if needed
                //       },
                //       decoration: const InputDecoration(
                //         border: OutlineInputBorder(),
                //         hintText: 'Enter a name',
                //       ),
                //     );
                //   },
                //   optionsViewBuilder: (BuildContext context,
                //       AutocompleteOnSelected<String> onSelected,
                //       Iterable<String> options) {
                //     return Align(
                //       alignment: Alignment.topLeft,
                //       child: Material(
                //         elevation: 4.0,
                //         child: Container(
                //           height: 200.0,
                //           child: ListView(
                //             padding: const EdgeInsets.all(8.0),
                //             children: options
                //                 .map((String option) => GestureDetector(
                //                       onTap: () {
                //                         onSelected(option);
                //                       },
                //                       child: ListTile(
                //                         title: Text(option),
                //                       ),
                //                     ))
                //                 .toList(),
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: selectedContributorId,
                  items: contributors.map((Contributor contributor) {
                    return DropdownMenuItem<int>(
                      value: contributor.id,
                      child: Text(contributor.name ?? ''),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select a Name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedContributorId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                    child: Text(
                  '$status',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Withdrawal'),
                    Switch(
                      activeColor: Colors.green,
                      inactiveTrackColor: Colors.red,
                      inactiveThumbColor: const Color(0xFF990000),
                      value: isDeposit,
                      onChanged: (value) {
                        setState(() {
                          isDeposit = value;
                          status = isDeposit ? 'deposit' : 'withdraw';
                        });
                      },
                    ),
                    const Text('Deposit'),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    '$amount',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter an amount',
                  ),
                  onChanged: (value) {
                    setState(() {
                      try {
                        if (isDeposit) {
                          var amt = amountController.text;
                          amount = double.parse(amt);
                        } else if (isDeposit == false) {
                          var amo = amountController.text;
                          //amo = '-$amo';
                          amount = -double.parse(amo);
                        }
                      } catch (e) {
                        amount = 0.0;
                      }
                    });
                  },
                  validator: (value) {
                    double val;
                    try {
                      val = double.parse(value!);
                      if (val < 1) {
                        return 'Please input an amount';
                      }
                      //return val.toString();
                    } catch (e) {
                      return 'Please input an amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: remarkController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Leave a remark',
                  ),
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      if (value.length > 20) {
                        return "Remark cannot exceed 20 characters";
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      backgroundColor: isDeposit ? Colors.green : Colors.red),
                  onPressed: () {
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if (_formKey.currentState!.validate()) {
                      // All form fields are valid, process the form data here
                      showSendingProgressBar();
                      _saveTransaction();
                      hideSendingProgressBar();
                    }
                  },
                  child: Text(
                    '$status',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      //lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _saveTransaction() async {
    int result;

    final newTransaction = Transactions(
        type: status,
        contributorId: selectedContributorId,
        amount: amount,
        date: DateFormat.yMd().add_jm().format(DateTime.now()),
        remark: remarkController.text);

    result = await databaseHelper.insertTransaction(newTransaction);

    if (result != 0) {
      _clearTransaction();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: 'Success!',
        desc: 'Transaction Successfully Saved',
        btnOkText: 'Ok',
        btnOkOnPress: () {
          Navigator.pushNamed(context, '/');
        },
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error!',
        desc: 'Transaction not Successfully',
        btnCancelText: 'Retry',
        btnCancelOnPress: () {
          _clearTransaction();
        },
      ).show();
    }
  }

  Future<List<Contributor>> getContributorsFromDatabase() async {
    // final db = await databaseHelper
    //     .initDatabase(); // Replace 'database' with your SQLite database instance
    final contributorMaps = await databaseHelper.getContributorMapList();

    setState(() {
      contributors = List.generate(contributorMaps.length, (index) {
        return Contributor.fromMapObject(contributorMaps[index]);
      });
    });

    return contributors;
  }

  void _clearTransaction() {
    setState(() {
      contributors = [];
      amountController.text = '';
    });
  }
}
//enum TransactionType { deposit, withdraw }