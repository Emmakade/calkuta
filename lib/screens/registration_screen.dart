import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calkuta/models/contributor.dart';
import 'package:calkuta/util/custom_dialog.dart';
import 'package:calkuta/util/database_helper.dart';
import 'package:calkuta/util/my_color.dart';
import 'package:calkuta/util/progress.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class OverlayWidget extends StatefulWidget {
  final File? pickedImageFile;
  final OverlayEntry? overlayEntry;
  final Function(File)?
      onImagePicked; // Callback to notify parent widget about the picked image
  final void Function(String)? onImageSaved;
  const OverlayWidget(
      {Key? key,
      this.pickedImageFile,
      this.overlayEntry,
      this.onImagePicked,
      this.onImageSaved})
      : super(key: key);

  @override
  _OverlayWidgetState createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  final int maxFileSize = 2 * 1024 * 1024;

  File? _pickedImageFile;
  String? dpImg;

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                            color: MyColor.mytheme, width: 1.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 40)),
                    onPressed: _pickImage,
                    icon: const Icon(Icons.file_copy,
                        color: Color.fromARGB(255, 127, 98, 132), size: 20),
                    label: const Text(
                      'Pick Image',
                      style: TextStyle(
                          color: Color.fromARGB(255, 127, 98, 132),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _pickedImageFile != null
                      ? SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.file(
                            _pickedImageFile!,
                            fit: BoxFit.cover,
                          ))
                      : const Center(child: Text('No image selected')),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                            color: MyColor.mytheme, width: 1.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 55)),
                    onPressed: _saveImage,
                    child: const Text('Save Image',
                        style: TextStyle(
                            color: Color.fromARGB(255, 127, 98, 132),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              iconSize: 30,
              onPressed: removeOverlay,
            ),
          ),
        ],
      ),
    );
  }

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      allowCompression: true,
    );

    if (result != null && result.files.isNotEmpty) {
      File pickedFile = File(result.files.single.path!);

      // Check file size manually
      int fileSize = await pickedFile.length();
      if (fileSize <= maxFileSize) {
        widget.onImagePicked?.call(pickedFile);
        _updatePickedImage(pickedFile);
        // setState(() {
        //   _pickedImageFile = pickedFile;
        // });
      } else {
        showNotifi();
      }
    }
  }

  void _updatePickedImage(File imageFile) {
    setState(() {
      _pickedImageFile = imageFile;
    });
  }

  // void removeOverlay(OverlayEntry? overlayEntry) {
  //   if (overlayEntry != null) {
  //     overlayEntry.remove();
  //     setState(() {
  //       widget.overlayEntry = null;
  //     });
  //   }
  // }
  void removeOverlay() {
    widget.overlayEntry?.remove();
  }

  void showNotifi() {
    showPromptBox(context);
  }

  void _saveImage() async {
    if (_pickedImageFile != null) {
      String fileName = path.basename(_pickedImageFile!.path);
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String newPath = path.join(appDocPath, 'user_images', fileName);

      await Directory(path.dirname(newPath)).create(recursive: true);
      await _pickedImageFile!.copy(newPath);
      dpImg = newPath;
      widget.onImageSaved?.call(
          dpImg!); // Invoke the callback function with the saved image path
    }
    removeOverlay();
  }
}

class RegistrationScreen extends StatefulWidget {
  final Contributor contributor;
  final String appBarTitle;
  const RegistrationScreen(
      {super.key, required this.contributor, required this.appBarTitle});

  @override
  _RegistrationScreenState createState() =>
      _RegistrationScreenState(appBarTitle, contributor);
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  _RegistrationScreenState(this.appBarTitle, this.contributor);
  Contributor contributor;
  String appBarTitle;

  final _formKey = GlobalKey<FormState>();
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController acctNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> banks = [
    'Access Bank Plc',
    'Citibank Nigeria Limited',
    'Ecobank Nigeria Plc',
    'FairMoney',
    'Fidelity Bank Plc',
    'First Bank Nigeria Limited',
    'First City Monument Bank Plc',
    'Globus Bank Limited',
    'Guaranty Trust Bank Plc',
    'Heritage Banking Company Ltd',
    'Keystone Bank Limited',
    'Kuda',
    'MoniePoint',
    'Opay (Paycom)',
    'Optimus Bank Ltd',
    'Palmpay',
    'Parallex Bank Ltd',
    'Polaris Bank Plc',
    'Premium Trust Bank',
    'Providus Bank',
    'Stanbic IBTC Bank Plc',
    'Standard Chartered Bank Nigeria Ltd',
    'Sterling Bank Plc',
    'SunTrust Bank Nigeria Limited',
    'Titan Trust Bank Ltd',
    'Union Bank of Nigeria Plc',
    'United Bank For Africa Plc',
    'Unity Bank Plc',
    'Wema Bank Plc',
    'Zenith Bank Plc'
  ];
  String? selectedGender;
  String? selectedBank;
  String? heightSelection;
  String? dDate;
  String? dpImage;
  double? dBalance;

  //File? _pickedImageFile;
  final int maxFileSize = 2 * 1024 * 1024;

  OverlayEntry? overlayEntry;

  DatabaseHelper databaseHelper = DatabaseHelper();
  late ProgressBar _sendingMsgProgressBar;

  @override
  void initState() {
    super.initState();
    _sendingMsgProgressBar = ProgressBar();
    _loadAllInfo();
  }

  _loadAllInfo() {
    if (contributor.id != null) {
      nameController.text = contributor.name!;
      selectedGender = contributor.gender!;
      phoneController.text = contributor.phone!;
      emailController.text = contributor.email!;
      addressController.text = contributor.addr!;
      selectedBank = contributor.bankName ?? 'Guaranty Trust Bank Plc';
      acctNoController.text = contributor.bankAcctNo!;
      dpImage = contributor.imageDp ?? '';
      dDate = contributor.dateJoined ?? '';
      dBalance = contributor.balance ?? 0.0;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    acctNoController.dispose();
    addressController.dispose();
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
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: AppBar(
            iconTheme: const IconThemeData(color: MyColor.mytheme),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/register.jpg"),
                      fit: BoxFit.fill)),
            ),
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              widget.appBarTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: MyColor.mytheme,
              ),
            ),
          )),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contributor\'s Name',
                    suffixIcon: Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                if (contributor.id == null) showGender(),

                //const Text('Height'),
                // Row(
                //   children: [
                //     Radio<String>(
                //       value: 'Tall',
                //       groupValue: heightSelection,
                //       onChanged: (value) {
                //         setState(() {
                //           heightSelection = value;
                //         });
                //       },
                //     ),
                //     const Text('Tall'),
                //     const SizedBox(width: 16.0),
                //     Radio<String>(
                //       value: 'Short',
                //       groupValue: heightSelection,
                //       onChanged: (value) {
                //         setState(() {
                //           heightSelection = value;
                //           print('heightSelection: $heightSelection');
                //         });
                //       },
                //     ),
                //     const Text('Short'),
                //   ],
                // ),
                const SizedBox(height: 16.0),
                if (contributor.id != null) showPhone(),

                if (contributor.id != null) const SizedBox(height: 16.0),

                if (contributor.id != null) showEmail(),

                if (contributor.id != null) const SizedBox(height: 16.0),

                if (contributor.id != null) showAddress(),

                if (contributor.id != null) const SizedBox(height: 16.0),

                DropdownButtonFormField<String>(
                  dropdownColor: const Color(0xffccddee),
                  value: selectedBank,
                  items: banks.map((String bank) {
                    return DropdownMenuItem<String>(
                      value: bank,
                      child: Text(bank),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Banks',
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedBank = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a bank';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: acctNoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Account Number',
                    suffixIcon: Icon(
                      Icons.account_balance,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),

                if (contributor.id != null) upload(),

                const SizedBox(height: 32.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      backgroundColor: MyColor.mytheme),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showSendingProgressBar();
                      _saveUser();
                      hideSendingProgressBar();
                    }
                  },
                  child:
                      Text(contributor.id != null ? 'Update User' : 'Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget upload() {
    return GestureDetector(
      onTap: (() {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        // try {
        //   if (dpImage != null) {
        //     Directory(dpImage!).delete(recursive: true);
        //   }
        // } on Exception catch (e) {
        //   print(e);
        // }

        showOverlay(context);
      }),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          dpImage != '' ? dpImage.toString() : 'Upload a Picture',
          style: const TextStyle(color: Colors.black54, fontSize: 16),
        ),
      ),
    );
  }

  bool validateEmail(String email) {
    // Define the regular expression pattern for email validation
    const pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';

    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  Widget showGender() {
    return DropdownButtonFormField<String>(
      dropdownColor: const Color(0xffccddee),
      value: selectedGender,
      items: genders.map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Gender',
      ),
      onChanged: (value) {
        setState(() {
          selectedGender = value;

          //print('selectedGender: $selectedGender');
        });
      },
      validator: (val) {
        if (val == null) {
          return 'Please select a gender';
        }
        return null;
      },
    );
  }

  Widget showPhone() {
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Phone',
        suffixIcon: Icon(
          Icons.phone_enabled,
          color: Colors.grey,
          size: 24,
        ),
      ),
    );
  }

  Widget showEmail() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email',
        suffixIcon: Icon(
          Icons.email,
          color: Colors.grey,
          size: 24,
        ),
      ),
    );
  }

  Widget showAddress() {
    return TextFormField(
      controller: addressController,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: null,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: Icon(
          Icons.location_on,
          color: Colors.grey,
          size: 24,
        ),
        labelText: 'Address',
      ),
    );
  }

  void _saveUser() async {
    try {
      int result;
      final name = nameController.text;
      final phone = phoneController.text;
      final email = emailController.text;
      final gender = selectedGender;
      final addr = addressController.text;
      final bank = selectedBank;
      final acctNo = acctNoController.text;
      final imag = dpImage == 'Upload a Picture' ? '' : dpImage;

      if (contributor.id != null) {
        //if update
        final date = dDate;

        final newContrib = Contributor(
            id: contributor.id,
            name: name,
            gender: gender,
            phone: phone,
            email: email,
            addr: addr,
            bankName: bank,
            bankAcctNo: acctNo,
            dateJoined: date,
            imageDp: imag,
            balance: dBalance);
        result = await databaseHelper.updateContributor(newContrib);
      } else {
        //if registering
        final date = DateFormat.yMd().format(DateTime.now()).toString();
        contributor.dateJoined = date;
        final newContrib = Contributor(
            id: contributor.id,
            name: name,
            gender: gender,
            phone: phone,
            email: email,
            addr: addr,
            bankName: bank,
            bankAcctNo: acctNo,
            dateJoined: date,
            imageDp: imag,
            balance: 0.0);

        result = await databaseHelper.insertContributor(newContrib);
      }

      if (result != 0) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          title: 'Success!',
          desc: 'Successfully Saved',
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
          desc: 'not Successfully',
          btnCancelText: 'Retry',
          btnCancelOnPress: () {},
        ).show();
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> showOverlay(BuildContext context) async {
    //File? _pickedImageFile;
    final GlobalKey<_OverlayWidgetState> overlayKey =
        GlobalKey<_OverlayWidgetState>();

    // if (dpImage != null || dpImage != '') {
    //   Directory(dpImage!).delete(recursive: true);
    // }

    overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return OverlayWidget(
        key: overlayKey,
        overlayEntry: overlayEntry,
        onImageSaved: (String imagePath) {
          dpImage = imagePath;
          setState(() {});
        },
      );
    });

    Overlay.of(context).insert(overlayEntry!);
  }
}
