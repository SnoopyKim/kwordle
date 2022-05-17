import 'package:hive/hive.dart';

part 'history.g.dart';

@HiveType(typeId: 1)
class History {
  @HiveField(0)
  final DateTime? clearTime;

  @HiveField(1)
  final String word;

  @HiveField(2)
  final String letters;

  @HiveField(3)
  final String definition;

  @HiveField(4)
  final List<List<Map<String, dynamic>>> history;

  History({
    required this.clearTime,
    required this.word,
    required this.letters,
    required this.definition,
    required this.history,
  });
}
