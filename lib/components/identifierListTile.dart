// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../API/ApiFunctions.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class IdentifierListTile extends StatefulWidget {
  var index;

  // ignore: use_key_in_widget_constructors
  IdentifierListTile(this.index);

  @override
  State<IdentifierListTile> createState() => _IdentifierListTileState();
}

class _IdentifierListTileState extends State<IdentifierListTile> {
  // ignore: prefer_final_fields
  TextEditingController _token = TextEditingController();

  @override
  Widget build(BuildContext context) {
    try {
      if (constantIdentifiers[widget.index]["state"] == "DISABLED") {
        return Container(
          //margin: const EdgeInsets.all(2),
          alignment: Alignment.centerLeft,
          //color: const Color(0xFFB4B4CB),
          child: GestureDetector(
            onTap: () async {
              await confirmIdentifierDialogPopUp(
                  constantIdentifiers[widget.index]['identifier'],
                  constantIdentifiers[widget.index]["identifier_type"],
                  context,
                  _token);
            },
            child: ListTile(
              title: Text(
                constantIdentifiers[widget.index]['identifier'],
                style: const TextStyle(fontSize: 16),
              ),
              trailing: GestureDetector(
                child: const Icon(Icons.delete_forever),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      actionsPadding: const EdgeInsets.all(10),
                      title:  Text(
                        "Delete " + constantIdentifiers[widget.index]['identifier']+" ?",
                        style: const TextStyle(fontSize: 16),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              //borderRadius: BorderRadius.circular(20),
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                // ignore: prefer_const_constructors
                                //padding: EdgeInsets.all(5),
                                color: kPrimary,
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'No',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            ClipRRect(
                              //borderRadius: BorderRadius.circular(20),
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                // ignore: prefer_const_constructors
                                //padding: EdgeInsets.all(5),
                                color: kPrimary,
                                onPressed: () async {

                                  await deleteIdentifier(
                                      constantIdentifiers[widget.index]["identifier_type"],
                                      constantIdentifiers[widget.index]['identifier'],context);
                                  await getIdentifierAndTypes();
                                  setState(() {});
                                  Navigator.of(context).pushReplacementNamed("/identifiers");
                                },
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                      elevation: 20,
                    ),
                  );

                },
              ),
            ),
          ),
        );
      }
      return Container(
        margin: const EdgeInsets.all(2),
        //color: const Color.fromARGB(255, 134, 155, 229),
        child: ListTile(
          enabled: true,
          title: Text(
            constantIdentifiers[widget.index]['identifier'],
            style: const TextStyle(fontSize: 16),
          ),
          trailing: GestureDetector(
            child: const Icon(Icons.delete_forever),
            onTap: () async {
              await deleteIdentifier(
                  constantIdentifiers[widget.index]["identifier_type"],
                  constantIdentifiers[widget.index]['identifier'],context);
              await getIdentifierAndTypes();
              setState(() {});
              Navigator.of(context).pushReplacementNamed("/identifiers");
            },
          ),
          onTap: () async {
            await confirmIdentifierDialogPopUp(
                constantIdentifiers[widget.index]['identifier'],
                constantIdentifiers[widget.index]["identifier_type"],
                context,
                _token);
          },
        ),
      );
    } catch (exception) {
      return Container(
        margin: const EdgeInsets.all(2),
        //color: const Color.fromARGB(255, 75, 181, 67),
        child: const ListTile(
          enabled: true,
          title: Text(
            "Add an identifier to view it",
            style: TextStyle(fontSize: 14),
          ),
        ),
      );
    }
  }

  Future confirmIdentifierDialogPopUp(
          var identifier, var identifierType, context, token) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            identifier,
            style: const TextStyle(fontSize: 16),
          ),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: const BoxDecoration(color: kPrimaryLightColor),
            child: TextField(
              controller: token,
              decoration: const InputDecoration(
                hintText: 'Token',
                border: InputBorder.none,
              ),
            ),
          ),
          actions: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              // ignore: deprecated_member_use
              child: FlatButton(
                // ignore: prefer_const_constructors
                padding: EdgeInsets.all(10),
                color: kPrimary,
                onPressed: () async {
                  await confirmIdentifier(
                      context, identifier, identifierType, token.text);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'confirm',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
          elevation: 20,
        ),
      );

}
