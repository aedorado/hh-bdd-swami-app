import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class Event {
 final String title;
 final String subtitle;
 bool? isExpanded;
 bool? buttonNeeded;
 String? image;
 bool? notificationActive = false;

 Event(this.title, this.subtitle, {this.image, this.isExpanded = false, this.buttonNeeded = false, this.notificationActive = false});

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
       List.generate(item % 4 + 1, (index) => Event(
           'Event $item | ${index + 1}',
           'Learn about Bhagavad Gita!',
           buttonNeeded: index % 3 == 0,
           image: index % 2 == 0 ? 'https://i.ibb.co/QNw14kf/demyst3.jpg': null )))
 ..addAll({
   kToday: [
     Event('Button & image', '5:30 PM IST, 2PM WBT', buttonNeeded: true, image: 'https://i.ibb.co/QNw14kf/demyst3.jpg'),
     Event('Button Only', 'Button Only', buttonNeeded: true),
     Event('Image Only', 'Image Only', buttonNeeded: false, image: 'https://i.ibb.co/QNw14kf/demyst3.jpg'),
     Event('None', 'None', buttonNeeded: false),
     Event('Gita Course', 'Gita Pathshala, Dehradun'),
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
       Expanded(
         flex: 1,
         child: TableCalendar(
           firstDay: kFirstDay,
           lastDay: kLastDay,
           focusedDay: kToday,
           shouldFillViewport: true,
           calendarFormat: _calendarFormat,
           onDaySelected: _onDaySelected,
           eventLoader: _getEventsForDay,
           headerStyle: HeaderStyle(
             formatButtonVisible: false,
           ),
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
                     style: TextStyle(color: Colors.amber),
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
       ),
       const SizedBox(height: 10),
       Expanded(
         flex: 1,
         child: SingleChildScrollView(
           physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
           child: ValueListenableBuilder<List<Event>>(
             valueListenable: _selectedEvents,
             builder: (context, value, _) {
               return CalendarExpansionList(events: value);
             },
           ),
         ),
       ),
     ],
   );
 }
}

class CalendarExpansionList extends StatefulWidget {
 List<Event> events;
 CalendarExpansionList({required this.events});

 @override
 _CalendarExpansionListState createState() => _CalendarExpansionListState();
}

class _CalendarExpansionListState extends State<CalendarExpansionList> {

 @override
 Widget build(BuildContext context) {
   if (widget.events.length > 0) {
     return ExpansionPanelList(
         expandedHeaderPadding: EdgeInsets.only(top: 5.0),
         expansionCallback: (int index, bool isExpanded) {
           setState(() {
             widget.events[index].isExpanded = !isExpanded;
           });
         },
         children: widget.events.map<ExpansionPanel>((Event event) {
           return ExpansionPanel(
             headerBuilder: (BuildContext context, bool isExpanded) {
               return ListTile(
                 // isThreeLine: true,
                 leading: Icon(Icons.notifications_none),
                 title: Padding(
                   padding: const EdgeInsets.all(2.0),
                   child: Text(event.title),
                 ),
                 subtitle: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Padding(
                       padding: const EdgeInsets.all(2.0),
                       child: Text(event.subtitle),
                     ),
                     // Padding(
                     //   padding: const EdgeInsets.all(2.0),
                     //   child: Text(
                     //     event.timeAgo,
                     //     style: TextStyle(color: Colors.grey[900]),
                     //   ),
                     // ),
                   ],
                 ),
               );
             },
             body: Container(
               width: MediaQuery
                   .of(context)
                   .size
                   .width,
               child: Column(
                 children: [
                   if (event.image != null) Image.network(event.image ?? ''),
                   if (event.buttonNeeded ?? false) TextButton(
                     onPressed: () async {
                       if (await canLaunch(
                           'https://youtu.be/TYPKAj1685M?t=3771')) {
                         await launch('https://youtu.be/TYPKAj1685M?t=3771');
                       } else {
                         throw 'Could not launch https://youtu.be/TYPKAj1685M?t=3771';
                       }
                     },
                     child: Text('Join on Zoom'),
                   ),
                 ],
               ),
             ),
             isExpanded: event.isExpanded ?? false,
           );
         }).toList()
     );
   } else {
     return Container(child: Text('No events planned for this date!'));
   }
   // return ListView.builder(
   //   itemCount: widget.events.length,
   //   itemBuilder: (context, index) {
   //     debugPrint('${widget.events[index]}');
   //     return Container(
   //       margin: const EdgeInsets.symmetric(
   //         horizontal: 12.0,
   //         vertical: 4.0,
   //       ),
   //       decoration: BoxDecoration(
   //         border: Border.all(),
   //         borderRadius: BorderRadius.circular(12.0),
   //       ),
   //       child: ListTile(
   //         // onTap: () => print('${widget.events.value}'),
   //         // title: Text('${widget.events.value[index]}'),
   //         // subtitle: Text('${widget.events.value[index]}'),
   //         // trailing: IconButton(icon: Icon(),),
   //       ),
   //     );
   //   },
   // );
 }
}
