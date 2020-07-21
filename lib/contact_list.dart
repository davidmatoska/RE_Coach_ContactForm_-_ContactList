import 'package:CWCFlutter/db/database_provider.dart';
import 'package:CWCFlutter/events/delete_contact.dart';
import 'package:CWCFlutter/events/set_contacts.dart';
import 'package:CWCFlutter/contact_form.dart';
import 'package:CWCFlutter/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/contact_bloc.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key key}) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getContacts().then(
      (contactList) {
        BlocProvider.of<ContactBloc>(context).add(SetContacts(contactList));
      },
    );
  }

  showContactDialog(BuildContext context, Contact contact, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('trouver quoi dire'),
        content: Text("ID ${contact.id}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ContactForm(contact: contact, contactIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(contact.id).then((_) {
              BlocProvider.of<ContactBloc>(context).add(
                DeleteContact(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire contact list scaffold");
    return Scaffold(
      appBar: AppBar(title: Text("Contacts List")),
      body: Container(
        child: BlocConsumer<ContactBloc, List<Contact>>(
          builder: (context, contactList) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                print("contactList: $contactList");

                Contact contact = contactList[index];
                return ListTile(
                    title: Text('trouver 2', style: TextStyle(fontSize: 30)),
                    subtitle: Text(
                      "Amount: ${contact.amount}\n",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () => showContactDialog(context, contact, index));
              },
              itemCount: contactList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black),
            );
          },
          listener: (BuildContext context, contactList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => ContactForm()),
        ),
      ),
    );
  }
}
