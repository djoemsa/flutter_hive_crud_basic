import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/contact.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Contact> contactBox;

  @override
  void initState() {
    super.initState();
    // store the box
    contactBox = Hive.box('my_contacts');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HIVE CRUD BASIC'),
      ),
      body: ValueListenableBuilder(
          valueListenable: contactBox.listenable(),
          builder: (context, Box<Contact> box, _) {
            // cast<T>() to tell that every list item is Contact
            List<Contact> contacts = box.values.toList().cast<Contact>();
            return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = contacts[index];
                  return ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: Icon(Icons.person),
                    title: Text(contact.name),
                    subtitle: Text(contact.phone),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.list_alt),
                          onPressed: () {
                            _showModalBottomSheet(
                              context: context,
                              contactsBox: contactBox,
                              contact: contact,
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            box.delete(contact.id);
                          },
                        )
                      ],
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showModalBottomSheet(
          context: context,
          contactsBox: contactBox,
        ),
      ),
    );
  }

  void _showModalBottomSheet({
    required BuildContext context,
    required Box contactsBox,
    Contact? contact,
  }) {
    Random random = Random();
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    if (contact != null) {
      nameController.text = contact.name;
      phoneController.text = contact.phone;
    }

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (contact != null) {
                      contactsBox.put(
                          contact.id,
                          contact.copyWith(
                            name: nameController.text,
                            phone: phoneController.text,
                          ));
                    } else {
                      Contact contact = Contact(
                        id: random.nextInt(1000).toString(),
                        name: nameController.text,
                        phone: phoneController.text,
                      );

                      contactBox.put(contact.id, contact);
                      // add gives auto key
                      // contactBox.add(contact);
                    }

                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                )
              ],
            ),
          );
        });
  }
}
