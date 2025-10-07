import 'package:uuid/uuid.dart';

const uuid = Uuid();

class User {
  User({
    this.name = "",
    this.height = 0.0,
    this.weight = 0.0,
    this.goal = 0.0,
    this.aiCharacter = 'Diet Expert',
    this.birthday,
  }): id = uuid.v4();

  String id;
  String name;
  double height;
  double weight;
  double goal;
  String aiCharacter;
  DateTime? birthday;
}