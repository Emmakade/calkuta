class Transactions {
  String? type;
  int? contributorId;
  double? amount;
  String? date;
  String? remark;
  Transactions(
      {this.type, this.contributorId, this.amount, this.date, this.remark});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['type'] = type;
    map['contributorId'] = contributorId;
    map['amount'] = amount;
    map['date'] = date;
    map['remark'] = remark;

    return map;
  }

  Transactions.fromMapObject(Map<String, dynamic> map) {
    type = map['type'];
    contributorId = map['contributorId'];
    amount = map['amount'];
    date = map['date'];
    remark = map['remark'];
  }
}

enum TransactionType { deposit, withdraw }
