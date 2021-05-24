import 'dart:async';

import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF5638f7);
const kSecondaryColor = Color(0xFF2acde3);
const kShadowColor = Color.fromRGBO(72, 76, 82, 0.16);
const kBackgroundColor = Color(0xFFE7EEFB);
const kSidebarBackgroundColor = Color(0xFFF1F4FB);
const kCardPopupBackgroundColor = Color(0xFFF5F8FF);
const kPrimaryLabelColor = Color(0xFF242629);
const kSecondaryLabelColor = Color(0xFF797F8A);
const kCourseElementIconColor = Color(0xFF17294D);

var kBodyTextStyle = TextStyle(
  fontWeight: FontWeight.normal,
  color: Colors.white,
  fontSize: 15.0,

);

var kCardDescriptionTextStyle = TextStyle(
  fontWeight: FontWeight.normal,
  color: Colors.black,
  fontSize: 12.0,
);


var kCardTitleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.black,
  fontSize: 22.0,
  decoration: TextDecoration.none,
);
var kTitle2Style = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryLabelColor,
  decoration: TextDecoration.none,
);

var kHeadlineLabelStyle = TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.w800,
  color: kPrimaryLabelColor,
  fontFamily: 'SF Pro Text',
  decoration: TextDecoration.none,
);
var kSubtitleStyle = TextStyle(
  fontSize: 16.0,
  color: kSecondaryLabelColor,
  decoration: TextDecoration.none,
);

var kActionTextStyle = TextStyle(
  fontSize: 15.0,
  color: kPrimaryColor,
  fontWeight: FontWeight.w600,
  decoration: TextDecoration.none,
);

var kLargeTitleStyle = TextStyle(
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryLabelColor,
  decoration: TextDecoration.none,
);
var kTitle1Style = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryLabelColor,
  decoration: TextDecoration.none,
);

class HomeScreenCarouselCard {
  HomeScreenCarouselCard({this.title, this.image, this.description});
  String title;
  String image;
  String description;
}

var homeCarouselCards = [
  HomeScreenCarouselCard(
      title: 'Hare Krishna',
      image: 'https://pbs.twimg.com/media/Ed8kkw6XYAIJxBe.jpg',
      description:
      'In this age of quarrel and hypocrisy, the only means of deliverance is the chanting of the holy names of the Lord. There is no other way. There is no other way. There is no other way.'),
  HomeScreenCarouselCard(
      title: 'Srimad Bhagvatam',
      image: 'https://bddswami.com/wp-content/uploads/2020/07/rs02-1.jpg',
      description:
      'Śrī Caitanya Mahāprabhu very elaborately explained the harer nāma verse of the Bṛhan-nāradīya Purāṇa, and Sārvabhauma Bhaṭṭācārya was struck with wonder to hear His explanation.'),
  HomeScreenCarouselCard(
      title: 'Chaitanya Charitamrita',
      image: 'https://bddswami.com/wp-content/uploads/2020/07/rs01-1.jpg',
      description:
      'Śrī Caitanya Mahāprabhu very elaborately explained the harer nāma verse of the Bṛhan-nāradīya Purāṇa, and Sārvabhauma Bhaṭṭācārya was struck with wonder to hear His explanation.'),
];

// ignore: must_be_immutable
class CarouselCard extends StatelessWidget {
  CarouselCard({this.card});

  HomeScreenCarouselCard card;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          // color: Colors.redAccent,
          boxShadow: [
            BoxShadow(
                color: kShadowColor, offset: Offset(0, 20), blurRadius: 10.0),
          ],
          image: DecorationImage(
              image: NetworkImage(card.image), fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.7),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            card.title,
                            style: kCardTitleStyle,
                          ),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              card.description,
                              style: kCardDescriptionTextStyle,
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
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
  // List<Container> indicators = [];
  int currentPage = 0;

  PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      currentPage++;

      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }


  Widget updateIndicators() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: homeCarouselCards.map(
                (card) {
              var index = homeCarouselCards.indexOf(card);
              return Container(
                width: 7.0,
                height: 7.0,
                margin: EdgeInsets.symmetric(horizontal: 6.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (currentPage % homeCarouselCards.length) == index ? Colors.red : Color(0xFFA6AEBD),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
          child: PageView.builder(
            itemBuilder: (context, index) {
              return CarouselCard(
                card: homeCarouselCards[index % homeCarouselCards.length],
              );
            },
            // itemCount: homeCarouselCards.length, // comment for infinite carousel
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
          ),
        ),
        updateIndicators(),
      ],
    );
  }
}