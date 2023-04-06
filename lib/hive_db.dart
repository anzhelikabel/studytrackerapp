import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_app/model/schedule_model.dart';

class HiveDB {
  static const String scheduleBoxName = 'scheduleBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ScheduleAdapter());
    Hive.registerAdapter(LectureAdapter());
    await Hive.openBox<Schedule>(scheduleBoxName);
  }

  static Box<Schedule> getScheduleBox() {
    return Hive.box<Schedule>(scheduleBoxName);
  }
}