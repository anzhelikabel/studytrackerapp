import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/addschedulepage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


import 'scheduledetailspage.dart';
import 'hive_db.dart';
import 'model/schedule_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isNotifying = false;
  bool isNightMode = false;


  @override
  Widget build(BuildContext context) {
      final ThemeData theme = isNightMode
        ? ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
          )
        : ThemeData.light().copyWith(
          scaffoldBackgroundColor: Color(0xFFFCFAF2),
        );
    return Theme(
      data: theme,
      child: Scaffold(
      body: ValueListenableBuilder(
        valueListenable: HiveDB.getScheduleBox().listenable(), 
        builder: (BuildContext context, Box<Schedule> box, Widget ) {
          if (box.values.isEmpty) {
          return Center(child: Text('Почти відстежувати результат!'));
        }
          return Column(
            children: [
              Padding(
      padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Розклад",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
            PopupMenuButton<String>(
  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
    PopupMenuItem<String>(
      value: 'send_notifications',
      child: Row(
        children: [
          Icon(isNotifying ? Icons.notifications_active : Icons.notifications, 
            color: isNotifying ? Colors.orange : null,),
          SizedBox(width: 8.0),
          Text('Повідомлення'),
        ],
      ),
    ),
    PopupMenuItem<String>(
      value: 'night_mode',
      child: Row(
        children: [
          Icon(Icons.nightlight_round,
            color: isNightMode ? Colors.orange : null,),
          SizedBox(width: 8.0),
          Text('Нічний режим'),
        ],
      ),
    ),
  ],
  onSelected: (String value) {
    // Handle popup menu item selection
    switch (value) {
      case 'send_notifications':
        setState(() {
          isNotifying = !isNotifying;
        });
        // Code to handle sending notifications
        break;
      case 'night_mode':
        setState(() {
          isNightMode = !isNightMode;
        });
        // Code to toggle night mode
        break;
    }
  },
   onCanceled: () {
    // Do nothing
  },
)
                  ],
                ),
              ),
          Expanded (
          child: ListView.builder(
            itemCount: box.length,
            itemBuilder: (BuildContext context, int index) {
              Schedule? schedule = box.getAt(index);
             return Dismissible(
  key: UniqueKey(),
  onDismissed: (direction) {
    box.deleteAt(index);
  },
  background: Container(
    color: Colors.grey, // Change this to the desired background color
    alignment: Alignment.centerRight,
    child: Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    ),
  ), child:  Card(
  elevation: 3,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ScheduleDetailsPage(schedule: schedule!,  isNightMode: isNightMode),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              schedule?.subject ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                schedule?.time ?? '',
                style: TextStyle(fontWeight: FontWeight.w200),
              ),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 13.0,
              horizontal: 16.0,
            ),
              child: LinearPercentIndicator(
             lineHeight: 5,
              barRadius: Radius.circular(50.0),
          percent: _calculatePercentComplete(schedule),
          progressColor: Colors.deepPurple,
          backgroundColor: Colors.deepPurple.shade100,
          animation: true,
          animationDuration: 1000,
          ),
      )],
      ),
    ),
  ),
),);
    
        }))]);
            },
            ),
            floatingActionButton: SizedBox(
               height: 70.0,
    width: 70.0,
      child: FloatingActionButton(
  backgroundColor: Color(0xEEEE9E8E),
  child: Icon(Icons.add, size: 30.0,),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddSchedulePage(isNightMode: isNightMode)),
    );
  },
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16)
  ),
),
            )));
  }

  double _calculatePercentComplete(Schedule? schedule) {
  if (schedule == null || schedule.lectures!.isEmpty) {
    return 0.0;
  }
  int totalLectures = 30;
  int addedLectures = schedule.lectures!.where((lecture) => lecture.name != null).length;
  return addedLectures / totalLectures;
}

}