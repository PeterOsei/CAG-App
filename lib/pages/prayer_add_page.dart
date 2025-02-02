// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cag_app/models/user.dart';

class AddPrayerRequestPage extends StatefulWidget {
  @override
  State<AddPrayerRequestPage> createState() {
    return _AddPrayerRequestState();
  }
}

class _AddPrayerRequestState extends State<AddPrayerRequestPage> {
  final _prayerRequestKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String _title, _description;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Prayer Request"),
      ),
      body: Form(
        key: _prayerRequestKey,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                  maxLength: 35,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Please enter a title for your prayer request';
                    _title = value.toString();
                  }),
              TextFormField(
                  maxLines: 6,
                  maxLength: 240,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Please enter a title for your prayer request';
                    _description = value.toString();
                  }),
              Container(
                margin: EdgeInsets.all(8.0),
                child: ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                    return IconButton(
                      icon: Icon(Icons.check),
                      iconSize: 50.0,
                      onPressed: () {
                        if (_prayerRequestKey.currentState.validate()) {
                          Firestore.instance
                              .collection('app/prayer-requests/active')
                              .document()
                              .setData({
                            'title': _title,
                            'description': _description,
                            'date': DateTime.now(),
                            'userId': model.uid,
                            'answered': false,
                          }).then((error) {
                            Navigator.pop(context);
                          });
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
