import 'package:flutter/material.dart';
import 'package:basic_da_app/models/business_model.dart';

class BusinessProvider extends ChangeNotifier {
  BusinessModel? _selectedBusiness;
  BusinessModel? get selectedBusiness => _selectedBusiness;
  bool get hasBusiness => _selectedBusiness != null;

  void selectBusiness(BusinessModel business) {
    _selectedBusiness = business;
    notifyListeners();
  }

  void clearBusiness() {
    _selectedBusiness = null;
    notifyListeners();
  }
}