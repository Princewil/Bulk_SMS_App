import 'package:cmda_bulk_sms/contact.dart';
import 'package:cmda_bulk_sms/home/home.dart';
import 'package:cmda_bulk_sms/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../constants.dart';
import '../funct.dart';

class AddNewMessage extends StatelessWidget {
  const AddNewMessage({super.key});

  @override
  Widget build(BuildContext context) {
    const r = BorderRadius.all(
      Radius.circular(10),
    );
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () async {
          await showSheet(context, const SendMessage(), isDismissible: false);
        },
        radius: 10,
        borderRadius: r,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: r,
          ),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.messenger,
                  color: primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'New message',
                  style: monserrat.copyWith(color: primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SendMessage extends StatelessWidget {
  const SendMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = RoundedLoadingButtonController();
    String mssg = '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Send a new message', style: monserrat),
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
              labelText: 'Message',
              labelStyle: monserrat.copyWith(color: primaryColor),
              hintText: '...',
              hintStyle: monserrat.copyWith(color: Colors.grey),
            ),
            onChanged: (v) => mssg = v,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
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
            onPressed: () async {
              try {
                if (mssg.isEmpty ||
                    bulkSMSKey.isEmpty ||
                    contactsList.isEmpty) {
                  Get.showSnackbar(const GetSnackBar(
                    title: 'You are missing something.',
                    message:
                        "it's either BulkSMSKey is empty or your contact list is empty or you have'nt inputted any message.",
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 5),
                  ));
                  return;
                }
                controller.start();
                final res = await SMSClass().sendSMS(contactsList, mssg);
                print(res.body);
                controller.reset();
                final date = DateTime.now().toString();
                final data = MessageHistory(
                  textMessage: mssg,
                  date: date.toString(),
                );
                await HiveClass().saveMssgHistory(data);
                var _ = await HiveClass().getMessageHistory();
                kMssg?.change(_);
                Get.showSnackbar(GetSnackBar(
                  title: 'Message sent successfully',
                  message: 'Total recepients: ${contactsList.length}',
                  duration: const Duration(seconds: 3),
                  backgroundColor: primaryColor,
                ));
                await Future.delayed(const Duration(seconds: 5));
                Get.back();
              } catch (e) {
                controller.reset();
                Get.showSnackbar(GetSnackBar(
                  title: 'An error occured!',
                  message: e.toString(),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ));
              }
              Get.back();
            },
            child: Text(
              'Send',
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

class UpdateMssgHistory extends GetxController {
  List<MessageHistory> mssgHistory = [];
  change(List<MessageHistory> list) {
    mssgHistory = list;
    update();
  }
}

UpdateMssgHistory? kMssg;
