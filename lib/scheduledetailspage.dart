import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive/hive.dart';

import 'model/schedule_model.dart';

  class ScheduleDetailsPage extends StatefulWidget {
    final Schedule schedule;
    final bool isNightMode;

    const ScheduleDetailsPage({Key? key, required this.schedule,  required this.isNightMode}) : super(key: key);

    @override
    _ScheduleDetailsPageState createState() => _ScheduleDetailsPageState();
  }

  class _ScheduleDetailsPageState extends State<ScheduleDetailsPage> {
    List<Lecture> _lectures = [];

    @override
    void initState() {
      super.initState();
      _lectures = widget.schedule.lectures ?? [];
    }

    @override
    Widget build(BuildContext context) {
       final ThemeData theme = widget.isNightMode
        ? ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
          )
        : ThemeData.light().copyWith(
           scaffoldBackgroundColor: Color(0xFFFCFAF2),
        );

    return Theme(
      data: theme,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                    Padding(padding: EdgeInsets.only(bottom: 40.0),
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      ),
              Padding(padding: EdgeInsets.only(bottom: 40.0),
      child: Text(
        widget.schedule.subject ?? '',
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      ),
              Text(
                'Час: ' 
                '${widget.schedule.time ?? ''}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                'Записи:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: _lectures.length,
                itemBuilder: (BuildContext context, int index) {
                  Lecture? lecture = _lectures[index];
                        return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) async {
          setState(() {
            _lectures.removeAt(index);
          });

          final box = await Hive.openBox<Schedule>('scheduleBox');
          final scheduleIndex = box.values.toList().indexOf(widget.schedule);
          final updatedSchedule = Schedule(
            subject: widget.schedule.subject,
            time: widget.schedule.time,
            lectures: _lectures,
          );

          await box.putAt(scheduleIndex, updatedSchedule);
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
        ), 
        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(height: 1.0),
    Text(
      lecture.name ?? '',
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(height: 4.0),
    Text(
      lecture.notes ?? '',
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
      ),
    ), // add divider
  ],
)
);
                },
              ),
              )
            ],
          ),
        ),
 floatingActionButton: SizedBox(
               height: 70.0,
    width: 70.0,
      child: FloatingActionButton(
              backgroundColor: Color(0xEEEE9E8E),
              child: Icon(Icons.add, size: 30.0,),
              onPressed: () {
                _showAddLectureDialog(context);
              }, 

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)
            ),
            ),

   )));
    }


  void _showAddLectureDialog(BuildContext context) {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final ThemeData dialogDarkTheme = ThemeData.dark().copyWith(
    dialogBackgroundColor: Colors.grey[900],
    textTheme: TextTheme(
      headline6: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      subtitle1: TextStyle(
        fontSize: 16.0,
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
    primary: Color(0xEEEE9E8E),
    onPrimary: Colors.white,
  ),
  );
  final ThemeData dialogLightTheme = ThemeData.light().copyWith(
    dialogBackgroundColor: Color(0xFFFCFAF2),
    textTheme: TextTheme(
      headline6: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      subtitle1: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    ),
     colorScheme: ColorScheme.light(
    primary: Color(0xEEEE9E8E),
    onPrimary: Colors.white,
  ),
  );
  final ThemeData dialogTheme =
      widget.isNightMode ? dialogDarkTheme : dialogLightTheme;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: dialogTheme,
        child: AlertDialog(
          title: Text('Додай запис'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Назва'),
                ),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(labelText: 'Замітки'),
                ),
              ],
            ),
          ),
          actions: [
           TextButton(
  child: Text('Відмінити'),
  style: TextButton.styleFrom(
    primary: Colors.grey[700],
    textStyle: TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w300,
    ),
  ),
  onPressed: () {
    Navigator.pop(context);
  },
),
            ElevatedButton(
              child: Text('Додати'),
              onPressed: () async {
                final newLecture = Lecture(
                  name: _nameController.text,
                  notes: _notesController.text,
                );

                setState(() {
                  _lectures.add(newLecture);
                });

                final box = await Hive.openBox<Schedule>('scheduleBox');
                final index = box.values.toList().indexOf(widget.schedule);
                final updatedSchedule = Schedule(
                  subject: widget.schedule.subject,
                  time: widget.schedule.time,
                  lectures: _lectures,
                );

                await box.putAt(index, updatedSchedule);

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
  },
    );
}
  }
