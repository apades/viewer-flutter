import 'dart:convert' show json;

class rule34s {
  List<rule34> list;

  rule34s.fromParams({this.list});

  factory rule34s(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new rule34s.fromJson(json.decode(jsonStr))
          : new rule34s.fromJson(jsonStr);

  rule34s.fromJson(jsonRes) {
    list = jsonRes['json_list'] == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes['json_list']) {
      list.add(listItem == null ? null : new rule34.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '{"json_list": $list}';
  }
}

class rule34 {
  int change;
  int height;
  int id;
  int parentId;
  int sampleHeight;
  int sampleWidth;
  int score;
  int width;
  bool sample;
  String directory;
  String hash;
  String image;
  String owner;
  String rating;
  String tags;

  rule34.fromParams(
      {this.change,
      this.height,
      this.id,
      this.parentId,
      this.sampleHeight,
      this.sampleWidth,
      this.score,
      this.width,
      this.sample,
      this.directory,
      this.hash,
      this.image,
      this.owner,
      this.rating,
      this.tags});

  rule34.fromJson(jsonRes) {
    change = jsonRes['change'];
    height = jsonRes['height'];
    id = jsonRes['id'];
    parentId = jsonRes['parent_id'];
    sampleHeight = jsonRes['sample_height'];
    sampleWidth = jsonRes['sample_width'];
    score = jsonRes['score'];
    width = jsonRes['width'];
    sample = jsonRes['sample'];
    directory = jsonRes['directory'];
    hash = jsonRes['hash'];
    image = jsonRes['image'];
    owner = jsonRes['owner'];
    rating = jsonRes['rating'];
    tags = jsonRes['tags'];
  }

  @override
  String toString() {
    return '{"change": $change,"height": $height,"id": $id,"parent_id": $parentId,"sample_height": $sampleHeight,"sample_width": $sampleWidth,"score": $score,"width": $width,"sample": $sample,"directory": ${directory != null ? '${json.encode(directory)}' : 'null'},"hash": ${hash != null ? '${json.encode(hash)}' : 'null'},"image": ${image != null ? '${json.encode(image)}' : 'null'},"owner": ${owner != null ? '${json.encode(owner)}' : 'null'},"rating": ${rating != null ? '${json.encode(rating)}' : 'null'},"tags": ${tags != null ? '${json.encode(tags)}' : 'null'}}';
  }
}

class DataItem {
  final dynamic data;

  const DataItem({this.data});
}
