import 'package:flutter/material.dart';

var name = TextEditingController();
var initial_date = TextEditingController();
var final_date = TextEditingController();

class ControllerCalendar {
  DateTime dateTimeVar;
  String label= "";

  ControllerCalendar (this.dateTimeVar, this.label);

  DateTime compareDate(DateTime selectedDate, DateTime otherDate) {
    if (selectedDate.isBefore(otherDate)) {
      return selectedDate;
    }

    return otherDate;
  }

  void setDateTimeVar(DateTime date) {
    dateTimeVar = date;
  }

  DateTime getDateTimeVar() {
    return dateTimeVar;
  }

  void setLabel(String label) {
    this.label = label;
  }

  String getLabel() {
    return label;
  }
}