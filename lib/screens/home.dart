import 'dart:convert';
import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:test1/language/language.dart';
import '../main.dart';
import '../model/todo_list.dart';
import 'package:test1/widget/todo_item.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todo_list = todo.todo_list();
  TextEditingController text_controler = TextEditingController();
  List<todo> found_todo = [];
  DateTime? selected_datetime;
  bool isLightMode = true;

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == 'todo_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then((value) {
          if (value > 0) {
            AwesomeNotifications().setGlobalBadgeCounter(value - 1);
          }
        });
      }
    });

    AwesomeNotifications().dismissedStream.listen((notification) {
      if (notification.channelKey == 'todo_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then((value) {
          if (value > 0) {
            AwesomeNotifications().setGlobalBadgeCounter(value - 1);
          }
        });
      }
    });

    AwesomeNotifications().displayedStream.listen((notification) {
      if (notification.channelKey == 'todo_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then((value) {
          if (value > 0) {
            AwesomeNotifications().setGlobalBadgeCounter(value - 1);
          }
        });
      }
    });
    load_todo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFEEEFF5),
      appBar: build_appbar(),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 60),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                search_box(),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 25, left: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.alltodo,
                        //'All todo ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          //color: Colors.black,
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        label: Text(
                          AppLocalizations.of(context)!.deleteall,
                          style: TextStyle(fontSize: 15),
                        ),
                        icon: Icon(Icons.delete_sweep_rounded),
                        onPressed: () {
                          if (todo_list.isNotEmpty || found_todo.isNotEmpty) {
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
                                          .areyousuretodeleteall),
                                    ],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .comfirmdeleteall,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        delete_all(); // Close the dialog
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
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      check_toto(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15, bottom: 30),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: isLightMode ? Color(0xFFEEEFF5) : Colors.grey,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10.0,
                          //color: Colors.grey,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: text_controler,
                      decoration: InputDecoration(
                        hintText: (AppLocalizations.of(context)!.addtodo),
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: isLightMode ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 15, bottom: 30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF5F52EE),
                      minimumSize: Size(45, 55),
                      elevation: 10,
                    ),
                    onPressed: () {
                      date_time_picker();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  //alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(bottom: 30, right: 15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // primary: Color(0xFF5F52EE),
                      backgroundColor: Colors.green,
                      minimumSize: Size(45, 55),
                      elevation: 10,
                    ),
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 35,
                      ),
                    ),
                    onPressed: () {
                      if (text_controler.text.isNotEmpty &&
                          selected_datetime != null) {
                        add_todo();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.warning,
                                        color: Colors.red,
                                      )),
                                  Text(AppLocalizations.of(context)!
                                      .emptydatetime),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context)!
                                      .warningemptydatetime),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void save_todo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoJsonList =
        todo_list.map((todoItem) => json.encode(todoItem.toJson())).toList();
    await prefs.setStringList('todo_list', todoJsonList);
    //print(todoJsonList);
  }

  Future<void> load_todo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todoJsonList = prefs.getStringList('todo_list');
    if (todoJsonList != null) {
      List<todo> loadedTodoList = todoJsonList
          .map((jsonString) => todo.fromJson(json.decode(jsonString)))
          .toList();
      setState(() {
        todo_list.clear();
        todo_list.addAll(loadedTodoList);
        found_todo = todo_list;
      });
    }
  }

  String formatDate(DateTime dateTime) {
    String amPm = dateTime.hour < 12 ? 'AM' : 'PM';
    int hour = dateTime.hour % 12;
    hour = hour == 0 ? 12 : hour; // Convert 0 to 12 for 12-hour format
    String formattedTime =
        '${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $amPm';
    return '$formattedTime, ${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  void set_schedule(int todoId, DateTime schedule_time, String todoContent) {
    final format = formatDate(schedule_time);
    final now = DateTime.now();
    final remaining_time = schedule_time.difference(now);

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: todoId,
        channelKey: 'todo_channel',
        title: AppLocalizations.of(context)!.titlenotifications,
        body:
            '${AppLocalizations.of(context)!.contentnotifications}$todoContent \n${AppLocalizations.of(context)!.datetimenotifications} $format',
      ),
      schedule: NotificationCalendar.fromDate(
        date: schedule_time,
        allowWhileIdle: true,
      ),
    );

    if (remaining_time.inMinutes >= 1) {
      DateTime remind_before_minute =
          schedule_time.subtract(Duration(minutes: 5));

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: todoId + 1,
          channelKey: 'todo_channel',
          title: AppLocalizations.of(context)!.titlenotifications,
          body:
              '${AppLocalizations.of(context)!.contentnotifications}$todoContent \n${AppLocalizations.of(context)!.datetimenotifications} $format',
        ),
        schedule: NotificationCalendar.fromDate(
          date: remind_before_minute,
          allowWhileIdle: true,
        ),
      );
    }

    if (remaining_time.inHours >= 1) {
      DateTime remind_before_hour = schedule_time.subtract(Duration(hours: 1));

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: todoId + 1,
          channelKey: 'todo_channel',
          title: AppLocalizations.of(context)!.titlenotifications,
          body:
              '${AppLocalizations.of(context)!.contentnotifications}$todoContent \n${AppLocalizations.of(context)!.datetimenotifications} $format',
        ),
        schedule: NotificationCalendar.fromDate(
          date: remind_before_hour,
          allowWhileIdle: true,
        ),
      );
    }

    if (remaining_time.inDays >= 1) {
      DateTime remind_before_day = schedule_time.subtract(Duration(days: 1));

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: todoId + 1,
          channelKey: 'todo_channel',
          title: AppLocalizations.of(context)!.titlenotifications,
          body:
              '${AppLocalizations.of(context)!.contentnotifications}$todoContent \n${AppLocalizations.of(context)!.datetimenotifications} $format',
        ),
        schedule: NotificationCalendar.fromDate(
          date: remind_before_day,
          allowWhileIdle: true,
        ),
      );
    }
  }

  Future<void> date_time_picker() async {
    DateTime? selectedDateTime = await showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime? selectedDateTime = DateTime.now();

        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectdatetime),
          content: DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            dateMask: 'dd/MM/yyyy',
            initialValue: DateTime.now().toString(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            icon: Icon(Icons.event),
            dateLabelText: AppLocalizations.of(context)!.date,
            timeLabelText: AppLocalizations.of(context)!.time,
            onChanged: (val) {
              selectedDateTime = val.isNotEmpty ? DateTime.parse(val) : null;
            },
            validator: (val) {
              // Add validation if needed
              return null;
            },
            onSaved: (val) {
              if (val != null && val.isNotEmpty) {
                selectedDateTime = DateTime.parse(val);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedDateTime);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (selectedDateTime != null) {
      setState(() {
        selected_datetime = selectedDateTime;
      });
    }
  }

  Widget check_toto() {
    if (found_todo.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 200),
        child: Center(
          child: Opacity(
            opacity: 0.5,
            child: Text(
              AppLocalizations.of(context)!.nodoyet,
              style: TextStyle(
                fontSize: 20,
                //color: Colors.black,
              ),
            ),
          ),
        ),
      );
    } else {
      return Column(
        children: found_todo.map((todoo) {
          return To_do_item(
            todo_item: todoo,
            handle_item: handle_todo,
            delete_item: delete_todo,
            edit_item: edit_todo,
            isLightMode: isLightMode,
          );
        }).toList(),
      );
    }
  }

  void add_todo() {
    int current_id = DateTime.now().microsecond;
    setState(() {
      todo_list.add(todo(
        id: current_id.toString(),
        date_time: selected_datetime!,
        text_todo: text_controler.text,
      ));
    });

    save_todo();
    load_todo();

    selected_datetime = null;
    text_controler.clear();

    if (!todo_list.last.is_done) {
      set_schedule(int.parse(todo_list.last.id!), todo_list.last.date_time,
          todo_list.last.text_todo!);
    }
  }

  void edit_todo(String id_item) {
    setState(() {
      selected_datetime =
          todo_list.firstWhere((item) => item.id == id_item).date_time;
      text_controler.text =
          todo_list.firstWhere((item) => item.id == id_item).text_todo!;
    });

    delete_todo(id_item);
    AwesomeNotifications().cancelSchedule(int.parse(id_item));
    save_todo();
  }

  void handle_todo(todo todo_item, String id) {
    setState(() {
      todo_item.is_done = !todo_item.is_done;
    });
    if (todo_item.is_done && id == todo_item.id) {
      AwesomeNotifications().cancelSchedule(int.parse(id));
      AwesomeNotifications().dismiss(int.parse(id));
      AwesomeNotifications().cancelSchedule(int.parse(id) + 1);
      AwesomeNotifications().dismiss(int.parse(id) + 1);
    } else {
      set_schedule(
          int.parse(todo_item.id!), todo_item.date_time, todo_item.text_todo!);
    }
  }

  void delete_todo(String id) {
    todo_list.removeWhere((item) => item.id == id);
    setState(() {
      found_todo = todo_list;
    });
    AwesomeNotifications().cancelSchedule(int.parse(id));
    AwesomeNotifications().dismiss(int.parse(id));
    AwesomeNotifications().cancelSchedule(int.parse(id) + 1);
    AwesomeNotifications().dismiss(int.parse(id) + 1);
    save_todo();
  }

  void delete_all() {
    for (var todoItem in todo_list) {
      AwesomeNotifications().cancelSchedule(int.parse(todoItem.id!));
      AwesomeNotifications().dismiss(int.parse(todoItem.id!));
      AwesomeNotifications().cancelSchedule(int.parse(todoItem.id!) + 1);
      AwesomeNotifications().dismiss(int.parse(todoItem.id!) + 1);
    }
    setState(() {
      todo_list.clear();
      found_todo.clear();
    });
    save_todo();
  }

  void search_todo(String key_word) {
    List<todo> results = [];
    if (key_word.isEmpty) {
      results = todo_list;
    } else {
      results = todo_list
          .where((value) =>
              value.text_todo!.toLowerCase().contains(key_word.toLowerCase()))
          .toList();
    }
    setState(() {
      found_todo = results;
    });
  }

  Widget search_box() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isLightMode ? Color(0xFFEEEFF5) : Colors.grey,
      ),
      child: TextField(
        onChanged: (value) => search_todo(value),
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: EdgeInsets.only(
                right: 8.0), // Adjust the margin value as needed
            child: Icon(
              Icons.search,
              color: isLightMode ? Colors.black : Colors.white,
            ),
          ),
          hintText: AppLocalizations.of(context)!.search,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: isLightMode ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  void update_theme() {
    if (isLightMode) {
      MyApp.setAppTheme(context, ThemeData.light());
    } else {
      MyApp.setAppTheme(context, ThemeData.dark());
    }
  }

  AppBar build_appbar() {
    return AppBar(
      backgroundColor: isLightMode ? Colors.white : Colors.transparent,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LiteRollingSwitch(
            value: isLightMode,
            width: 100.0,
            iconOn: Icons.light_mode,
            textOn: AppLocalizations.of(context)!.light,
            colorOn: Colors.amber,
            textOnColor: Colors.white,
            iconOff: Icons.dark_mode,
            textOff: AppLocalizations.of(context)!.dark,
            colorOff: Colors.black54,
            textOffColor: Colors.white,
            textSize: 14.0,
            onChanged: (value) {
              setState(() {
                isLightMode = value;
                update_theme();
              });
            },
            onDoubleTap: () {},
            onSwipe: () {},
            onTap: () {},
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.deepPurple[200],
            ),
            child: DropdownButton<Language>(
              borderRadius: BorderRadius.circular(10),
              underline: Container(),
              dropdownColor: isLightMode ? Color(0xFFEEEFF5) : Colors.grey,
              iconSize: 25,
              icon: Container(
                margin: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.language,
                  color: Colors.blue[100],
                ),
              ),
              hint: Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  AppLocalizations.of(context)!.language,
                  style: TextStyle(
                      color: isLightMode ? Colors.black : Colors.white),
                ),
              ),
              onChanged: (Language? language) {
                if (language != null) {
                  MyApp.setLocale(context, Locale(language.language_code));
                }
              },
              items: Language.language_list()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                      alignment: AlignmentDirectional.center,
                      value: e,
                      child: Container(
                          width: 120,
                          child: Row(
                            children: <Widget>[
                              Text(
                                e.flag,
                                style: TextStyle(fontSize: 25),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(e.name)),
                            ],
                          )),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
