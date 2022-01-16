import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hh_bbds_app/ui/calendar/calendar.dart';
import 'package:hh_bbds_app/ui/loaders/spinkit_loaders.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewEvent extends StatefulWidget {
  int eventId;

  ViewEvent({required this.eventId});

  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Event'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where("id", isEqualTo: widget.eventId)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.size > 0) {
              Event event = Event.fromFirebaseDocument(snapshot.data!.docs[0]);
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    if (event.image != null) Image.network(event.image ?? ''),
                    if (event.description != null && event.description!.length > 0)
                      Text(event.description ?? ''),
                    if (event.buttonsList.length > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (var eventButton in event.buttonsList)
                            IconButton(
                              onPressed: () async {
                                if (await canLaunch(eventButton.link)) {
                                  await launch(eventButton.link);
                                } else {
                                  // TODO toast shows cannot open link
                                }
                              },
                              icon: eventButton.type == 'zoom'
                                  ? SvgPicture.asset(
                                      'images/zoom.svg',
                                      semanticsLabel: 'Join on Zoom',
                                    )
                                  : FaIcon(
                                      eventButton.icon,
                                      color: eventButton.color,
                                    ),
                            )
                        ],
                      ),
                  ],
                ),
              );
            } else {
              return Container(
                child: Text('Event not found!'),
              );
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return threeBounceLoader;
        },
      ),
    );
  }
}
