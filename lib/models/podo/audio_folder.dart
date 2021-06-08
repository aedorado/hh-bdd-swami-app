class AudioFolder {
  late String id;
  late String name;
  late String contentUrl;
  late String totalContents;

  AudioFolder({required this.id, required this.name, required this.contentUrl, required this.totalContents});

  AudioFolder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contentUrl = json['content_url'];
    totalContents = json['total_contents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['content_url'] = this.contentUrl;
    data['total_contents'] = this.totalContents;
    return data;
  }
}