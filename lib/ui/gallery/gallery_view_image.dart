import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/gallery_image.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ViewImageScreen extends StatefulWidget {
  late int index = 0;
  late List<GalleryImage> imagesList;

  ViewImageScreen({required this.imagesList, required this.index});

  @override
  _ViewImageScreenState createState() => _ViewImageScreenState();
}

class _ViewImageScreenState extends State<ViewImageScreen> with SingleTickerProviderStateMixin {
  Box favoriteImagesBox = Hive.box<GalleryImage>(HIVE_BOX_FAVORITE_IMAGES);
  bool shouldShowSnackbar = true;

  final TransformationController _transformationController = TransformationController();
  Animation<Matrix4>? _animationReset;
  late final AnimationController _controllerReset;

  void _onAnimateReset() {
    _transformationController.value = _animationReset!.value;
    if (!_controllerReset.isAnimating) {
      _animationReset!.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(_controllerReset);
    _animationReset!.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

  // Stop a running reset to home transform animation.
  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  @override
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    _animateResetInitialize();
  }

  @override
  void dispose() {
    _controllerReset.dispose();
    super.dispose();
  }

  // TODO Working code for download feature
  // _toastInfo(String info) {
  //   Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  // }
  //
  // _requestPermission() async {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.storage,
  //   ].request();
  // }
  //
  // _saveImage(GalleryImage galleryImage) async {
  //   _toastInfo("Downloading Image");
  //   var response = await Dio().get(galleryImage.downloadURL, options: Options(responseType: ResponseType.bytes));
  //   final result =
  //       await ImageGallerySaver.saveImage(Uint8List.fromList(response.data), quality: 60, name: galleryImage.id);
  //   _toastInfo("Image saved to Gallery");
  // }
  //
  // downloadFile(GalleryImage galleryImage) async {
  //   await _requestPermission();
  //   await _saveImage(galleryImage);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Hero(
                tag: this.widget.imagesList[widget.index].displayURL,
                child: InteractiveViewer(
                  minScale: 0.1,
                  maxScale: 2,
                  panEnabled: false,
                  onInteractionStart: _onInteractionStart,
                  onInteractionEnd: _onInteractionEnd,
                  transformationController: _transformationController,
                  child: CachedNetworkImage(
                    imageUrl: this.widget.imagesList[widget.index].displayURL,
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
            Flexible(
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: const Color(0xFF42A5F5)),
                child: Row(
                  children: [
                    // TODO Restore download button when needed
                    // Expanded(
                    //     flex: 1,
                    //     child: Container(
                    //         child: IconButton(
                    //             icon: Icon(Icons.download_sharp),
                    //             onPressed: () {
                    //               downloadFile(this.widget.galleryImage);
                    //             }))),
                    Expanded(
                        flex: 1,
                        child: Container(
                            child: IconButton(
                                icon: Icon(Icons.chevron_left),
                                onPressed: () {
                                  setState(() {
                                    widget.index =
                                        widget.index == 0 ? (widget.imagesList.length - 1) : widget.index - 1;
                                  });
                                }))),
                    Expanded(
                        flex: 1,
                        child: Container(
                            child: ValueListenableBuilder(
                                valueListenable: favoriteImagesBox.listenable(),
                                builder: (context, Box box, w) {
                                  var isAleadyAddedToFavorites =
                                      box.get(this.widget.imagesList[this.widget.index].id) != null;
                                  return IconButton(
                                      icon: Icon(
                                        isAleadyAddedToFavorites ? Icons.favorite : Icons.favorite_border,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () {
                                        if (isAleadyAddedToFavorites) {
                                          favoriteImagesBox.delete(this.widget.imagesList[this.widget.index].id);
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
                                          favoriteImagesBox.put(
                                              widget.imagesList[widget.index].id, widget.imagesList[widget.index]);
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
                                }))),
                    Expanded(
                        flex: 1,
                        child: Container(
                            child: IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {
                                  setState(() {
                                    widget.index = (widget.index + 1) % widget.imagesList.length;
                                  });
                                }))),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListView(
                  children: [
                    _descriptionTextBox('${widget.imagesList[widget.index].description}', 20),
                    _descriptionTextBox('${widget.imagesList[widget.index].date}', 14),
                    _descriptionTextBox('${widget.imagesList[widget.index].location}', 14),
                    _descriptionTextBox('${widget.imagesList[widget.index].tags}', 14),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _descriptionTextBox(String s, double fontSize) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        child: Text(
          '$s',
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}

class FavoritesImagesSnackBar extends StatelessWidget {
  final String favoritesActionPerformed;
  late final String _snackBarText;

  FavoritesImagesSnackBar({required this.favoritesActionPerformed}) {
    if (this.favoritesActionPerformed == FAVORITES_ACTION_REMOVE) {
      _snackBarText = 'Removed from Favorites';
    } else {
      _snackBarText = 'Added to Favorites';
    }
  }

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      content: Text(_snackBarText),
      duration: Duration(milliseconds: 1000),
    );
  }
}
