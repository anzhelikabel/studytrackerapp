import "package:hive/hive.dart";
part 'schedule_model.g.dart';

@HiveType(typeId: 0)
class Schedule {
  @HiveField(0)
  String? subject;

  @HiveField(1)
  String? time;

  @HiveField(3)
  List<Lecture>? lectures;

  Schedule({this.subject, this.time,this.lectures});
}

@HiveType(typeId: 1)
class Lecture {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? notes;

  Lecture({this.name, this.notes});
}
