class Contributor {
  int? id;
  String? name;
  String? gender;
  String? phone;
  String? email;
  String? addr;
  String? bankName;
  String? bankAcctNo;
  String? dateJoined;
  String? imageDp;
  double? balance;

  Contributor(
      {this.id,
      this.name,
      this.gender,
      this.phone,
      this.email,
      this.addr,
      this.bankName,
      this.bankAcctNo,
      this.imageDp,
      this.dateJoined,
      this.balance});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['gender'] = gender;
    map['phone'] = phone;
    map['email'] = email;
    map['addr'] = addr;
    map['bankName'] = bankName;
    map['bankAcctNo'] = bankAcctNo;
    map['dateJoined'] = dateJoined;
    map['imageDp'] = imageDp;
    map['balance'] = balance;

    return map;
  }

  Contributor.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    gender = map['gender'];
    phone = map['phone'];
    email = map['email'];
    addr = map['addr'];
    bankName = map['bankName'];
    bankAcctNo = map['bankAcctNo'];
    dateJoined = map['dateJoined'];
    imageDp = map['imageDp'];
    balance = map['balance'];
  }
}
