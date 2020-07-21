import 'package:CWCFlutter/bloc/contact_bloc.dart';
import 'package:CWCFlutter/db/database_provider.dart';
import 'package:CWCFlutter/events/add_contact.dart';
import 'package:CWCFlutter/events/update_contact.dart';
import 'package:CWCFlutter/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Packages for datetime input
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ContactForm extends StatefulWidget {
  final Contact contact;
  final int contactIndex;

  ContactForm({this.contact, this.contactIndex});

  @override
  State<StatefulWidget> createState() {
    return ContactFormState();
  }
}

class ContactFormState extends State<ContactForm> {
  DateTime _date;
  String _amount;
  final format = DateFormat("yyyy-MM-dd");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildDate() {
    return  DateTimeField(
      format: format,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
      },
    );
   /* return TextFormField(
      initialValue: _date,
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 15,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _date = value;
      },
    );*/
  }

  Widget _buildAmount() {
    return TextFormField(
      initialValue: _amount,
      decoration: InputDecoration(labelText: 'Amount'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        int amount = int.tryParse(value);

        if (amount == null || amount <= 0) {
          return 'Contacts must be greater than 0';
        }

        return null;
      },
      onSaved: (String value) {
        _amount = value;
      },
    );
  }



  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _date = widget.contact.date;
      _amount = widget.contact.amount;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Form")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildDate(),
              _buildAmount(),
              SizedBox(height: 16),

              widget.contact == null
                  ? RaisedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        _formKey.currentState.save();

                        Contact contact = Contact(
                          date: _date,
                          amount: _amount,

                        );

                        DatabaseProvider.db.insert(contact).then(
                              (storedFood) => BlocProvider.of<ContactBloc>(context).add(
                                AddContact(storedFood),
                              ),
                            );

                        Navigator.pop(context);
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Update",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              print("form");
                              return;
                            }

                            _formKey.currentState.save();

                            Contact contact = Contact(
                              date: _date,
                              amount: _amount,

                            );

                            DatabaseProvider.db.update(widget.contact).then(
                                  (storedContact) => BlocProvider.of<ContactBloc>(context).add(
                                    UpdateContact(widget.contactIndex, contact),
                                  ),
                                );

                            Navigator.pop(context);
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
