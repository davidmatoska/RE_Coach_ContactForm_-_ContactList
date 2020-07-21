import 'contact_event.dart';

class DeleteContact extends ContactEvent {
  int contactIndex;

  DeleteContact(int index) {
    contactIndex = index;
  }
}
