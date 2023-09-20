import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService{
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null, 
      [
        NotificationChannel(
          channelKey: 'todo_channel',
          channelName: 'To do upcoming!!!',
          defaultColor: Colors.teal,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
        )
      ]
    );
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed)async{
      if(!isAllowed){
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }
}