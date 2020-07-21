import 'package:CWCFlutter/db/database_provider.dart';

class Contact {
  int id;
  DateTime date;
  String amount;


  Contact({this.id, this.date, this.amount});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_DATE: date,
      DatabaseProvider.COLUMN_AMOUNT: amount,

    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Contact.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    date = map[DatabaseProvider.COLUMN_DATE];
    amount = map[DatabaseProvider.COLUMN_AMOUNT];

  }
}
