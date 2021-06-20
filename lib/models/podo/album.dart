class Album {
  late String id;
  late String name;
  late String coverUrl;
  late String description;
  late int totalImages;
  late int totalVideos;

  Album(
      {required this.id,
      required this.name,
      required this.coverUrl,
      required this.totalImages,
      required this.totalVideos,
      required this.description});

  Album.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coverUrl = json['cover_url'];
    totalImages = json['total_images'];
    totalVideos = json['total_videos'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cover_url'] = this.coverUrl;
    data['total_images'] = this.totalImages;
    data['total_videos'] = this.totalVideos;
    data['description'] = this.description;
    return data;
  }
}
