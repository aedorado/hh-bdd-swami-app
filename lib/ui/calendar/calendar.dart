import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  final String subTitle;

  const Event(this.title, this.subTitle);

  @override
  String toString() => title;
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) =>
        List.generate(item % 4 + 1, (index) => Event('Event $item | ${index + 1}', 'Learn about Bhagvad Gita!')))
  ..addAll({
    kToday: [
      Event('Hare Krishna Africa - Radhashtami Lecture', '5:30 PM IST, 2PM WBT'),
      Event('Gita Course', 'Gita Pathshala, Dehradun'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final monthsAhead = 4;
final monthsBefore = 1;
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - monthsBefore, 1);
final kLastDay = DateTime(kToday.month + monthsAhead > 12 ? kToday.year + 1 : kToday.year,
    kToday.month + monthsAhead > 12 ? ((kToday.month + monthsAhead) % 12) + 1 : kToday.month + monthsAhead, 1);

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        // _rangeStart = null; // Important to clean those
        // _rangeEnd = null;
        // _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: kToday,
          calendarFormat: _calendarFormat,
          onDaySelected: _onDaySelected,
          eventLoader: _getEventsForDay,
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, _) {
              var events = _getEventsForDay(date);
              if (events.length == 0) {
                return Container();
              }
              return Container(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  child: Text(
                    '${events.length}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
            dowBuilder: (context, day) {
              if (day.weekday == DateTime.sunday) {
                final text = 'Sun';
                return Center(
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
            },
          ),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
        ),
        const SizedBox(height: 15.0),
        Expanded(
          child: ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () => print('${value}'),
                      title: Text('${value[index]}'),
                      subtitle: Text('${value[index]}'),
                      // trailing: IconButton(icon: Icon(),),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
