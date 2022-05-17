import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenCarouselCard {
  String image;
  String link;
  bool clickable;
  HomeScreenCarouselCard(
      {required this.image, required this.clickable, required this.link});
}

// ignore: must_be_immutable
class CarouselCard extends StatelessWidget {
  final HomeScreenCarouselCard card;

  CarouselCard({required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (this.card.clickable) {
          if (await canLaunch(this.card.link)) {
            await launch(this.card.link);
          } else {
            throw 'Could not launch ${this.card.link}';
          }
        }
      },
      child: Center(
        child: CachedNetworkImage(
          imageUrl: card.image,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}

class CarouselList extends StatefulWidget {
  @override
  _CarouselListState createState() => _CarouselListState();
}

class _CarouselListState extends State<CarouselList> {
  var homeCarouselCards = [];

  int totalCarouselCards = 0;
  int currentPage = 0;
  bool doneFetchingCards = false;

  PageController _pageController = PageController(
    initialPage: 0,
  );

  getCarouselCards() async {
    await FirebaseFirestore.instance
        .collection("carousel")
        .orderBy("order")
        .get()
        .then((value) {
      setState(() {
        this.doneFetchingCards = false;
      });
      value.docs.forEach((doc) {
        this.homeCarouselCards.add(HomeScreenCarouselCard(
            image: doc['image_url'],
            clickable: doc['clickable'],
            link: doc['url']));
        this.totalCarouselCards++;
      });
      setState(() {
        this.doneFetchingCards = true;
      });
    });
  }

  @override
  void initState() {
    getCarouselCards();

    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      currentPage++;

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  Widget updateIndicators() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (this.doneFetchingCards)
              for (int i = 0; i < this.totalCarouselCards; ++i)
                Container(
                  width: 7.0,
                  height: 7.0,
                  margin: EdgeInsets.symmetric(horizontal: 6.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (this.currentPage % this.totalCarouselCards == i)
                        ? Colors.amber[800]
                        : Color(0xFFA6AEBD),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: Stack(
        children: <Widget>[
          Container(
            child: this.doneFetchingCards
                ? PageView.builder(
                    itemBuilder: (context, index) {
                      return CarouselCard(
                          card: this.homeCarouselCards[index %
                              this.totalCarouselCards] // homeCarouselCards[index % snapshot.data!.size],
                          );
                    },
                    // itemCount: homeCarouselCards.length, // comment for infinite carousel
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          updateIndicators(),
        ],
      ),
    );
  }
}
