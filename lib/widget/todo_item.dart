import 'dart:math';
import 'package:flutter/material.dart';
import '../model/todo_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class To_do_item extends StatelessWidget {
  final todo todo_item;
  final handle_item;
  final delete_item;
  final edit_item;
  final bool isLightMode;

  const To_do_item({
    Key? key,
    required this.todo_item,
    required this.handle_item,
    required this.delete_item,
    required this.edit_item,
    required this.isLightMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          handle_item(todo_item, todo_item.id);
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        tileColor: isLightMode ? Color(0xFFEEEFF5) : Colors.grey,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              todo_item.is_done
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: isLightMode ? Color(0xFF5F52EE) : Colors.white,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(todo_item.id!),
            Text(
              todo_item.text_todo!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isLightMode ? Color(0xFF5F52EE) : Colors.amber,
                decoration:
                    todo_item.is_done ? TextDecoration.lineThrough : null,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                formatDate(todo_item.date_time!),
                style:
                    TextStyle(color: isLightMode ? Colors.black : Colors.white),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      edit_item(todo_item.id);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.warning,
                                        color: Colors.red,
                                      )),
                                  Text(AppLocalizations.of(context)!
                                      .areyousuretodelete),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context)!
                                      .comfirmdelete),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    delete_item(
                                        todo_item.id); // Close the dialog
                                  },
                                  child: Text('OK'),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel')),
                              ],
                            );
                          });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    String amPm = dateTime.hour < 12 ? 'AM' : 'PM';
    int hour = dateTime.hour % 12;
    hour = hour == 0 ? 12 : hour; // Convert 0 to 12 for 12-hour format
    String formattedTime =
        '${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $amPm';
    return '$formattedTime, ${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }
}
