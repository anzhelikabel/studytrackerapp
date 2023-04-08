import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'model/schedule_model.dart';

  class ScheduleDetailsPage extends StatefulWidget {
    final Schedule schedule;
    final bool isNightMode;
    final bool isUkrainian;

    const ScheduleDetailsPage({Key? key, required this.schedule,  required this.isNightMode, required this.isUkrainian}) : super(key: key);

    @override
    ScheduleDetailsPageState createState() => ScheduleDetailsPageState();
  }

  class ScheduleDetailsPageState extends State<ScheduleDetailsPage> {
    List<Lecture> _lectures = [];
    bool isUkrainian = false; // Define the isUkrainian variable

  @override
  void initState() {
    super.initState();
    isUkrainian = widget.isUkrainian; // Initialize the isUkrainian variable
    _lectures = widget.schedule.lectures ?? []; // Initialize the locale based on isUkrainian
  }


    @override
    Widget build(BuildContext context) {
       final ThemeData theme = widget.isNightMode
        ? ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
          )
        : ThemeData.light().copyWith(
           scaffoldBackgroundColor: const Color(0xFFFCFAF2),
        );

    return Theme(
      data: theme,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                    Padding(padding: const EdgeInsets.only(bottom: 40.0),
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      ),
              Padding(padding: const EdgeInsets.only(bottom: 40.0),
      child: Text(
        widget.schedule.subject ?? '',
        style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      ),
              Text(
                isUkrainian ? 'Time: ' : 'Час: ' 
                '${widget.schedule.time ?? ''}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Text(
                isUkrainian ? 'Added notes' : 'Записи',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
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
          child: const Padding(
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
    const SizedBox(height: 1.0),
    Text(
      lecture.name ?? '',
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    const SizedBox(height: 4.0),
    Text(
      lecture.notes ?? '',
      style: const TextStyle(
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
              backgroundColor: const Color(0xEEEE9E8E),
              onPressed: () {
                _showAddLectureDialog(context);
              }, 

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)
            ),
              child: const Icon(Icons.add, size: 30.0,),
            ),

   )));
    }


  void _showAddLectureDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final ThemeData dialogDarkTheme = ThemeData.dark().copyWith(
    dialogBackgroundColor: Colors.grey[900],
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.light(
    primary: Color(0xEEEE9E8E),
    onPrimary: Colors.white,
  ),
  );
  final ThemeData dialogLightTheme = ThemeData.light().copyWith(
    dialogBackgroundColor: const Color(0xFFFCFAF2),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    ),
     colorScheme: const ColorScheme.light(
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
          title: Text(isUkrainian ? 'Add note' : 'Додай запис'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: isUkrainian ? 'Name' : 'Назва'),
                ),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(labelText: isUkrainian ? 'Notes' : 'Замітки'),
                ),
              ],
            ),
          ),
          actions: [
           TextButton(
  style: TextButton.styleFrom(
    foregroundColor: Colors.grey[700], textStyle: const TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w300,
    ),
  ),
  onPressed: () {
    Navigator.pop(context);
  },
  child: Text(isUkrainian ? 'Cancel' : 'Відмінити'),
),
            ElevatedButton(
              child: Text(isUkrainian ? 'Add' : 'Додати'),
              onPressed: () async {
                final newLecture = Lecture(
                  name: nameController.text,
                  notes: notesController.text,
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

                // ignore: use_build_context_synchronously
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
