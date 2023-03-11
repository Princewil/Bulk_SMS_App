import 'package:cmda_bulk_sms/constants.dart';
import 'package:cmda_bulk_sms/funct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contacts',
          style: monserrat,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await showSheet(context, const AddNewContact(),
                    isDismissible: false);
                setState(() {});
              },
              icon: const Icon(Icons.add_ic_call_rounded))
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, i) => Slidable(
                key: ValueKey(contactsList[i]),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(onDismissed: () async {
                    await HiveClass().deleteContacts(i);
                    contactsList = await HiveClass().getContacts();
                    setState(() {});
                  }),
                  children: const [
                    SlidableAction(
                      onPressed: null,
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(onDismissed: () async {
                    await HiveClass().deleteContacts(i);
                    contactsList = await HiveClass().getContacts();
                    setState(() {});
                  }),
                  children: const [
                    SlidableAction(
                      flex: 2,
                      onPressed: null,
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_outline_rounded,
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(contactsList[i], style: monserrat),
                  leading: Text(
                    (i + 1).toString(),
                    style: monserrat,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ),
          separatorBuilder: (context, i) => const Divider(),
          itemCount: contactsList.length),
    );
  }
}

class AddNewContact extends StatefulWidget {
  const AddNewContact({super.key});

  @override
  State<AddNewContact> createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {
  final controller = RoundedLoadingButtonController();
  String numbs = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Add new contact(s)', style: monserrat),
          const SizedBox(height: 20),
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              labelText: 'Phone Numbers',
              labelStyle: monserrat.copyWith(color: primaryColor),
              hintText: '080123...,080433...',
              hintStyle: monserrat.copyWith(color: Colors.grey),
            ),
            onChanged: (v) => numbs = v,
            keyboardType: TextInputType.number,
            maxLines: 3,
            minLines: 1,
            style: monserrat,
            toolbarOptions: const ToolbarOptions(
                copy: true, paste: true, cut: true, selectAll: true),
          ),
          const SizedBox(height: 20),
          RoundedLoadingButton(
            controller: controller,
            color: primaryColor,
            animateOnTap: false,
            onPressed: () {
              final HiveClass hiveClass = HiveClass();
              if (numbs.isEmpty) {
                return;
              }
              controller.start();
              numbs = numbs.trim();
              if (numbs.contains(',')) {
                var list = numbs.split(',').toList();
                for (var num in list) {
                  if (checkNumb(num.trim())) {
                    contactsList.add(num.trim());
                    hiveClass.saveContact([num.trim()]);
                  }
                }
                Get.back();
                return;
              }
              if (checkNumb(numbs)) {
                contactsList.add(numbs);
                hiveClass.saveContact([numbs]);
              }
              Get.back();
            },
            child: Text(
              'Add',
              style: roboto,
            ),
          ),
          TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'cancel',
                style: monserrat.copyWith(color: Colors.grey),
              ))
        ],
      ),
    );
  }

  bool checkNumb(String numb) {
    int length = numb.length;
    bool isAlreadyThere = contactsList.contains(numb);
    if (!isAlreadyThere && (length == 11 || length == 14 || length == 15)) {
      return true;
    }
    return false;
  }
}

List<String> contactsList = [];
