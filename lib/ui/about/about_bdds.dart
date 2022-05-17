import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutBDDS extends StatelessWidget {
  const AboutBDDS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bhakti Dhira Damodra Swami'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 248,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/A.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: null),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('''
                 Bhakti Dhira Damodara Swami was born Oko Odama on 8th of June 1957 in an East Nigerian Village near the city of Calabar. Although his village had a rich tradition of the African Traditional Religion (ATR), he was trained as a Roman Catholic. From a very young age he had been concerned with the question - What happens after death?
                
                 “I would ponder on the topics of reincarnation and death, day and night, so much so that  I would have sleepless nights” - he says. After studying the story of King Saul, he learnt how to pray. Every night he would pray to God - “Please let me know you. Please reveal yourself to me.”

                 His prayers were finally answered in 1980 when he came in contact with the Hare Krishna Movement - which is based on the science of Bhakti-Yoga : the path to know and love God. In Lagos, Nigeria, he came across an advert in the Daily Times newspaper by the Hare Krishna movement. Inspired, he made a visit to the ISKCON Temple in Lagos. There, he not only very much enjoyed the prasādam (spiritual food), music, and dance in the company of the devotees, but was also very satisfied with the answers to his questions on reincarnation and karma .He became very attracted to the sweetness of the philosophy. Hence, in 1982 he moved to the temple as a resident devotee. While in the temple he continued to work on his reggae musical album but later discontinued to dedicate himself more fully to the pursuit of spiritual life.

                 Today his spiritual teachings revolve around the applications of the Bhakti-Yoga Philosophy in daily life. We welcome you to experience the science of Krishna consciousness, from a teacher who has had an incredible journey - from the villages of Nigeria as a child asking questions to a spiritual master training disciples all across the world.
             '''),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutSpiritualConnection extends StatelessWidget {
  const AboutSpiritualConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bhakti Dhira Damodra Swami'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 248,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/A.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: null),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('''
                 “Spiritual Connection” answers the questions of Guru-Disciple relationship with much depth and clarity. Presented in a very simple and lucid manner, this book is a collection of various case-studies taken from Vedic literatures such as Srimad-Bhagavatam and Caitanya-Caritamrita, to help our spiritual connection be established, enhanced or rejuvenated.    
               '''),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutSurabhiFarm extends StatelessWidget {
  const AboutSurabhiFarm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surabhi Farm'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 248,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/A.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: null),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('''
                 Envisioned as a farm community located in Nigeria, this project aims to combine the principles of the Varnashrama system with the simplicity of farm living to build the next generation of Vaishnava leaders who can take the movement forward.
               '''),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutContactUs extends StatelessWidget {
  const AboutContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 248,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/A.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: null),
            Text('Find us on: '),
            SocialLinkRow(type: 'facebook'),
            SocialLinkRow(type: 'twitter'),
            SocialLinkRow(type: 'instagram'),
            SocialLinkRow(type: 'youtube'),
            Text('Receive Live Updates on: ')
          ],
        ),
      ),
    );
  }
}

class SocialLinkRow extends StatelessWidget {
  String type;
  IconData? icon;
  Color? color;
  String? text;

  SocialLinkRow({required this.type}) {
    switch (type) {
      case 'facebook':
        this.icon = Icons.facebook;
        this.color = Colors.blueAccent;
        this.text = '/BDDSMedia';
        break;
      case 'instagram':
        this.icon = Icons.stacked_bar_chart;
        this.color = Colors.pinkAccent;
        this.text = '/Instagram';
        break;
      case 'twitter':
        this.icon = Icons.star;
        this.color = Colors.blueAccent;
        this.text = '/twitter';
        break;
      case 'youtube':
        this.icon = Icons.youtube_searched_for;
        this.color = Colors.redAccent;
        this.text = '/ytube';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {},
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 40,
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Icon(
                    this.icon,
                    color: this.color,
                  )),
              Expanded(
                  flex: 4,
                  child: Text(
                    '/BDDSMedia',
                    style: TextStyle(color: this.color),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class LiveUpdateRow extends StatelessWidget {
  String type;
  IconData? icon;
  Color? color;
  String? text;
  String? link;

  LiveUpdateRow({required this.type}) {
    switch (type) {
      case 'facebook':
        this.icon = Icons.facebook;
        this.color = Colors.blueAccent;
        this.text = '/BDDSMedia';
        this.link = 'https://www.facebook.com/BDDSwamiMedia';
        break;
      case 'instagram':
        this.icon = Icons.stacked_bar_chart;
        this.color = Colors.pinkAccent;
        this.text = '/Instagram';
        break;
      case 'twitter':
        this.icon = Icons.star;
        this.color = Colors.blueAccent;
        this.text = '/twitter';
        break;
      case 'youtube':
        this.icon = Icons.youtube_searched_for;
        this.color = Colors.redAccent;
        this.text = '/ytube';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => {await launch(this.link ?? '')},
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 40,
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Icon(
                    this.icon,
                    color: this.color,
                  )),
              Expanded(
                  flex: 4,
                  child: Text(
                    '/BDDSMedia',
                    style: TextStyle(color: this.color),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
