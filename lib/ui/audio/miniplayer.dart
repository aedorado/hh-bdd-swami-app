import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:hh_bbds_app/ui/audio/page_manager.dart';

class Miniplayer extends StatelessWidget {

 @override
 Widget build(BuildContext context) {
   return ValueListenableBuilder(
         valueListenable: getIt<PageManager>().currentMediaItemNotifier,
         builder: (context, MediaItem? currentMediaItem, widget) {
           return (currentMediaItem != null) ? AnimatedContainer(
             height: 75,
             duration: Duration(milliseconds: 200),
             // Provide an optional curve to make the animation feel smoother.
             curve: Curves.easeIn,
             child: ColoredBox(
               color: Color(0xFF42A5F5),
               child: Column(
                 children: [
                   InkWell(
                     onTap: () {
                       Navigator.push(
                           context,
                           MaterialPageRoute(
                               builder: (context) => AudioPlayScreen(currentMediaItem)));
                     },
                     child: Padding(
                       padding: const EdgeInsets.all(12.0),
                       child: Row(
                         children: [
                           Expanded(
                             flex: 1,
                             child: Padding(
                               padding: const EdgeInsets.only(top: 2, left: 2, right: 2, bottom: 2),
                               child: Container(
                                 width: 42,
                                 height: 42,
                                 decoration: BoxDecoration(
                                     shape: BoxShape.circle,
                                     image: DecorationImage(
                                         image: NetworkImage(currentMediaItem.artUri.toString()))),
                               ),
                             ),
                           ),
                           Expanded(
                               flex: 5,
                               child: Center(
                                   child: Column(
                                     children: [
                                       Text(
                                         currentMediaItem.title,
                                         maxLines: 2,
                                         style: TextStyle(fontSize: 15),
                                         textAlign: TextAlign.center,
                                         overflow: TextOverflow.ellipsis,
                                       ),
                                       // Text(
                                       //   currentMediaItem.extras!['subtitle'] ?? '',
                                       //   style: TextStyle(fontSize: 9),
                                       //   overflow: TextOverflow.ellipsis,
                                       // ),
                                     ],
                                   ))),
                           Expanded(
                               flex: 1,
                               child: PlayButton(
                                 iconSize: 35.0,
                               )),
                         ],
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           )
               : Container();
         },
       );
 }
}

