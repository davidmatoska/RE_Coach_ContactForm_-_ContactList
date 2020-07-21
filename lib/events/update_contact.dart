import 'package:CWCFlutter/model/contact.dart';

import 'contact_event.dart';

class UpdateContact extends ContactEvent {
  Contact newContact;
  int contactIndex;

  UpdateContact(int index, Contact contact) {
    newContact = contact;
    contactIndex = index;
  }
}
