import 'package:hive/hive.dart';

part 'business_model.g.dart';

@HiveType(typeId: 0)
class BusinessModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime startTime;

  BusinessModel({
    required this.id,
    required this.name,
    required this.startTime,
  });
}
