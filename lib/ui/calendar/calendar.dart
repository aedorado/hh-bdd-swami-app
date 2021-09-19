import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class Event {
 late String title;
 late String? subtitle;
 late Timestamp? timestamp;
 late DateTime? datetime;
 late bool? isExpanded;
 late bool? buttonNeeded;
 late String? image;
 late bool? notificationActive = false;

 Event(this.title, {this.subtitle, this.timestamp, this.image, this.isExpanded = false, this.buttonNeeded = false, this.notificationActive = false}) {
   if (this.timestamp != null) {
     this.datetime = DateTime.fromMillisecondsSinceEpoch(
         this.timestamp!.millisecondsSinceEpoch);
   }
 }

 Event.fromFirebaseDocument(QueryDocumentSnapshot<Object?> doc) {
   title = doc['title'] ?? '';
   image = doc['image_url'] == '-' ? null : doc['image_url'];
   timestamp = doc['timing'];
   buttonNeeded = doc['link'] == '-' ? false : true;
   if (this.timestamp != null) {
     datetime = DateTime.fromMillisecondsSinceEpoch(this.timestamp!.millisecondsSinceEpoch);
     subtitle = datetime.toString();
   }
   isExpanded = false;
   notificationActive = false;
 }

 // GalleryImage.fromFireBaseSnapshotDoc(QueryDocumentSnapshot<Object?> doc) {
 //   id = doc['id'] ?? '';
 //   description = doc['description'] ?? '';
 //   albumID = doc['album_id'] ?? '';
 //   color = doc['color'] ?? '';
 //   date = doc['date'] ?? '';
 //   displayURL = doc['display_url'] ?? '';
 //   downloadURL = doc['download_url'] ?? '';
 //   thumbnailURL = doc['thumbnail_url'] ?? '';
 //   location = doc['location'] ?? '';
 //   tags = doc['tags'] ?? '';
 //   type = doc['type'] ?? '';
 // }

 @override
 String toString() => 'title=${title},timestamp=${timestamp},datetime=${datetime}';
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
 equals: isSameDay,
 hashCode: getHashCode,
);

int getHashCode(DateTime key) {
 return key.day * 1000000 + key.month * 10000 + key.year;
}

final monthsAhead = 4;
final monthsBefore = 1;
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - monthsBefore, 1);
final kLastDay = DateTime(
   kToday.month + monthsAhead > 12 ? kToday.year + 1 : kToday.year,
   kToday.month + monthsAhead > 12
       ? ((kToday.month + monthsAhead) % 12) + 1
       : kToday.month + monthsAhead,
   1);

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
   return kEvents[day] ?? [];
 }

 void fetchEvents() async {
   var snapshot = await FirebaseFirestore.instance.collection(this.eventsCollection).get();
   var eventsList = [
     for (var doc in snapshot.docs) Event.fromFirebaseDocument(doc) // (doc['title'], '', timestamp: doc['timing'])
   ];
   Map<DateTime, List<Event>> dateToEventsMap = new Map<DateTime, List<Event>>();
   eventsList.forEach((event) {
     DateTime key = DateTime.utc(event.datetime!.year, event.datetime!.month, event.datetime!.day);
     if (!dateToEventsMap.containsKey(key)) {
       dateToEventsMap[key] = <Event>[];
     }
     dateToEventsMap[key]!.add(event);
   });
   kEvents.addAll(dateToEventsMap);
   _selectedEvents.value = _getEventsForDay(kToday);
 }

 @override
 void initState() {
   super.initState();
   _selectedDay = _focusedDay;
   _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
   fetchEvents();
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

 String eventsCollection = 'events';
 String recurringEventsCollection = 'recurring_events';

 Widget _buildRecurringEventsModalRow(
     String imageAsset, String seriesTitle, String occursOn) {
   return Padding(
     padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
     child: Container(
       height: 54,
       decoration: BoxDecoration(
         color: Color(0xFFF2F2F2),
         borderRadius: BorderRadius.circular(4),
       ),
       child: Padding(
         padding: const EdgeInsets.all(4.0),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.start,
           children: <Widget>[
             Expanded(
                 flex: 6,
                 child:
                 CircleAvatar(backgroundImage: AssetImage(imageAsset))),
             Expanded(flex: 1, child: Container()),
             Expanded(
                 flex: 33,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(
                       seriesTitle,
                       overflow: TextOverflow.ellipsis,
                       maxLines: 1,
                     ),
                     Text(occursOn),
                   ],
                 )),
           ],
         ),
       ),
     ),
   );
 }

 _showSimpleModalDialog(context) {
   showDialog(
       context: context,
       builder: (BuildContext context) {
         return Dialog(
           insetPadding: EdgeInsets.all(24.0),
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(20)),
           elevation: 16,
           child: Container(
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(20),
             ),
             constraints: BoxConstraints(maxHeight: 350),
             child: Padding(
               padding: const EdgeInsets.all(12.0),
               child: Column(
                 children: [
                   Expanded(
                     flex: 1,
                     child: Padding(
                       padding: const EdgeInsets.all(4.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Center(
                               child: Text(
                                 'Recurring Events',
                                 style: TextStyle(fontSize: 16.0),
                               )),
                           IconButton(
                               icon: Icon(
                                 Icons.close,
                                 color: Colors.black,
                               ),
                               onPressed: () {
                                 Navigator.pop(context);
                               }),
                         ],
                       ),
                     ),
                   ),
                   Expanded(
                       flex: 7,
                       child: StreamBuilder<QuerySnapshot>(
                         stream: FirebaseFirestore.instance.collection(this.recurringEventsCollection).where("is_active", isEqualTo: true).snapshots(),
                         builder: (context, snapshot) {
                           if (snapshot.hasData) {
                             // snapshot.data!.docs[index]
                             return ListView.builder(
                                 shrinkWrap: true,
                                 physics: BouncingScrollPhysics(),
                                 itemCount: snapshot.data!.size,
                                 itemBuilder: (BuildContext context, int index) {
                                   var doc = snapshot.data!.docs[index];
                                   return _buildRecurringEventsModalRow(doc['avatar'], doc['timing'], doc['title']);
                                 }
                             );
                           } else {
                             return Center(child: CircularProgressIndicator());
                           }
                         },
                       )
                   ),
                 ],
               ),
             ),
           ),
         );
       });
 }

 @override
 Widget build(BuildContext context) {
   return Column(
     children: [
       InkWell(
         onTap: () {
           _showSimpleModalDialog(context);
         },
         child: StreamBuilder<QuerySnapshot>(
           stream: FirebaseFirestore.instance.collection(this.recurringEventsCollection).where("is_active", isEqualTo: true).snapshots(),
           builder: (context, snapshot) {
             if (snapshot.hasData) {
               var count = snapshot.data!.size;
               return SizedBox(
                   height: 32,
                   child: Container(
                     decoration: BoxDecoration(color: Colors.amberAccent.shade200),
                     alignment: Alignment.center,
                     child: Padding(
                       padding: const EdgeInsets.only(
                           left: 12.0, top: 2.0, bottom: 2.0, right: 2.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Container(
                             height: 22,
                             width: 22,
                             decoration: BoxDecoration(
                               color: Color(0xFF005CB2),
                               shape: BoxShape.circle,
                             ),
                             child: Center(
                               child: Text(
                                 count == 0 ? 'No': '${count}',
                                 style: TextStyle(color: Colors.white),
                               ),
                             ),
                           ),
                           Text(
                             ' recurring lectures/events.',
                             style: TextStyle(fontSize: 15),
                           ),
                         ],
                       ),
                     ),
                   ));
             } else {
               return Container();
             }
           },
         )
       ),
       Expanded(
         flex: 1,
         child: Container(
           decoration: BoxDecoration(
             color: Colors.white,
             boxShadow: <BoxShadow>[
               BoxShadow(
                 offset: Offset(0, -2.0),
                 color: Color(0x44BDBDBD),
                 blurRadius: 8,
               ),
             ],
           ),
           child: Padding(
             padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 6.0),
             child: TableCalendar(
               firstDay: kFirstDay,
               lastDay: kLastDay,
               focusedDay: kToday,
               shouldFillViewport: true,
               calendarFormat: _calendarFormat,
               onDaySelected: _onDaySelected,
               eventLoader: _getEventsForDay,
               calendarStyle: CalendarStyle(
                   selectedDecoration: BoxDecoration(
                       color: Color(0xFF005CB2), shape: BoxShape.circle),
                   todayDecoration: BoxDecoration(
                       color: Color(0xAA005CB2), shape: BoxShape
                       .circle)),
               headerStyle: HeaderStyle(
                 formatButtonVisible: false,
               ),
               calendarBuilders: CalendarBuilders(
                 markerBuilder: (context, date, _) {
                   var events = _getEventsForDay(date);
                   if (events.length == 0) {
                     return null;
                   }
                   return Container(
                     alignment: Alignment.bottomRight,
                     margin: const EdgeInsets.symmetric(horizontal: 1.5),
                     child: Container(
                       width: MediaQuery
                           .of(context)
                           .size
                           .width * .045,
                       height: MediaQuery
                           .of(context)
                           .size
                           .width * .045,
                       decoration: BoxDecoration(
                           color: Colors.blue, shape: BoxShape.circle),
                       child: Text(
                         '${events.length}',
                         textAlign: TextAlign.center,
                         style: TextStyle(
                           fontSize: MediaQuery
                               .of(context)
                               .size
                               .width * .032,
                           fontWeight: FontWeight.bold,
                           color: Colors.white,
                         ),
                       ),
                     ),
                   );
                 },
                 headerTitleBuilder: (context, day) {
                   List<String> months = [
                     'January',
                     'February',
                     'March',
                     'April',
                     'May',
                     'June',
                     'July',
                     'August',
                     'September',
                     'October',
                     'November',
                     'December'
                   ];
                   String monthName =
                       '${months[day.month - 1] + day.year.toString()}';
                   return Container(
                       alignment: Alignment.center,
                       child: Text(
                         monthName,
                         style: TextStyle(
                             fontFamily: 'Nunito',
                             fontSize: 16,
                             fontWeight: FontWeight.bold),
                       ));
                 },
               ),
               selectedDayPredicate: (day) =>
                   isSameDay(_selectedDay, day),
               onFormatChanged: (format) {
                 if (_calendarFormat != format) {
                   setState(() {
                     _calendarFormat = format;
                   });
                 }
               },
             ),
           ),
         ),
       ),
       const SizedBox(height: 10),
       Expanded(
         flex: 1,
         child: SingleChildScrollView(
           physics:
               BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
     return Container(
       decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
       child: ExpansionPanelList(
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
                   leading: IconButton(
                     icon: Icon(Icons.notifications_none),
                     onPressed: () async {
                       const AndroidNotificationDetails androidPlatformChannelSpecifics =
                       AndroidNotificationDetails(
                           'your channel id', 'your channel name', 'your channel description',
                           importance: Importance.max,
                           priority: Priority.high,
                           showWhen: false);
                       const NotificationDetails platformChannelSpecifics =
                       NotificationDetails(android: androidPlatformChannelSpecifics);
                       await flutterLocalNotificationsPlugin.show(0, 'plain title', 'plain body', platformChannelSpecifics, payload: 'item x');
                     },
                   ),
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
                         child: Text(event.subtitle ?? ''),
                       ),
                     ],
                   ),
                 );
               },
               body: Container(
                 width: MediaQuery.of(context).size.width,
                 child: Column(
                   children: [
                     if (event.image != null) Image.network(event.image ?? ''),
                     if (event.buttonNeeded ?? false)
                       TextButton(
                         onPressed: () async {
                           if (await canLaunch(
                               'https://youtu.be/TYPKAj1685M?t=3771')) {
                             await launch(
                                 'https://youtu.be/TYPKAj1685M?t=3771');
                           } else {
                             // TODO toast shows cannot open link
                           }
                         },
                         child: Text('Join on Zoom'),
                       ),
                   ],
                 ),
               ),
               isExpanded: event.isExpanded ?? false,
             );
           }).toList()),
     );
   } else {
     return Container(child: Text('No events planned for this date!'));
   }
 }
