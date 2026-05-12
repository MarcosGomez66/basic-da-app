import 'package:hive/hive.dart';

part 'workday_model.g.dart';

@HiveType(typeId: 1)
class WorkdayModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String businessId;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  DateTime? endTime;

  @HiveField(4)
  bool isOpen;

  WorkdayModel({
    required this.id,
    required this.businessId,
    required this.startTime,
    this.endTime,
    this.isOpen = true,
  });
}
