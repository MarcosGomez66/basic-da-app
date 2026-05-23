import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:basic_da_app/models/workday_model.dart';

class WorkdayProvider extends ChangeNotifier {
  WorkdayModel? currentWorkday;

  final Box<WorkdayModel> workdayBox = Hive.box<WorkdayModel>('workdays');

  bool get isWorkdayOpen => currentWorkday != null;

  void loadCurrentWorkday(String businessId) {
    try {
      currentWorkday = workdayBox.values.firstWhere(
        (s) => s.businessId == businessId && s.isOpen,
      );
    } catch (e) {
      currentWorkday = null;
    }
    notifyListeners();
  }

  Future<void> startWorkday({required String businessId}) async {
    final workday = WorkdayModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      businessId: businessId,
      startTime: DateTime.now(),
    );

    await workdayBox.put(workday.id, workday);
    currentWorkday = workday;
    notifyListeners();
  }

  Future<void> endWorkday() async {
    if (currentWorkday == null) return;

    currentWorkday!
      ..endTime = DateTime.now()
      ..isOpen = false;

    await currentWorkday!.save();
    currentWorkday = null;
    notifyListeners();
  }

  List<WorkdayModel> getWorkdays(String businessId) {
    final workdays = workdayBox.values.where(
        (e) => e.businessId == businessId
    ).toList();
    workdays.sort(
        (a, b) => b.startTime.compareTo(a.startTime)
    );
    return workdays;
  }
}
