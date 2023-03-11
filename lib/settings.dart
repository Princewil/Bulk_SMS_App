import 'package:cmda_bulk_sms/constants.dart';
import 'package:cmda_bulk_sms/contact.dart';
import 'package:cmda_bulk_sms/funct.dart';
import 'package:cmda_bulk_sms/home/send_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'home/home.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: monserrat,
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'BulkSMS Key',
              style: monserrat,
            ),
            subtitle: Text(
              bulkSMSKey.isEmpty ? 'Please add your key' : bulkSMSKey,
              style: monserrat.copyWith(
                fontStyle:
                    bulkSMSKey.isEmpty ? FontStyle.italic : FontStyle.normal,
              ),
            ),
            onTap: () async {
              await showSheet(context, const AddBulkSMSKey(),
                  isDismissible: false);
              setState(() {});
            },
            trailing: const Icon(
              Icons.edit_rounded,
              color: primaryColor,
              size: 20,
            ),
          ),
          ListTile(
            title: Text('Clear contacts', style: monserrat),
            subtitle: Text(
              'Clears all saved contacts',
              style: monserrat,
            ),
            onTap: () => showPopUp(context, true),
          ),
          ListTile(
            title: Text('Clear messages history', style: monserrat),
            subtitle: Text(
              'Clears all past messages',
              style: monserrat,
            ),
            onTap: () => showPopUp(context, false),
          ),
        ],
      ),
    );
  }
}

String bulkSMSKey = '';

class AddBulkSMSKey extends StatefulWidget {
  const AddBulkSMSKey({super.key});

  @override
  State<AddBulkSMSKey> createState() => _AddBulkSMSKeyState();
}

class _AddBulkSMSKeyState extends State<AddBulkSMSKey> {
  final controller = RoundedLoadingButtonController();
  String bulkSMSKEY = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Add Key', style: monserrat),
          const SizedBox(height: 20),
          TextFormField(
            autofocus: true,
            initialValue: bulkSMSKey,
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
              labelText: 'Key',
              labelStyle: monserrat.copyWith(color: primaryColor),
              hintText: 'paste your key',
              hintStyle: monserrat.copyWith(color: Colors.grey),
            ),
            onChanged: (v) => bulkSMSKEY = v,
            keyboardType: TextInputType.number,
            maxLines: 1,
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
              if (bulkSMSKEY.isEmpty) {
                return;
              }
              controller.start();
              HiveClass().saveBulkSMSKey(bulkSMSKEY);
              bulkSMSKey = bulkSMSKEY;
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
}

Future showPopUp(BuildContext context, bool deleteContacts) async => showDialog(
    context: context,
    builder: (context) => AlertDialog(
          title: Text(
            'Are you sure you want to perform this action?',
            style: monserrat,
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'No',
                style: monserrat.copyWith(color: primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                if (deleteContacts) {
                  HiveClass().deleteAllContacts();
                  contactsList = [];
                  Get.back();
                  return;
                }
                HiveClass().deleteAllMssgHistory();
                kMssg?.change([]);
                Get.back();
                return;
              },
              child: Text(
                'Yes',
                style: monserrat.copyWith(color: primaryColor),
              ),
            ),
          ],
        ));
