import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/ui/audio/audio_constants.dart';
import 'package:hive/hive.dart';

class AudioSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        query = "";
        close(context, "false");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Box hiveBox = Hive.box(HIVE_BOX_AUDIO_SEARCH);

    if (query.isEmpty) {
      var suggestionList = hiveBox.get('search_audios_1');
      suggestionList = (suggestionList == null) ? [] : suggestionList.reversed.toList();
      return ListView.builder(
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            _updateSavedSuggestions(hiveBox, suggestionList[index]);
            // HIVE_BOX_AUDIO_SEARCH_SELECTED_ITEM
            // TODO - pass the type that we select form hive list
            query = suggestionList[index];
            // close(context, "true");
          },
          leading: Icon(Icons.music_note),
          title: Text(suggestionList[index]),
        ),
        itemCount: suggestionList.length,
      );
    } else if (query.length > 2) {
      return StatefulBuilder(
        builder: (context, setState) {
          return StreamBuilder<QuerySnapshot>(
            stream: _firestoreSnapshots[_selectedSearchFilter],
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var docs = _filterDocs(snapshot.data!.docs, query);
                return Column(
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              scrollDirection: Axis.horizontal,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: _searchScreenSuggestionBoxes.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6, bottom: 6),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                        decoration: new BoxDecoration(
                                          border: this._selectedSearchFilter == index
                                              ? Border(bottom: BorderSide(width: 2.0, color: Color(0xFF005CB2)))
                                              : null,
                                        ),
                                        height: 32,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              this._selectedSearchFilter = index;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                _searchScreenSuggestionBoxes[index].toUpperCase(),
                                                style: this._selectedSearchFilter == index
                                                    ? TextStyle(
                                                        color: Color(0xFF005CB2),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w700)
                                                    : TextStyle(color: Colors.black, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  _updateSavedSuggestions(hiveBox, docs[index]['name']);
                                  hiveBox.put(HIVE_BOX_AUDIO_SEARCH_KEY_SELECTED_ITEM, docs[index]['id']);
                                  close(context, this._searchScreenSuggestionBoxes[this._selectedSearchFilter]);
                                },
                                leading: Icon(Icons.music_note),
                                title: Text(docs[index]['name'] ?? ''),
                              );
                            }),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void _updateSavedSuggestions(Box hiveBox, String suggestion) {
    var recentSearches = hiveBox.get('search_audios_1');
    recentSearches = (recentSearches == null) ? [] : recentSearches.reversed.toList();

    if (!recentSearches.contains(suggestion)) {
      recentSearches = recentSearches.reversed.toList();
      recentSearches.add(suggestion);
    } else {
      recentSearches = recentSearches.reversed.toList();
      recentSearches.removeWhere((item) => item == suggestion);
      recentSearches.add(suggestion);
    }
    if (recentSearches.length > 5) {
      recentSearches.removeAt(0);
    }
    hiveBox.put('search_audios_1', recentSearches);
  }

  List<QueryDocumentSnapshot<Object?>> _filterDocs(List<QueryDocumentSnapshot<Object?>> docs, String query) {
    query = query.trim().toLowerCase();
    List<QueryDocumentSnapshot<Object?>> matchedByName = [];
    List<QueryDocumentSnapshot<Object?>> matchedByTags = [];
    var matchedSet = new Set();

    if (this._searchScreenSuggestionBoxes[this._selectedSearchFilter] == SERIES ||
        this._searchScreenSuggestionBoxes[this._selectedSearchFilter] == SEMINARS) {
      matchedByName = docs.where((element) {
        return (element['name'] as String).toLowerCase().contains(query);
      }).toList();
    } else if (this._searchScreenSuggestionBoxes[this._selectedSearchFilter] == TRACKS ||
        this._searchScreenSuggestionBoxes[this._selectedSearchFilter] == SHORT_AUDIOS) {
      // all audios and short audios
      matchedByName = docs.where((element) {
        bool isAMatch = (element['name'] as String).toLowerCase().contains(query);
        if (isAMatch) matchedSet.add(element['id']);
        return isAMatch;
      }).toList();
      matchedByTags = docs
          .where((element) => (!matchedSet.contains(element['id']) &&
              docs.contains('tags') &&
              (element['tags'] as String).toLowerCase().contains(query)))
          .toList();
    }

    return [...matchedByName, ...matchedByTags];
  }

  var _searchScreenSuggestionBoxes = [
    TRACKS,
    SERIES,
    SEMINARS,
    // SHORT_AUDIOS,
  ];
  int _selectedSearchFilter = 0;
  var _firestoreSnapshots = [
    FirebaseFirestore.instance.collection("audios").snapshots(),
    FirebaseFirestore.instance.collection("series").snapshots(),
    FirebaseFirestore.instance.collection("seminars").snapshots(),
    // FirebaseFirestore.instance.collection("audios").where('isShortAudio', isEqualTo: true).snapshots(),
  ];
}
