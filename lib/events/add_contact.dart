import 'package:CWCFlutter/model/contact.dart';

import 'contact_event.dart';

class AddContact extends ContactEvent {
  Contact newContact;

  AddContact(Contact contact) {
    newContact = contact;
  }
}
