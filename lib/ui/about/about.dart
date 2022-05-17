import 'package:float_column/float_column.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        StickyHeader(
          header: Container(
            height: 50.0,
            color: Colors.blueGrey[700],
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'HH Bhakti Dhira Damodara Swami',
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FloatColumn(
              children: const [
                Floatable(
                  float: FCFloat.start,
                  maxWidthPercentage: 0.25,
                  padding: EdgeInsetsDirectional.only(end: 12),
                  child: FlutterLogo(size: 100),
                ),
                WrappableText(
                    text: TextSpan(
                        text: 'BIG TITLE',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                WrappableText(
                    text: TextSpan(
                        text: 'Little subtitle',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                WrappableText(text: TextSpan(text: 'About BDDS')),
              ],
            ),
          ),
        ),
        StickyHeader(
          header: Container(
            height: 50.0,
            color: Colors.blueGrey[700],
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Spiritual Connection',
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FloatColumn(
              children: const [
                Floatable(
                  float: FCFloat.start,
                  maxWidthPercentage: 0.25,
                  padding: EdgeInsetsDirectional.only(end: 12),
                  child: FlutterLogo(size: 100),
                ),
                WrappableText(
                    text: TextSpan(
                        text: 'Did you get you own copy yet?',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                WrappableText(
                    text: TextSpan(
                        text: 'Little subtitle',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                WrappableText(
                    text: TextSpan(
                        text:
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sed erat efficitur, tincidunt purus ut, fermentum erat. Morbi vitae nulla lorem. Ut ac velit tempus, semper ante quis, iaculis nibh. Suspendisse potenti.')),
                WrappableText(
                    text: TextSpan(
                        text:
                            'Get you copy today by clicking on the link below:')),
              ],
            ),
          ),
        ),
        StickyHeader(
          header: Container(
            height: 50.0,
            color: Colors.blueGrey[700],
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Surabhi Farm',
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FloatColumn(
              children: const [
                Floatable(
                  float: FCFloat.start,
                  maxWidthPercentage: 0.25,
                  padding: EdgeInsetsDirectional.only(end: 12),
                  child: FlutterLogo(size: 100),
                ),
                WrappableText(
                    text: TextSpan(
                        text: 'Did you get you own copy yet?',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                WrappableText(
                    text: TextSpan(
                        text: 'Little subtitle',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                WrappableText(
                    text: TextSpan(
                        text:
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sed erat efficitur, tincidunt purus ut, fermentum erat. Morbi vitae nulla lorem. Ut ac velit tempus, semper ante quis, iaculis nibh. Suspendisse potenti. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sed erat efficitur, tincidunt purus ut, fermentum erat. Morbi vitae nulla lorem. Ut ac velit tempus, semper ante quis, iaculis nibh. Suspendisse potenti. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sed erat efficitur, tincidunt purus ut, fermentum erat. Morbi vitae nulla lorem. Ut ac velit tempus, semper ante quis, iaculis nibh. Suspendisse potenti. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sed erat efficitur, tincidunt purus ut, fermentum erat. Morbi vitae nulla lorem. Ut ac velit tempus, semper ante quis, iaculis nibh. Suspendisse potenti. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sed erat efficitur, tincidunt purus ut, fermentum erat. Morbi vitae nulla lorem. Ut ac velit tempus, semper ante quis, iaculis nibh. Suspendisse potenti. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sed erat efficitur, tincidunt purus ut, fermentum erat. Morbi vitae nulla lorem. Ut ac velit tempus, semper ante quis, iaculis nibh. Suspendisse potenti.')),
              ],
            ),
          ),
        ),
        StickyHeader(
          header: Container(
            height: 50.0,
            color: Colors.blueGrey[700],
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Contact Us',
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FloatColumn(
              children: const [
                Floatable(
                  float: FCFloat.start,
                  maxWidthPercentage: 0.25,
                  padding: EdgeInsetsDirectional.only(end: 12),
                  child: FlutterLogo(size: 100),
                ),
                WrappableText(
                    text: TextSpan(
                        text: 'Did you get you own copy yet?',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                WrappableText(
                    text: TextSpan(
                        text: 'Little subtitle',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                WrappableText(
                    text: TextSpan(
                        text:
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sed erat efficitur, tincidunt purus ut, fermentum erat. Morbi vitae nulla lorem. Ut ac velit tempus, semper ante quis, iaculis nibh. Suspendisse potenti.')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
