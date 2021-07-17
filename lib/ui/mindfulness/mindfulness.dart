import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/blog.dart';
import 'package:hh_bbds_app/ui/gallery/gallery_view_image.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MindfulnessScreen extends StatelessWidget {
  Box favoriteBlogsBox = Hive.box(HIVE_BOX_FAVORITE_BLOGS);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFE0E2E1),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('blogs').orderBy('date', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (context, index) {
                  int maxTextLength = 100;
                  Blog blog = Blog.fromFirebaseMessage(snapshot.data!.docs[index]);
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 4.0),
                        ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  blog.title,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text.rich(TextSpan(
                                  children: <InlineSpan>[
                                    TextSpan(
                                        text: blog.content.length > maxTextLength
                                            ? blog.content.substring(0, maxTextLength) + "..."
                                            : blog.content),
                                    blog.content.length > maxTextLength
                                        ? WidgetSpan(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder: (context) => MindfulnessArticle(blog)));
                                              },
                                              child: Text(
                                                'read more!',
                                                style: TextStyle(color: Colors.blue),
                                              ),
                                            ),
                                          )
                                        : TextSpan(),
                                  ],
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Hero(
                                  tag: blog.image,
                                  child: Container(
                                    height: 248,
                                    child: CachedNetworkImage(
                                      imageUrl: blog.image,
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
                              ),
                              MindfulnessBottomBar(blog: blog),
                            ],
                          ),
                        )),
                  );
                },
                itemCount: snapshot.data!.size,
              );
              // return MindfulnessArticle();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('An error occurred'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class MindfulnessArticle extends StatelessWidget {
  late Blog blog;

  MindfulnessArticle(Blog blog) {
    this.blog = blog;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // TODO add appbar color from image
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 300.0,
              floating: true,
              pinned: false,
              snap: true,
              actionsIconTheme: IconThemeData(opacity: 0.0),
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: Hero(
                    tag: blog.image,
                    child: CachedNetworkImage(
                      imageUrl: blog.image,
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
                  )),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  blog.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: Text(
                      blog.content,
                      style: TextStyle(fontSize: 18),
                    )),
                  );
                },
                childCount: 1, // this.snapshot.data!.size,
              ),
            ),
            SliverToBoxAdapter(
              child: MindfulnessBottomBar(
                blog: blog,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MindfulnessBottomBar extends StatefulWidget {
  Blog blog;

  MindfulnessBottomBar({required this.blog});

  @override
  _MindfulnessBottomBarState createState() => _MindfulnessBottomBarState();
}

class _MindfulnessBottomBarState extends State<MindfulnessBottomBar> {
  bool shouldShowSnackbar = true;

  Box favoriteBlogsBox = Hive.box(HIVE_BOX_FAVORITE_BLOGS);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${widget.blog.date.toString().substring(0, 10)}'),
          Container(
              child: ValueListenableBuilder(
                  valueListenable: favoriteBlogsBox.listenable(),
                  builder: (context, Box box, w) {
                    var isAlreadyAddedToFavorites = box.get(widget.blog.id) != null;
                    return InkWell(
                        child: Icon(
                          isAlreadyAddedToFavorites ? Icons.favorite : Icons.favorite_border,
                          color: Colors.redAccent,
                        ),
                        onTap: () {
                          if (isAlreadyAddedToFavorites) {
                            favoriteBlogsBox.delete(widget.blog.id);
                            if (shouldShowSnackbar) {
                              ScaffoldMessenger.of(context).showSnackBar(FavoritesImagesSnackBar(
                                favoritesActionPerformed: FAVORITES_ACTION_REMOVE,
                              ).build(context));
                              setState(() {
                                this.shouldShowSnackbar = false;
                              });
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  this.shouldShowSnackbar = true;
                                });
                              });
                            }
                          } else {
                            favoriteBlogsBox.put(widget.blog.id, widget.blog.id);
                            if (shouldShowSnackbar) {
                              ScaffoldMessenger.of(context).showSnackBar(FavoritesImagesSnackBar(
                                favoritesActionPerformed: FAVORITES_ACTION_ADD,
                              ).build(context));
                              setState(() {
                                this.shouldShowSnackbar = false;
                              });
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  this.shouldShowSnackbar = true;
                                });
                              });
                            }
                          }
                        });
                  })),
        ],
      ),
    );
  }
}
