import 'package:cmda_bulk_sms/constants.dart';
import 'package:cmda_bulk_sms/contact.dart';
import 'package:cmda_bulk_sms/funct.dart';
import 'package:cmda_bulk_sms/settings.dart';
import 'package:cmda_bulk_sms/home/message_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinterest_nav_bar/pinterest_nav_bar.dart';

import 'send_message.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    contactsList = await HiveClass().getContacts();
    bulkSMSKey = await HiveClass().getBulkSMSKey();
    final _ = await HiveClass().getMessageHistory();
    kMssg?.change(_);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[pageIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: PinterestNavBar(
          items: const [
            Icons.home_filled,
            Icons.contacts_rounded,
            Icons.settings,
          ],
          unselectedItemColor: Colors.grey,
          selectedItemColor: primaryColor,
          currentIndex: pageIndex,
          onTap: (i) {
            pageIndex = i;
            setState(() {});
          }),
    );
  }
}

List<Widget> _pages = [
  const MessagesHistory(),
  const Contacts(),
  const Settings()
];
int pageIndex = 0;

class MessagesHistory extends StatefulWidget {
  const MessagesHistory({super.key});

  @override
  State<MessagesHistory> createState() => _MessagesHistoryState();
}

class _MessagesHistoryState extends State<MessagesHistory> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 2), () {
    //   setState(() {});
    // });
    kMssg = updateMssgHistory;
  }

  final UpdateMssgHistory updateMssgHistory = Get.put(UpdateMssgHistory());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateMssgHistory>(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(
                  'CMDA BulkSMS',
                  style: monserrat,
                ),
              ),
              body: updateMssgHistory.mssgHistory.isEmpty
                  ? const AddNewMessage()
                  : ListView.builder(
                      itemCount: updateMssgHistory.mssgHistory.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Column(
                          children: [
                            if (i == 0) const AddNewMessage(),
                            MessageHistoryView(
                              messageHistory: updateMssgHistory.mssgHistory[i],
                            ),
                          ],
                        );
                      },
                    ),
            ));
  }
}

class MessageHistory {
  static const textKey = 'Text';
  static const dataKey = 'Date';
  String? textMessage;
  String? date;
  MessageHistory({
    this.textMessage,
    this.date,
  });
  Map toMap(MessageHistory data) {
    Map<String, dynamic> map = {};
    map[textKey] = data.textMessage;
    map[dataKey] = data.date;
    return map;
  }

  MessageHistory.toClass(Map map) {
    textMessage = map[textKey];
    date = map[dataKey];
  }
}
