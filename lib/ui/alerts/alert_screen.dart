import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/alert.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class Item {
  Item({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.link,
    required this.epochTime,
    this.buttonNeeded = true,
    this.isExpanded = false,
  }) {
    if (this.type.toLowerCase() == "zoom") {
      this.buttonText = "Join on Zoom";
    } else if (this.type.toLowerCase() == "youtube") {
      this.buttonText = "Join on Youtube";
    } else if (this.type.toLowerCase() == "facebook") {
      this.buttonText = "Join on Facebook";
    } else {
      this.buttonNeeded = false;
      this.buttonText = "";
    }

    this.timeAgo = funcTimeAgo(DateTime.fromMillisecondsSinceEpoch(epochTime));
  }

  String funcTimeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "A few seconds now";
  }

  String id;
  String title;
  String subtitle;
  bool isExpanded;
  String link;
  String type;
  bool buttonNeeded;
  int epochTime;
  late String timeAgo;
  late String buttonText;
}

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _AlertScreenState extends State<AlertScreen> {
  Box<Alert> alertsBox = Hive.box<Alert>(HIVE_BOX_ALERTS);
  final List<Alert> allAlerts = [];
  final List<Item> _data = []; // generateItems(8);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    alertsBox.values.forEach((alert) => _data.add(Item(
          id: alert.id,
          type: alert.type,
          title: alert.title,
          subtitle: alert.subtitle,
          link: alert.link,
          epochTime: alert.receivedAt,
        )));
    _data.sort((a, b) => a.epochTime > b.epochTime ? -1 : 1);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Container(
        child: ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.only(top: 5.0),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _data[index].isExpanded = !isExpanded;
            });
          },
          children: _data.map<ExpansionPanel>((Item item) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  // isThreeLine: true,
                  leading: Icon(Icons.notifications_none),
                  title: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(item.title),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(item.subtitle),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          item.timeAgo,
                          style: TextStyle(color: Colors.grey[900]),
                        ),
                      ),
                    ],
                  ),
                );
              },
              body: Container(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () async {
                    if (await canLaunch(item.link)) {
                      await launch(item.link);
                    } else {
                      throw 'Could not launch ${item.link}';
                    }
                  },
                  child:
                      item.buttonNeeded ? Text(item.buttonText) : Container(),
                ),
              ),
              isExpanded: item.isExpanded,
            );
          }).toList(),
        ),
      ),
    );
  }
}
