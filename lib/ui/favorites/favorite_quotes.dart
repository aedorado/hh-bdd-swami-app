import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/quote.dart';
import 'package:hh_bbds_app/ui/quotes/quotes_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteQuotes extends StatelessWidget {
  final Box favoriteQuotesBox = Hive.box<Quote>(HIVE_BOX_FAVORITE_QUOTES);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes'),
      ),
      body: Container(
        child: ValueListenableBuilder(
            valueListenable: favoriteQuotesBox.listenable(),
            builder: (context, Box box, widget) {
              if (favoriteQuotesBox.length == 0) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text('No quotes added to favorites. Visit library to add quotes to favorites list.'),
                  ),
                );
              }
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        Quote quote = favoriteQuotesBox.getAt(index);
                        List<Quote> quotes = _getQuotesList(favoriteQuotesBox);
                        return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => ViewQuote(quoteList: quotes, index: index)));
                            },
                            child: Hero(
                              tag: quote.url,
                              child: CachedNetworkImage(
                                imageUrl: quote.url,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: favoriteQuotesBox.length,
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  _getQuotesList(Box favoriteQuotesBox) {
    List<Quote> qlist = [];
    for (int i = 0; i < favoriteQuotesBox.length; ++i) {
      qlist.add(favoriteQuotesBox.getAt(i));
    }
    return qlist;
  }
}
