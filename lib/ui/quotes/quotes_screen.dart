import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/quote.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Quotes extends StatelessWidget {
  const Quotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection(FIREBASE_QUOTES_COLLECTION).orderBy("id").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Quote> quotes = _getQuoteListFromSnapshot(snapshot.data!.docs);
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  padding: EdgeInsets.zero,
                  itemCount: quotes.length,
                  itemBuilder: (context, index) {
                    return QuoteDisplay(quoteList: quotes, index: index);
                  },
                );
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            }),
      ),
    );
  }

  _getQuoteListFromSnapshot(List<QueryDocumentSnapshot<Object?>> docs) {
    return docs.map((doc) => Quote.fromFirebaseDocumentSnapshot(doc)).toList();
  }
}

class QuoteDisplay extends StatelessWidget {
  late List<Quote> quoteList;
  late int index;
  QuoteDisplay({required this.quoteList, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Hero(
        tag: quoteList[index].url,
        child: Container(
            decoration:
                BoxDecoration(image: DecorationImage(image: NetworkImage(quoteList[index].url), fit: BoxFit.cover)),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ViewQuote(quoteList: quoteList, index: index)));
              },
              child: Container(),
            )),
      ),
    );
  }
}

class ViewQuote extends StatefulWidget {
  late List<Quote> quoteList;
  int index = 0;
  ViewQuote({required this.quoteList, required this.index});

  @override
  _ViewQuoteState createState() => _ViewQuoteState();
}

class _ViewQuoteState extends State<ViewQuote> {
  Box favoriteQuotesBox = Hive.box<Quote>(HIVE_BOX_FAVORITE_QUOTES);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 14,
              child: Hero(
                tag: this.widget.quoteList[widget.index].url,
                child: GestureDetector(
                  child: CachedNetworkImage(
                    imageUrl: this.widget.quoteList[widget.index].url,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.index = widget.index == 0 ? (widget.quoteList.length - 1) : widget.index - 1;
                          });
                        }),
                    ValueListenableBuilder(
                        valueListenable: favoriteQuotesBox.listenable(),
                        builder: (context, Box box, widget) {
                          var currentQuote = this.widget.quoteList[this.widget.index];
                          var isAlreadyAddedToFavorites = box.get(currentQuote.id) != null;
                          return IconButton(
                              icon: Icon(
                                isAlreadyAddedToFavorites ? Icons.favorite : Icons.favorite_border,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                if (isAlreadyAddedToFavorites) {
                                  favoriteQuotesBox.delete(currentQuote.id);
                                  Fluttertoast.showToast(msg: 'Removed from Favorites');
                                } else {
                                  favoriteQuotesBox.put(currentQuote.id, this.widget.quoteList[this.widget.index]);
                                  Fluttertoast.showToast(msg: 'Added to Favorites');
                                }
                              });
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.index = (widget.index + 1) % widget.quoteList.length;
                          });
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
