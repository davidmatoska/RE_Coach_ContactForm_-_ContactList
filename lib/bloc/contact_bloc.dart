import 'package:CWCFlutter/events/add_contact.dart';
import 'package:CWCFlutter/events/delete_contact.dart';
import 'package:CWCFlutter/events/contact_event.dart';
import 'package:CWCFlutter/events/set_contacts.dart';
import 'package:CWCFlutter/events/update_contact.dart';
import 'package:CWCFlutter/model/contact.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactBloc extends Bloc<ContactEvent, List<Contact>> {
  @override
  List<Contact> get initialState => List<Contact>();

  @override
  Stream<List<Contact>> mapEventToState(ContactEvent event) async* {
    if (event is SetContacts) {
      yield event.contactList;
    } else if (event is AddContact) {
      List<Contact> newState = List.from(state);
      if (event.newContact != null) {
        newState.add(event.newContact);
      }
      yield newState;
    } else if (event is DeleteContact) {
      List<Contact> newState = List.from(state);
      newState.removeAt(event.contactIndex);
      yield newState;
    } else if (event is UpdateContact) {
      List<Contact> newState = List.from(state);
      newState[event.contactIndex] = event.newContact;
      yield newState;
    }
  }
}
