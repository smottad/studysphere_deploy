import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments?[index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments?[index].endTime;
  }

  @override
  String getSubject(int index) {
    return appointments?[index].title;
  }

  @override
  Color getColor(int index) {
    return appointments?[index].color;
  }
}

class Event {
  String title;
  DateTime startTime;
  DateTime endTime;
  Color color;

  Event(this.title, this.startTime, this.endTime, this.color);
}
