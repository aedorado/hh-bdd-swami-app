class Audio {
  String name;
  String url;

  Audio({this.name, this.url});

  Audio.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Name: ${this.name}, URL: ${this.url}';
  }

}