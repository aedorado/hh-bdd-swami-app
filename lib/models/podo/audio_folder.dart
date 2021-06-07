class AudioFolder {
  String id;
  String name;
  String contentUrl;
  String totalContents;

  AudioFolder({this.id, this.name, this.contentUrl, this.totalContents});

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