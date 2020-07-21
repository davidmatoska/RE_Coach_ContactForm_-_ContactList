import 'package:CWCFlutter/model/contact.dart';

import 'contact_event.dart';

class SetContacts extends ContactEvent {
  List<Contact> contactList;

  SetContacts(List<Contact> contacts) {
    contactList = contacts;
  }
}
