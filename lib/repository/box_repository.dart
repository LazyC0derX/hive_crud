import 'package:hive_crud/model/notes.dart';
import 'package:hive_flutter/hive_flutter.dart';


class BoxRepository {
  static const String boxName = "CRUD";

  static openBox() async => await Hive.openBox<Note>(boxName);

  static Box getBox() => Hive.box<Note>(boxName);

  static closeBox() async => await Hive.box(boxName).close();

}