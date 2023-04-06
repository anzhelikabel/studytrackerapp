import 'package:flutter/material.dart';

import 'hive_db.dart';
import 'model/schedule_model.dart';

class AddSchedulePage extends StatefulWidget {
  final bool isNightMode;

  const AddSchedulePage({Key? key, required this.isNightMode}) : super(key: key);

  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  List<Lecture> _lectures = [];
  bool _isInputSelected = false;

  @override
Widget build(BuildContext context) {
  final ThemeData theme = widget.isNightMode
    ? ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black
      )
    : ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color(0xFFFCFAF2),
      );
  return Theme(
    data: theme,
    child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
   Column(
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
        "Додай розклад",
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      ),
    ],
  ),
              TextField(
  controller: _subjectController,
  decoration: InputDecoration(
    hintText: 'Предмет',
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xEEEE9E8E)),
    ),
  ),
  cursorColor: Color(0xEEEE9E8E),
                onTap: () {
                  // Set the flag to true when subject field is selected
                  setState(() {
                    _isInputSelected = true;
                  });
                },
                onSubmitted: (value) {
                  // Set the flag to false when subject field loses focus
                  setState(() {
                    _isInputSelected = false;
                  });
                },
),
TextField(
  controller: _timeController,
  decoration: InputDecoration(
    hintText: 'Час',
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xEEEE9E8E)),
    ),
  ),
  cursorColor: Color(0xEEEE9E8E),
  onTap: () {
    // Set the flag to true when time field is selected
    setState(() {
      _isInputSelected = true;
    });
  },
  onSubmitted: (value) {
    // Set the flag to false when time field loses focus
    setState(() {
      _isInputSelected = false;
    });
  },
),
              SizedBox(height: 16.0),
              Text('Записи', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500)),
              SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _lectures.length,
                itemBuilder: (BuildContext context, int index) {
                  Lecture lecture = _lectures[index];
                   return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) async {
          setState(() {
            _lectures.removeAt(index);
          });
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
    // Divider(color: Colors.deepPurple.shade100,),
    SizedBox(height: 15.0),
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
            ],
          ),
        ),
      ),
      floatingActionButton: !_isInputSelected // Show/hide buttons based on flag
          ? Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 60.0),
                ),
              ),
              onPressed: () {
                _showAddLectureDialog(context);
              },
              child: Text(
                'Запис',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(235, 22, 22, 35), // Custom text color
                ),
              ),
            ),
            SizedBox(width: 8.0), // Add padding between the buttons
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(235, 22, 22, 35),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                ),
              ),
              onPressed: () {
                _saveSchedule();
                Navigator.pop(context);
              },
              child: Text(
                'Розклад',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      )  : Container(), // Empty container when input is selected
    ),
      );
  }

  void _showAddLectureDialog(BuildContext context) {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lectureNotesController = TextEditingController();
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
                  controller: _lectureNotesController,
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
              onPressed: () {
                setState(() {
                  _lectures.add(Lecture(
                    name: _nameController.text,
                    notes: _lectureNotesController.text,
                  ));
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

  void _saveSchedule() {
  String subject = _subjectController.text;
  String time = _timeController.text;

  Schedule newSchedule = Schedule(subject: subject, time: time, lectures: _lectures);

  HiveDB.getScheduleBox().add(newSchedule);
}
}