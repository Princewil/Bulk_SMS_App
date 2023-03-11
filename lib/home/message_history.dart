import 'package:cmda_bulk_sms/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'home.dart';

class MessageHistoryView extends StatelessWidget {
  final MessageHistory messageHistory;
  const MessageHistoryView({super.key, required this.messageHistory});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: ListTile(
        title: ReadMoreText(
          messageHistory.textMessage!,
          lessStyle: monserrat.copyWith(color: primaryColor),
          moreStyle: monserrat.copyWith(color: primaryColor),
          trimLength: 150,
          style: monserrat,
        ),
        subtitle: Text(
          DateFormat.yMMMMEEEEd().format(DateTime.parse(messageHistory.date!)),
          style: Theme.of(context).textTheme.caption!.merge(monserrat),
        ),
      ),
    );
  }
}
