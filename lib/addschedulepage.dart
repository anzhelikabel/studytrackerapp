import 'package:flutter/material.dart';

import 'hive_db.dart';
import 'model/schedule_model.dart';

class AddSchedulePage extends StatefulWidget {
  final bool isNightMode;
  final bool isUkrainian;

  const AddSchedulePage({Key? key, required this.isNightMode, required this.isUkrainian}) : super(key: key);

  @override
  AddSchedulePageState createState() => AddSchedulePageState();
}

class AddSchedulePageState extends State<AddSchedulePage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final List<Lecture> _lectures = [];
  bool _isInputSelected = false; 
  bool isUkrainian = false; // Define the isUkrainian variable

  @override
  void initState() {
    super.initState();
    isUkrainian = widget.isUkrainian; // Initialize the isUkrainian variable
// Initialize the locale based on isUkrainian
  }

  @override
Widget build(BuildContext context) {
  final ThemeData theme = widget.isNightMode
    ? ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black
      )
    : ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFFCFAF2),
      );
  return Theme(
    data: theme,
    child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
   Column(
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
        isUkrainian ? 'Add schedule' : 'Додай розклад',
        style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      ),
    ],
  ),
              TextField(
  controller: _subjectController,
  decoration: InputDecoration(
    hintText: isUkrainian ? 'Subject' : 'Предмет',
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xEEEE9E8E)),
    ),
  ),
  cursorColor: const Color(0xEEEE9E8E),
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
    hintText: isUkrainian ? 'Time' : 'Час',
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xEEEE9E8E)),
    ),
  ),
  cursorColor: const Color(0xEEEE9E8E),
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
              const SizedBox(height: 16.0),
              Text(isUkrainian ? 'Added notes' : 'Записи', style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
    // Divider(color: Colors.deepPurple.shade100,),
    const SizedBox(height: 15.0),
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
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 60.0),
                ),
              ),
              onPressed: () {
                _showAddLectureDialog(context);
              },
              child: Text(
                isUkrainian ? 'Note' : 'Запис',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(235, 22, 22, 35), // Custom text color
                ),
              ),
            ),
            const SizedBox(width: 8.0), // Add padding between the buttons
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(235, 22, 22, 35),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                ),
              ),
              onPressed: () {
                _saveSchedule();
                Navigator.pop(context);
              },
              child: Text(
                isUkrainian ? 'Add' : 'Додати',
                style: const TextStyle(
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lectureNotesController = TextEditingController();
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
          title: Text(isUkrainian ? 'Add note' : 'Додати запис'),
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
                  controller: lectureNotesController,
                  decoration: InputDecoration(labelText: isUkrainian ? 'Note' : 'Замітки'),
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
              onPressed: () {
                setState(() {
                  _lectures.add(Lecture(
                    name: nameController.text,
                    notes: lectureNotesController.text,
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