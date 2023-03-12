import 'package:cmda_bulk_sms/home/home.dart';
import 'package:cmda_bulk_sms/settings.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class SMSClass {
  static const smsURL = 'https://www.bulksmsnigeria.com/api/v1/sms/create';
  Future<http.Response> sendSMS(List<String> phonNum, String message) async {
    String phonNumbers = phonNum.join(',');
    Uri send = Uri.parse(
        '$smsURL?api_token=$bulkSMSKey&from=CMDA-ESUTH&to=$phonNumbers&body=$message&dnd=2');
    var response = await http.post(send);
    return response;
  }
}

class HiveClass {
  static const contactBox = 'MyContacts';
  static const bulkSMSKey = 'MyBulkSMSKey';
  static const messagesHistory = 'MessagesHistory';
  Future<Box> openBox(String boxName) async => Hive.openBox(boxName);
  Future<void> saveContact(List list) async {
    final box = await openBox(contactBox);
    await box.addAll(list);
  }

  Future<List<String>> getContacts() async {
    final box = await openBox(contactBox);
    if (box.values.isEmpty) {
      return [];
    }
    return box.values.map((e) => e.toString()).toList();
  }

  Future deleteContacts(int i) async {
    final box = await openBox(contactBox);
    return box.deleteAt(i);
  }

  Future deleteAllContacts() async {
    final box = await openBox(contactBox);
    final keys = box.keys;
    for (var e in keys) {
      await box.delete(e);
    }
  }

  Future saveBulkSMSKey(String key) async {
    final box = await openBox(bulkSMSKey);
    return await box.put(bulkSMSKey, key);
  }

  Future<String> getBulkSMSKey() async {
    final box = await openBox(bulkSMSKey);
    var _ = await box.get(bulkSMSKey);
    return _ == null ? '' : _.toString();
  }

  Future saveMssgHistory(MessageHistory messageHistory) async {
    final box = await openBox(messagesHistory);
    await box.add(messageHistory.toMap(messageHistory));
  }

  Future<List<MessageHistory>> getMessageHistory() async {
    final box = await openBox(messagesHistory);
    var list = box.values.map((e) => MessageHistory.toClass(e)).toList();
    return list;
  }

  Future deleteAllMssgHistory() async {
    final box = await openBox(messagesHistory);
    final keys = box.keys;
    for (var e in keys) {
      await box.delete(e);
    }
  }
}
